##
#
# File: conteggio_carattere_2.s
#       VARIAZIONE sul tema per l’indirizzamento (uso di displacement + registro
#       di modifica).
#
#       Scrivere un programma che legge una stringa di memoria lunga un numero
#       arbitrario di caratteri (ma terminata da \0), inserita in un buffer di
#       memoria di indirizzo noto, e conta le volte che appare il carattere
#       specificato dentro un’altra locazione di memoria. Il risultato viene
#       messo in una terza locazione di memoria.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 29/04/2019.
#
##

.INCLUDE "util.s"

.GLOBAL _start

.DATA
    stringa:    .ASCIZ  "Questa e' una stringa di prova che usiamo come esempio"
    lettera:    .BYTE   'e'
    conteggio:  .BYTE   0x00

.TEXT
_start:
    NOP                         # No Operation
    MOVB    $0x00,      %CL     # Azzera il contenuto di CL
    MOVB    $0x00,      %DL
    MOV     $0,         %ESI    # The lea (load effective address) instruction
                                # is used to put a memory address into the
                                # destination.
    MOV     lettera,    %AL     # Metti il contenuto di lettera in AL

comp:
    CMPB    $0x00,  stringa(%ESI)   # 1
    JE      print                   # Se ESI e' nullo salta abbiamo finito
    CMP     stringa(%ESI),  %AL     # Controlla il valore contenuto nel
                                    # puntatore presente nel registro ESI.
    JNE     poi                     # Se il contenuto e' diverso da AL salta
    INC     %CL                     # ...altrimenti incrementa CL di 1

poi:
    INC %ESI                # Incrementa il puntatore in ESI
    JMP comp                # Salta (torna) a comp

##
# Stampa il contenuto del registro CL in binario.
##
print:
    CMPB    $0x00,  %CL
    JE      fine
    SHRB    %CL
    ADCB    $0x0,   %DL
    CMPB    $0x00,  %DL
    JE      print_zero
    JMP     print_one

##
# Stampa il carattere '0'.
##
print_zero:
    MOVB    $'0',   %BL
    CALL    video
    MOVB    $0x00,  %DL
    JMP     print

##
# Stampa il carattere '1'.
##
print_one:
    MOVB    $'1',   %BL
    CALL    video
    MOVB    $0x00,  %DL
    JMP     print

fine:
    MOV     %CL,    conteggio
    MOVB    $'\n',  %BL         # carattere nuova riga
    CALL    video
    JMP     uscita

