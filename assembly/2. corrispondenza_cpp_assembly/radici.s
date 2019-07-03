#*******************************************************************************
# File: radici.s
#       Nel seguente esempio, si riporta un programma che calcola le radici di
#       un'equazione di secondo grado, dati i coefficienti a, b, e c
#       dell'equazione stessa. La variabile intera qq e' destinata a contenere
#       il numero delle radici (0, 1 oppure 2, dove 0 significa anche infinite
#       radici), mentre le variabili r1 e r2 sono destinate a contenere i valori
#       delle radici stesse, se queste esistono (nel caso in cui esista una sola
#       radice, questa sara' contenuta in r1). Il calcolo viene effettuato da un
#       sottoprogramma, i cui parametri (a, b, c, r1, r2 e qq) sono costituiti
#       da variabili comuni. Il programma principale main legge anzitutto i
#       valori di a, b e c, quindi richiama il sottoprogramma, e infine stampa
#       il valore di qq e (eventualmente) i valori di r1 e r2.
#
#       Compilato con
#           g++ -no-pie -g radici.s -o radici
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 03/07/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
a:    .DOUBLE   0e0     # coefficiente dell'equazione
b:    .DOUBLE   0e0     # coefficiente dell'equazione
c:    .DOUBLE   0e0     # coefficiente dell'equazione
r1:   .DOUBLE   0e0     # radice
r2:   .DOUBLE   0e0     # radice
qq:   .LONG     0       # numero delle radici
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
c4:
    .LONG   4

# sottoprogramma radici
radici:
    PUSH    %RAX            # salva il contenuto di EAX
    FLDL    a               # inserimento di un reale come reale esteso in pila
    FLDZ                    # load zero
    FCOMPP                  # confronta 'a' con zero
    FSTSW   %AX             # copia di SR in %AX
    TESTW   $0x4000, %AX    # test di C3
    JZ      due             # salto se 'a' diverso da zero (ovvero C3 = 0)
    FLDL    b               # inserimento di un reale come reale esteso in pila
    FLDZ                    # load zero
    FCOMPP                  # come per 'a', confronta 'b' con zero
    FSTSW   %AX
    TESTW   $0x4000, %AX    # test di C3, (C3 = 0 implica che ST e' diverso)
    JZ      uno
    MOVL    $0, qq          # azzera qq
    JMP     fine

# una sola radice
uno:
    MOVL    $1, qq      # mette a 1 qq
    FLDL    c           # immissione di c in pila
    FCHS                # change sign
    FDIVL   b           # divisione per b
    FSTPL   r1          # real store and pop: memorizza in r1 ed estrai
    JMP     fine        # salto incondizionato a fine

# due radici
due:
    FLDL    b            # immissione di b
    FMULL   b            # moltiplicazione per b (calcolo b^2)
    FILDL   c4           # immissione di 4
    FMULL   a            # moltiplicazione per a (calcolo 4*a)
    FMULL   c            # moltiplicazione per c (calcolo 4*a*c)
    FSUBRP  %ST, %ST(1)  # calcolo di Delta (b^2 - 4ac) in ST(1) ed estrazione
    FLDZ                 # immissione di zero
    FCOMP   %ST(1)       # confronto di 0 con Delta ed estrazione
    FSTSW   %AX          # copia di SR in AX
    TESTW   $0x4100, %AX # risulta zero se ST maggiore (C3 C0 = 00) (Delta > 0)
    JNZ     avanti       # salto se 0 minore o uguale di Delta (Delta >= 0)
    MOVL    $0, qq       # azzera il contenuto di qq
    JMP     fine

avanti:
    FSQRT               # calcolo la radice di Delta
    MOVL    $2, qq      # copia 2 in qq
    FLDL    b           # immissione di b
    FCHS                # cambio di segno (- b)
    FADD    %ST(1), %ST # -b + radice di Delta
    FLDL    a           # immissione di a
    FADDL   a           # 2*a
    FDIVRP  %ST, %ST(1) # calcolo di una radice ((-b + sqrt(D)) / a)
    FSTPL   r1          # memorizzazione in r1 ed estrazione
    FLDL    b           # immissione di b
    FCHS                # cambio di segno (-b)
    FSUB    %ST(1), %ST # -b - radice di Delta
    FLDL    a           # immissione di a
    FADDL   a           # 2*a
    FDIVRP  %ST, %ST(1) # calcolo di una radice ed estrazione
    FSTPL   r2          # memorizzazione in r2 ed estrazione
    FCOMP   %ST         # estrazione a vuoto di Delta

fine:
    POP     %RAX        # ripristina il contenuto di EAX
    RET

#-------------------------------------------------------------------------------
main:
    CALL    leggireale
    FSTPL   a
    CALL    leggireale
    FSTPL   b
    CALL    leggireale
    FSTPL   c
    CALL    radici
    MOVQ    qq, %RDI
    CALL    scriviintero
    CALL    nuovalinea
    CMPL    $0, qq
    JNE     oltre1
    JMP     esci

# 1 radice
oltre1:
    CMPL    $1, qq
    JNE     oltre2
    FLDL    r1
    CALL    scrivireale
    JMP     esci

# 2 radici
oltre2:
    FLDL    r1
    CALL    scrivireale
    CALL    scrivispazio
    FLDL    r2
    CALL    scrivireale
    CALL    nuovalinea

# termina e ritorna
esci:
    XOR     %RAX, %RAX  # execution result 0
    RET                 # return main

