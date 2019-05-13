##
#
# File: Euclide_MCD.s
#       MCD: il massimo comune divisore di due o piu' numeri, indicato con il
#       simbolo MCD, e' il piu' grande divisore comune dei numeri considerati, e
#       viene di solito calcolato con il metodo di scomposizione in fattori
#       primi.
#
#       Scrivere un programma Assembly che si comporta come segue:
#           1. legge da tastiera due numeri naturali A e B in base 10, sotto
#              l'ipotesi che siano rappresentabili su 16 bit.
#           2. Se almeno uno dei due e' nullo, termina. Altrimenti,
#           3. esegue l'algoritmo di Euclide per il calcolo del loro MCD,
#              (riassunto di seguito), stampando tutti i risultati intermedi.
#           4. ritorna al punto 1.
#
#       L'algoritmo di Euclide per il calcolo dell'MCD tra due numeri A e B e':
#           passo 0: i=0; X(0)=A;  Y(0)=B;
#           passo i: stampa i, X(i), Y(i).
#                    se X(i)=0, allora Y(i)=MCD e l'algoritmo e' terminato.
#                    altrimenti:
#                       X(i+1)=max( X(i), Y(i) ) mod  min( X(i), Y(i) )
#                       Y(i+1)=min ( X(i), Y(i) )
#                       i=i+1
#                       ripeti
#
#       Esempio:
#           A = 15
#           B = 10
#           0) 15 10
#           1) 5 10
#           2) 0 5
#
#       Esempio:
#           A = 15120
#           B = 4389
#           0) 15120 4389
#           1) 1953 4389
#           2) 483 1953
#           3) 21 483
#           4) 0 21
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/05/2019.
#
##

.INCLUDE "C:/amb_GAS/utility"

.DATA
    X:  .WORD   0x000   # A
    Y:  .WORD   0x000   # B

.TEXT

.GLOBAL _main
_main:
    NOP
    
# 1. legge da tastiera un numero naturale a 5 cifre in base 10.
punto1:
    MOV   $'X', %AL
    CALL  outchar
    MOV   $':', %AL
    CALL  outchar           # stampa 'X:'
    CALL  indecimal_short   # legge il numero decimale da terminale in AX
    MOV   %AX, X            # salva il numero letto in X
    CALL  newline
    MOV   $'Y', %AL
    CALL  outchar
    MOV   $':', %AL
    CALL  outchar           # stampa 'Y:'
    CALL  indecimal_short   # legge il numero decimale da terminale in AX
    MOV   %AX, Y            # salva il numero letto in Y

# 2. Se A = 0 o B = 0, termina.
punto2:
    CMPW  $0, X
    JE    fine_prog
    CMPW  $0, Y
    JE    fine_prog

# 3. Esegue l'algoritmo di Euclide per il calcolo del loro MCD. In SI c'e' la
#    variabile 'i'
punto3:
    MOV   $0, %SI       # azzera il contatore SI (i)

ciclo:
    MOV   %SI, %AX
    CALL  outdecimal_short
    MOV   $')', %AL
    CALL  outchar       # stampa 'i)'
    MOV   $' ', %AL
    CALL  outchar
    MOV   X, %AX
    CALL  outdecimal_short
    CALL  newline

    CMPW  $0, X
punto4:
    JE    punto1
    MOV   X, %AX
    MOV   Y, %CX
    CMP   %AX, %CX
    JBE   dopo
    XCHG  %AX, %CX

dopo:
    MOV   $0, %DX
    DIV   %CX
    MOV   %DX, X
    MOV   %CX, Y

    INC   %SI
    JMP   ciclo

fine_prog:
    CALL  exit

