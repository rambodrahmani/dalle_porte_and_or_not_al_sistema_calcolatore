#*******************************************************************************
# File: codifica.s
#       Come secondo esempio, riportiamo il programma seguente, che:
#        1) legge un carattere e, se uguale al carattere '\n', termina,
#           altrimenti:
#        2) scrive su terminale il carattere letto seguito dal carattere spazio;
#        3) ricava dagli 8 bit del carattere letto, a partire dal bit piu'
#           significativo, 9 caratteri '0' oppure '1' (corrispondenti,
#           rispettivamente, ai bit 0 e 1), e li scrive su terminale seguiti dal
#           carattere '\n';
#        4) torna al punto 1.
#
#       In altre parole, stampa la codifica binaria dei caratteri ASCII immessi
#       su terminale.
#
#       [rambodrahmani@rr-laptop corrispondenza_cpp_assembly]$ ./codifica 
#       Stringa di prova
#       S 01010011
#       t 01110100
#       r 01110010
#       i 01101001
#       n 01101110
#       g 01100111
#       a 01100001
#         00100000
#       d 01100100
#       i 01101001
#         00100000
#       p 01110000
#       r 01110010
#       o 01101111
#       v 01110110
#       a 01100001
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/06/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.TEXT
.INCLUDE "ser.s"
.GLOBAL _start
#-------------------------------------------------------------------------------
_start:
ancora:
    CALL    tastiera    # legge un carattere in AL
    CMPB    $'\n', %AL  # controlla se AL contiene la codifica ASCII di '\n'
    JE      fine        # in tal caso salta all'etichetta fine

    CALL    video       # stampa il carattere ASCII che si trova in AL
    MOVB    %AL, %BL    # porta in BL il carattere letto
    MOVB    $' ', %AL   # carattere spazio
    CALL    video

    MOVB    $0, %CL     # azzera il contenuto di CL che funga da contatore

ciclo:
    TESTB   $0x80, %BL  # esame del bit piu' significativo di BL, [0]
    JZ      zero        # salta a zero
    MOVB    $'1', %AL
    CALL    video
    JMP     avanti

zero:
    MOVB    $'0', %AL
    CALL    video

avanti:
    SHLB    $1, %BL     # shift left di BL di 1, [1]
    INCB    %CL         # incrementa il contatore CL
    CMPB    $8, %CL     # controlla il contenuto del contatore
    JB      ciclo       # ripeti il ciclo se inferire a 8

    MOVB    $'\n', %AL
    CALL    video
    JMP     ancora      # leggi il prossimo carattere

fine:
    JMP     uscita

# [0]
# 0x80 = 1000 0000
# It performs a bitwise AND of the two operands. Neither of the operands is
# altered, however, the instruction alters the flags, most importantly the ZF
# flag to either 1 if the result of the AND is zero, or 0 otherwise.
# The following jz performs a jump if ZF is equal to 0.

# [1]
# Usando i shift left possiamo posizionare nella posizione piu' significativa
# ogni volta il bit successivo degli 8 bit totale che conpongono la
# rappresentazione binaria del carratere ASCII letto.

