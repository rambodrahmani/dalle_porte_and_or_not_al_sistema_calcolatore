##
#
# File: caratteri_maiuscoli.s
#       Scrivere un programma che accetta in ingresso una stringa di massimo 80
#       caratteri esclusivamente minuscoli terminata da ritorno carrello, stampa
#       i singoli caratteri mentre vengono digitati, poi va a capo e stampa
#       l'intera stringa a video maiuscolo.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/05/2019.
#
##

.INCLUDE "util.s"

.DATA
    messaggio:  .FILL   256,1,0

.TEXT

.GLOBAL _start
_start:
    NOP
    MOV   $80, %CX
    LEA   messaggio, %EBX

ciclo:
    CALL  inchar
    CMP   $0x0D, %AL
    JE    dopo

    # se non e' un carattere compreso tra 'a' e 'z'
    CMP   $'a', %AL
    JB    ciclo
    CMP   $'z', %AL
    JA    ciclo
    CALL  outchar
    AND   $0x5F, %AL
    MOV   %AL, (%EBX)
    INC   %EBX
    DEC   %CX
    JNZ   ciclo

dopo:
    MOVB  $0x0A, (%EBX)
    MOVB  $0x0D, 1(%EBX)
    CALL  newline
    LEA   messaggio, %EBX
    CALL  outline
    CALL  pause
    JMP uscita

