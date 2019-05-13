##
#
# File: caratteri_maiuscoli.s
#       Scrivere un programma che accetta in ingresso una stringa di massimo 80
#       caratteri esclusivamente minuscoli terminata da ritorno carrello, stampa
#       i singoli caratteri mentre vengono digitati, poi va a capo e stampa
#       l'intera stringa a video maiuscolo.
#
#       Compilato usando:
#
#           C:\WORK> ASSEMBLE.BAT CARATT˜1.S
#           Press any key to continue.
#
#       Esempio di esecuzione:
#
#           C:\WORK> CARATT˜1.EXE
#           rambod
#           RAMBOD
#
#           Checkpoint number 0. Press any key to continue
#
#           Press Q to exit . . .
#           C:\WORK>
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/05/2019.
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
    CMP   $0x0D, %AL    # 0x0D corrisponde al ritorno carrello
    JE    dopo          # se viene digitato, salta all'etichetta 'dopo'

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
