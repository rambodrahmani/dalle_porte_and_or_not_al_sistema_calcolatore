##
#
# File: codifica1b.s
#       Programma codifica1 (prima nuova versione del programma codifica):
#       - due file: il primo contiene il programma principale, il secondo
#         un sottoprogramma esamina, utilizzato dal primo file.
#
#       Il programma principale:
#       - legge caratteri fino alla fine della linea;
#       - per ogni carattere, oltre a stamparlo, richiama il sottoprogramma
#         esamina, quindi stampa il risultato prodotto da quest'ultimo.
#
#       Il sottoprogramma esamina:
#       - restituisce 8 caratteri in codifica ASCII, corrispondenti agli 8 bit
#         della codifica del carattere ricevuto.
#
#       Trasmissione dei dati fra programma e sottoprogramma:
#       - due variabili alfa e beta definite nel secondo file (esterno nel primo
#         file e globali nel secondo);
#         - alfa: contiene il codice del carattere, che il sottoprogramma deve
#           esaminare;
#         - beta: contiene l'indirizzo di una variabile array di 8 byte, dove il
#           sottoprogramma deve porre il risultato;
#       - il programma principale pone i dati in alfa e beta, quindi chiama
#         esamina.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 07/05/2019.
#
##

.INCLUDE "util.s"

.DATA
.GLOBAL alfa, beta
    alfa:   .BYTE   0
    beta:   .QUAD   0

.GLOBAL esamina

.TEXT
esamina:
    PUSHQ   %RAX
    PUSHQ   %RBX
    PUSHQ   %RSI
    MOVB    alfa(%RIP), %AL
    MOVQ    beta(%RIP), %RBX
    MOVQ    $0, %RSI

ciclo:
    TESTB   $0x80,  %AL
    JZ      zero
    MOVB    $'1',   (%RBX, %RSI)
    JMP     avanti

zero:
    MOVB    $'0', (%RBX, %RSI)

avanti:
    SHLB    $1, %AL
    INCQ    %RSI
    CMPQ    $8, %RSI
    JB      ciclo
    POPQ    %RSI
    POPQ    %RBX
    POPQ    %RAX
    RET

