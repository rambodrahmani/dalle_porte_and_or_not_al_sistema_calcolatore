##
#
# File: coefficiente_binomiale.s
#       Si scriva un programma che calcola e mette nella variabile di memoria
#       risultato il coefficiente binomiale (A B), calcolato come
#       A!/[B! * (A - B)!]. Si assuma che A e B siano due numeri naturali minori
#       di 10, con A maggiore o uguale a B, contenuti in memoria. Si ponga
#       particolare attenzione nel dimensionare correttamente le variabili in
#       memoria (a partire da risultato) per le moltiplicazioni e le divisioni.
#       Si faccia uso di un sottoprogramma per il calcolo del fattoriale di un
#       numero.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/05/2019.
#
##

.INCLUDE "util.s"

.DATA
    A:          .BYTE   9
    B:          .BYTE   5
    A_fatt:     .BYTE   0
    B_fatt:     .BYTE   0
    AB_fatt:    .BYTE   0   # (A - B)!
    den:        .LONG   0
    risultato:  .WORD   0

.TEXT

.GLOBAL _start
_start:
    NOP
    MOV B, %AL
    CMP %AL, A      # se A < B, termina
    JB  fine_prog   

    # si tenga presente che 0! = 1 e 9! = 362000.

    MOV   B, %CL         # copio B in CL per la chiamata a 'fatt'
    CALL  fatt           # calcolo il fattoriale di B
    MOV   %EAX, B_fatt   # salvo il fattoriale di B restituito in EAX
    MOV   A, %CL         # copio A in CL per la chiamata a 'fatt'
    CALL  fatt           # calcolo il fattoriale di A
    MOV   %EAX, A_fatt   # salvo il fattoriale di A restituito in EAX
    SUB   B, %CL         # CL = CL - B = A - B
    CALL  fatt           # calcola (A - B)!
    MOV   %EAX, AB_fatt  # salva (A - B)!
    MOV   B_fatt, %EDX   # ricordiamo inoltre che (A - B)! si trova in EAX
    MUL   %EDX           # calcola B! * (A - B)!
    MOV   %EAX, den      # salva B! * (A - B)! in 'den'
    MOV   $0, %EDX
    MOV   A_fatt, %EAX
    DIVL  den            # In EAX c'e' il quoziente della divisione, che e' il
                         # risultato che ci interessa. Sta sicuramente su 16 bit
                         # in quanto il max e' (9 4), che fa
                         # 362880 / (24 * 120) = 126.
    MOV   %AX, risultato

fine_prog:
    JMP uscita

#-------------------------------------------------------------------------------
# Sottoprogramma 'fatt'
# Calcola in EAX il fattoriale del numero passato in CL, ammesso che stia su 32
# bit.
#-------------------------------------------------------------------------------
fatt:
    MOV   $1, %EAX
    CMP   $1, %CL
    JBE   fine_fatt   # il fattoriale di 1 vale 0

    #PUSH  %ECX
    #PUSH  %EDX
    # Although most 32bit registers persist into 64bit architectures, they are
    # no longer capable of interacting with the stack. Therefore, trying to push
    # or pop %eax is an illegal operation. So if you wish to play with the
    # stack, you must use %rax, which is the 64bit architectures equivalent of
    # %eax.
    PUSH  %RCX        # salvo il contenuto dei registri
    PUSH  %RDX

    AND   $0x000000FF, %ECX  # ci servono gli 8 bit di ECX, infatti la maschera
                             # 0x000000FF = 0000 0000 ... 0000 1111 1111.

ciclo_f:
    MUL  %ECX       # calcolo il fattoriale del numero che si trova in ECX
    DEC  %ECX
    JNZ  ciclo_f

    #POP  %EDX
    #POP  %ECX

    POP  %RDX   # ripristino il contenuto dei registri
    POP  %RCX

fine_fatt:
    RET     # ritorno al programma chiamante

