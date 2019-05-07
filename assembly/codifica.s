##
#
# File: codifica.s
#       Legge in %AL caratteri fino al fine linea; per ogni carattere letto, lo
#       stampa e quindi ricava e stampa gli otto caratteri (in codifica ASCII)
#       corrispondenti agli 8 bit della codifica del carattere letto, seguito da
#       un fine-linea.
#
#       Esempio di utilizzo:
#
#       [rambodrahmani@rr-workstation assembly]$ ./codifica 
#       rambod
#       r 01110010
#       a 01100001
#       m 01101101
#       b 01100010
#       o 01101111
#       d 01100100
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 07/05/2019.
#
##

.INCLUDE "util.s"

.GLOBAL _start

.DATA
    numero:     .BYTE   9
    risultato:  .LONG   1

.TEXT
_start:

ancora:
    CALL    tastiera        # leggi il carattere digitato su tastiera in %AL
    CMPB    $'\n',  %AL     # se il carattere letto corrisponde al nuova linea
    JE      fine            # salta a fine
    MOVB    %AL,    %BL     # altrimenti, sposta il carattere letto in %BL
    CALL    video           # stampa a video il contenuto di %BL
    MOVB    $' ',   %BL     # mette in %BL la codifica ASCII di ' '
    CALL    video           # stampa il contenuto del registro %BL
    MOVB    $0,     %CL     # azzera il contenuto di %CL che funge da contatore
    
ciclo:
    TESTB   $0x80,  %AL     # simula la AND logica, modificando soltanto le flag
                            # coinvolte
    JZ      zero            #
    MOVB    $'1',   %BL     # mette in %BL la codifica ASCII di '1'
    CALL    video           # stampa il contenuto del registro %BL
    JMP     avanti          # salto incondizionato ad 'avanti'

zero:
    MOVB    $'0', %BL       # mette in %BL la codifica ASCII di '0'
    CALL    video           # stampa il contenuto del registro %BL

avanti:
    SHLB    $1, %AL
    INCB    %CL             # incrementa di 1 il registro contatore
    CMPB    $8, %CL         # confronta il contenuto del contatore con 8
    JB      ciclo           # sal a 'ciclo'
    MOVB    $'\n',  %BL     # mette in %BL la codifica ASCII di '\n'
    CALL    video           # stampa il contenuto del registro %BL
    JMP     ancora          # salto incondizionato ad 'ancora'

fine:
    JMP uscita

