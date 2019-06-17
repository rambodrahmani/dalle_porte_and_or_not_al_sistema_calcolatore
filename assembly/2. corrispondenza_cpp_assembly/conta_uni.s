#*******************************************************************************
# File: conta_uni.s
#       Conta il numero di bit a 1 nella rappresentazione binaria di un numero
#       decimale naturale.
#
#       Compilato con:
#           g++ -no-pie -g conta_uni.s -o conta_uni
#
#       Esempio di esecuzione:
#           ./conta_uni 
#           5
#           2
#       Infatti, 5 0101.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 17/06/2019
#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
numero:     .long   0
risultato:  .byte   0
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    CALL    legginaturale   # leggi un naturale da tastiera
    MOVQ    %RAX, numero    # copia il naturale letto in numero
    MOVB    $0, %CL         # azzera il contenuto di cL
    MOVQ    numero, %RAX    # copia il valore di numero nel registro RAX
    
ripeti:
    CMPQ    $0, %RAX        # controlla se il registro RAX contiene il valore 0
    JE      fine            # in tal caso vai a fine
    SHRQ    %RAX            # altrimenti shift right del contenuto di RAX
    JC      avanti          # se il bit shiftato era un 1, vai ad avanti
    JMP     ripeti          # altrimenti vai a ripeti

avanti:
    ADDB    $1, %CL         # incrementa di 1 il contenuto di CL
    JMP     ripeti          # vai a ripeti

fine:
    MOVB    %CL, risultato  # copia il contenuto di CL in risultato
    MOVQ    $0, %RAX        # azzera il contenuto di RAX
    MOVQ    risultato, %RDI     # stampa del risultato
    CALL    scrivinaturale
    CALL    nuovalinea     

    XORQ    %RAX, %RAX
    RET

