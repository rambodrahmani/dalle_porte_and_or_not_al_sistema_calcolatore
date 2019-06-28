#*******************************************************************************
# File: caso_illustrativo_1.s
#       Caso Illustrativo 1. Fare riferimento al file caso_illustrativo_1.cpp
#       per il codice sorgente C++ di partenza.
#       
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 22/05/2019.
#*******************************************************************************

#-------------------------------------------------------------------------------
.INCLUDE "util.s"
#-------------------------------------------------------------------------------
.DATA
.GLOBAL n, m
    n:  .LONG   5
    m:  .LONG   10
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL fai

.SET a, -16     # intero, 4 byte
.SET h, -12     # intero, 4 byte
.SET k, -8      # riferimento (puntatore), 8 byte

fai:
    PUSHQ   %RBP        # prologo
    MOVQ    %RSP, %RBP
    SUBQ    $16, %RSP   # due variabili intere, ciascuna da 4 byte, e un
                        # riferimento da 8 byte

    MOVL    %EDI, h(%RBP)
    MOVL    %RSI, k(%RBP)

    ADDL    $3, h(%RBP)     # h = h + 3

    MOVL    h(%RBP), %EAX   # a = h
    MOVL    %EAX, a(%RBP)

    MOVQ    (%RBP), %RAX    # *k = *k + 4
    MOVQ    (%RAX), %EBX
    ADDL    $4, %EBX
    MOVL    %EBX, (%RAX)

    MOVL    a(%RBP), %EAX   # return a

    LEAVE   # muoiono k ed a, viene restituito il contenuto di a

.GLOBAL main:

.SET t, -8      # intero, 4 byte arrotondato ad 8

main:
    PUSHQ   %RBP
    MOVQ    %RSP, %RBP
    SUBQ    $8, %RSP
    MOVL    n(%RIP), %EDI
    LEAQ    m(%RIP), %RSI
    CALL    fai
    MOVL    %EAX, t(%RBP)   # risultato di fai in t
    MOVL    $0, %EAX
    RET

.GLOBAL _start, start
start:
_start:
    CALL  main
    JMP   uscita


