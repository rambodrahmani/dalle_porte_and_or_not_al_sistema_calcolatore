##
#
# File: stringa_palindroma.s
#       Scrivere un programma che si comporta come segue:
#       1. prende in ingresso un numero a 16 bit, contenuto in memoria nella
#          variabile 'numero'.
#       2. controlla se 'numero' e' o meno una stringa di 16 bit palindroma
#          (cioe' se la sequenza di 16 bit letta da sinitra a destra e' uguale
#          alla sequenza letta da destra a sinitra.
#       3. se X e' (non e') palindroma, il programma inserisce 1 (0) nella
#          variabile a 8 bit 'palindromo', che si trova in memoria.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 09/05/2019.
#
##

.INCLUDE "util.s"

.GLOBAL _start

.DATA
    numero:     .WORD   0xF0B8

.TEXT

_start:
    NOP
    MOV numero, %AX
    MOV $8,     %CL
    MOV $0,     %BL

ciclo:
    RCL     %AH     # metti i bit di AH in BL in ordine inverso
    RCR     %BL     # usando il carry come appoggio
    DEC     %CL
    JNZ     ciclo
    CMP     %AL, %BL
    JE      palindromo # stampa 'palindromo'
    JNE     non # stampa 'non'

palindromo:
    MOVB    $'p', %BL
    CALL    video
    MOVB    $'a', %BL
    CALL    video
    MOVB    $'l', %BL
    CALL    video
    MOVB    $'i', %BL
    CALL    video
    MOVB    $'n', %BL
    CALL    video
    MOVB    $'d', %BL
    CALL    video
    MOVB    $'r', %BL
    CALL    video
    MOVB    $'o', %BL
    CALL    video
    MOVB    $'m', %BL
    CALL    video
    MOVB    $'o', %BL
    CALL    video
    JMP     fine

non:
    MOVB    $'n', %BL
    CALL    video
    MOVB    $'o', %BL
    CALL    video
    MOVB    $'n', %BL
    CALL    video
    MOVB    $' ', %BL
    CALL    video
    JMP     palindromo

fine:
    MOVB    $'\n', %BL
    CALL    video
    JMP     uscita

