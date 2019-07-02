#*******************************************************************************
# File: somma_elementi.s
#       Legge da tastiera 10 interi con cui popola un vettore e stampa infine la
#       somma dei dieci elementi del vettore.
#
#       Compilato con:
#           g++ -no-pie -g somma_elementi.s -o somma_elementi
#
#       Esempio di esecuzione:
#           ./somma_elementi
#           0
#           1
#           2
#           3
#           4
#           5
#           6
#           7
#           8
#           9
#           45
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 17/06/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
risultato:  .long   0
vett:       .fill   10, 4, 0
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    MOVB    $10, %R12B      # contatore numero di elementi del vettore
    MOVQ    $vett, %RBX

ancora:                     # lettura degli elementi del vettore
    CALL    leggiintero     # legge un intero in %RAX
    MOVQ    %RAX, (%RBX)    # copia dell'intero letto nel vettore
    ADDQ    $4, %RBX        # incrementa il puntatore al vettore
    SUBB    $1, %R12B       # decrementa il numero di elementi mancanti
    JNZ     ancora          # continua se diverso da zero

    MOVQ    $0, %RAX        # azzera RAX
    MOVB    $10, %R12B      # prepara il contatore
    MOVQ    $vett, %RBX     # copia in RBX l'indirizzo del primo elemento

ripeti:
    ADDQ    (%RBX), %RAX    # somma in RAX il valore dell'elemento puntato
    ADDQ    $4, %RBX        # incrementa il puntatore al vettore
    SUBB    $1, %R12B       # decrementa il numero di elementi mancanti
    JNZ     ripeti          # ripeti se diverso da zero
    MOVQ    %RAX, risultato # copia della somma finale in risultato

    MOVQ    risultato, %RDI # scrittura del risultato in RDI
    CALL    scriviintero    # stampa il naturale contenuto in RDI
    CALL    nuovalinea      # stampa una nuova linea

    XORQ    %RAX, %RAX      # [0]
    RET

# [0]
# XORQ %RAX, %RAX is equivalent to MOV %EAX, 0, but for some reason, GCC uses
# the xor method for optimization.

