#*******************************************************************************
# File: somma_vettori.s
#       Legge 20 interi con cui popola due vettori e fornisce infine un vettore
#       che ha come elementi la somma degli elementi corrispondenti dei due
#       vettori iniziali.
#
#       Compilato con:
#           g++ -no-pie -g somma_vettori.s -o somma_vettori
#
#       Esempio di esecuzione:
#           ./somma_vettori
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 17/06/2019
#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
vett1:  .FILL   10, 4, 0
vett2:  .FILL   10, 4, 0
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    MOVB    $10, %R12B      # lettura dei 20 interi con cui popolare vett1 e
    MOVQ    $vett1, %RBX    # vett2

anc1:
    CALL    leggiintero
    MOVQ    %RAX, (%RBX)
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     anc1

    MOVB    $10, %R12B
    MOVQ    $vett2, %RBX

anc2:
    CALL    leggiintero
    MOVQ    %RAX, (%RBX)
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     anc2

                            # somma degli elementi dei due vettori con utilizzo
                            # di RBX come registro indice e copia degli elementi
                            # risultanti in vett1
    MOVB    $10, %R12B
    MOVQ    $0, %RBX

ripeti:
    MOVQ    vett1(%RBX), %RAX
    ADDQ    vett2(%RBX), %RAX
    MOVQ    %RAX, vett1(%RBX)
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     ripeti

                           # scrittura del contenuto di vett1
    MOVB    $10, %R12B
    MOVQ    $0, %RBX
ancora:
    MOVQ    vett1(%RBX), %RDI
    CALL    scriviintero
    CALL    scrivispazio
    ADDQ    $4, %RBX
    SUBB    $1, %R12B
    JNZ     ancora
    CALL    nuovalinea

    XORQ    %RAX, %RAX      # [0]
    RET

# [0]
# XORQ %RAX, %RAX is equivalent to MOV %EAX, 0, but for some reason, GCC uses
# the xor method for optimization.

