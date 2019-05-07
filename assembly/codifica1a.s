##
#
# File: codifica1a.s
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

