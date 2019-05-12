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
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/05/2019.
#
##

.INCLUDE "C:/amb_GAS/utility"

.DATA
    messaggio:  .FILL   256,1,0     # [1]

.TEXT

.GLOBAL _main
_main:
    NOP
    MOV   $80, %CX      # numero massimo di caratteri da leggere
    LEA   messaggio, %EBX

ciclo:
    CALL  inchar        # leggi un carattere in AL
    CMP   $0x0D, %AL    
    JE    dopo

    # se non e' un carattere compreso tra 'a' e 'z' leggi un altro carattere
    CMP   $'a', %AL
    JB    ciclo
    CMP   $'z', %AL
    JA    ciclo

    CALL  outchar       # scrive il carattere in AL su terminale
    AND   $0x5F, %AL    # converti il carattere in maiuscolo [2]
    MOV   %AL, (%EBX)
    INC   %EBX
    DEC   %CX       # decrementa il numero massimo di carattere da leggere
    JNZ   ciclo     # se abbiamo ancora caratteri da leggere, ripeti il ciclo

dopo:
    MOVB  $0x0A, (%EBX)
    MOVB  $0x0D, 1(%EBX)
    CALL  newline
    LEA   messaggio, %EBX
    CALL  outline
    CALL  pause     # pausa per poter leggere l'output su video
    CALL  exit

# [1]
# {label} FILL expr{,value{,valuesize}}
# where:
#   label      is an optional label.
#   expr       evaluates to the number of bytes to fill or zero.
#   value      evaluates to the value to fill the reserved bytes with. value is
#              optional and if omitted, it is 0. value must be 0 in a NOINIT
#              area.
#   valuesize  is the size, in bytes, of value. It can be any of 1, 2, or 4.
#              valuesize is optional and if omitted, it is 1.

# [2]
# In ASCII 'a'-'z' and 'A'-'Z' are equivalent except one bit, 0x20.
#
# ASCII a = 01100001
# ASCII A = 01000001
#
# One solution would be isolating the lowercase chars and clearing or setting
# the bit 0x20 with an AND (uppercase) or OR (lowercase), respectively.
#
# Quindi, dato che
# 0x20 = 0010 0000,
# 0x5F = 0101 1111,
# per resettare il bit 0x20 facciamo quindi un AND con 0x5F che mantiene tutti i
# bit originali del carattere presente in AL e resetta il bit 0x20.

