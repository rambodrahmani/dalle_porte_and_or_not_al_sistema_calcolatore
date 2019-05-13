##
#
# File: numeri_naturali.s
#       Si implementi un programma che si comporta come segue:
#           1) legge con eco da tastiera due numeri naturali A e B in base 10
#              (assumendo che siano rappresentabili su 16 bit) e un numero
#              naturale in base 10 (assumendo che sia rappresentabile su 8 bit).
#           2) se A >= B (maggiore o uguale), ovvero N = 0, termina, altrimenti
#           3) stampa a video, su una nuova riga, la sequenza di N numeri:
#                B + (B - A), B + 2*(B - A), ... , B + N*(B - A)
#              eventualmente terminando la sequenza in anticipo qualora il
#              successivo numero da stampare non appartenga all'intervallo di
#              rappresentabilita' per numeri naturali su 16 bit.
#           4) ritorna al punto 1).
#
#       Esempio:
#           A: 0013
#           B: 0025
#           N: 05
#           37 49 61 73 85
#
#       Esempio:
#           A: 0000
#           B: 9000
#           N: 12
#           18000 27000 36000 45000 54000 63000
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 13/05/2019.
#
##

.INCLUDE "C:/amb_GAS/utility"

.DATA
    A:  .WORD   0x000
    B:  .WORD   0x000

.TEXT

.GLOBAL _main
_main:
    NOP

inizio:
    CALL  newline
    CALL  newline

# 1. legge e salva in memoria A, B ed N
    MOV   $'A', %AL
    CALL  outchar
    MOV   $':', %AL
    CALL  outchar           # stampa 'A:'
    CALL  indecimal_short
    MOV   %AX, A            # salva il decimale letto in A
    CALL  newline

    MOV   $'B', %AL
    CALL  outchar
    MOV   $':', %AL
    CALL  outchar           # stampa 'B:'
    CALL  indecimal_short
    MOV   %AX, B            # salva il decimale letto in B
    CALL  newline

    MOV   $'N', %AL
    CALL  outchar
    MOV   $':', %AL
    CALL  outchar           # stampa 'N:'
    CALL  indecimal_tiny
    MOV   %AL, %CL          # salva il decimale letto in CL
    CALL  newline

# 2. se A >= B, ovvero se N = 0, termina

    CMP   $0, %CL
    JE    fine          # se N = 0, termina
    MOV   A, %AX
    MOV   B, %DX
    CMP   %DX, %AX
    JAE   fine       # salta se il primo operando e' maggiore o uguale del
                     # secondo operando della CMP

# 3. 
    SUB   %AX, %DX  # DX = DX - AX = B - A
    MOV   B, %AX

ciclo:
    ADD   %DX, %AX  # AX = AX + DX = B + (B - A)
    JC    inizio

# si evita di fare i prodotti 2*(B - A), ... , N*(B - A) in quanto quando faccio
# la somma N-esima DX contiene gia' (B - A) N-1 volte.

stampa:
    CALL  outdecimal_short  # stampa il contenuto di AX
    PUSH  %AX               # salva il contenuto di AX
    MOV   $' ', %AL
    CALL  outchar           # stampa il carattere ' '
    POP   %AX               # ripristina il contenuto di AX
    DEC   %CL               # decrementa il contatore CL (N)
    JNZ   ciclo             # ripeti il ciclo se il contatore e' diverso da zero
    JMP   inizio            # altrimenti abbiamo finito, ripeti il programma

fine:
    CALL  exit      # termina

