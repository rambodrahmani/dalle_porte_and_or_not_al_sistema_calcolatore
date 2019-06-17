#*******************************************************************************
# File: somma_elementi.s
#
#       Compilato con:
#           g++ -no-pie -g somma_elementi.s -o somma_elementi
#
#       Esempio di esecuzione:
#           ./somma_elementi
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 17/06/2019
#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
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

