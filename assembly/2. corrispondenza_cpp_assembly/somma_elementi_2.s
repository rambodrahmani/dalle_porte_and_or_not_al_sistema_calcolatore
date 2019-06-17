#*******************************************************************************
# File: somma_elementi_2.s
#       Programma somma elementi realizzato con sottoprogramma (parametri nei
#       registri).
#       Legge da tastiera 10 interi con cui popola un vettore e stampa infine la
#       somma dei dieci elementi del vettore.
#
#       Compilato con:
#           g++ -no-pie -g somma_elementi_2.s -o somma_elementi_2
#
#       Esempio di esecuzione:
#           ./somma_elementi_2
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
#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
risu1:      .long   0
vett1:      .fill   5, 4
risu2:      .long   0
vett2:      .fill   10, 4
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    
    XORQ    %RAX, %RAX      # [0]
    RET

# [0]
# XORQ %RAX, %RAX is equivalent to MOV %EAX, 0, but for some reason, GCC uses
# the xor method for optimization.

