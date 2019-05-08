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
    PUSHQ   %RAX                # salva il contenuto dei registri RAX, RBX, RSI
    PUSHQ   %RBX
    PUSHQ   %RSI
    MOVB    alfa(%RIP), %AL     # copia il contenuto di alfa in AL
    MOVQ    beta(%RIP), %RBX    # copia il contenuto di beta in RBX
    MOVQ    $0, %RSI            # azzera il contatore RSI

ciclo:
    TESTB   $0x80,  %AL             # esame del bit piu' significativo di %AL
    JZ      zero                    # salta a 'zero' se il bit e' uguale a zero
    MOVB    $'1',   (%RBX, %RSI)    # copia '1' nella locazione puntata
                                    # da RBX + RSI
    JMP     avanti                  # salto incondizionato a 'avanti'

zero:
    MOVB    $'0', (%RBX, %RSI)      # copia '0' nella locazione puntata
                                    # da RBX + RSI
                                    # [1]

avanti:
    SHLB    $1, %AL     # Shift Left %AL
    INCQ    %RSI        # incrementa il contatore RSI
    CMPQ    $8, %RSI    # compare il contenuto del contatore RSI con 8
    JB      ciclo       # se il valore del contatore e' minore di 8 salta
    POPQ    %RSI
    POPQ    %RBX
    POPQ    %RAX        # ripristina il contenuto dei registri
    RET                 # ritorna

# [1]
# Piu' precisamente, con questo tipo di indirizzamento, viene letto il contenuto
# di RBX, viene poi aggiunto il contenuto di RSI, il valore ottenuto viene
# utilizzato come indirizzo della locazione di memoria dove effettuare
# l'operazione di MOV.

