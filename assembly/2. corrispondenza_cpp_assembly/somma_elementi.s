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
    MOVB    $10, %R12B
    MOVQ    $vett, %RBX

ancora:                     # lettura degli elementi del vettore
    CALL    leggiintero
    MOVQ    %RAX, (%RBX)
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     ancora

    MOVQ    $0, %RAX
    MOVB    $10, %R12B
    MOVQ    $vett, %RBX

ripeti:
    ADDQ    (%RBX), %RAX
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     ripeti
    MOVQ    %RAX, risultato

    MOVQ    risultato, %RDI # scrittura del risultato
    CALL    scriviintero
    CALL    nuovalinea

    XORQ    %RAX, %RAX      # [0]
    RET

# [0]
# XORQ %RAX, %RAX is equivalent to MOV %EAX, 0, but for some reason, GCC uses
# the xor method for optimization.

