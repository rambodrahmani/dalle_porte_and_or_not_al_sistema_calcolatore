#*******************************************************************************
# File: codifica_2.s
#       Per illustrare questo modo di indirizzamento un po' piu' sofisticato
#       (indirizzo relativo a RIP), viene sviluppata una nuova versione del
#       programma codifica illustrato nel Capitolo 2.
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
#       Viene utilizzato un sottoprogramma, esamina, per ricavare gli 8
#       caratteri corrispondenti ai bit che codificano un carattere dato. I
#       parametri del sottoprogramma sono trasmessi nei registri: AL contiene il
#       codice del carattere da esaminare, EBX contiene l'indirizzo di una
#       variabile in cui va messo il risultato (array di 8 byte).
#
#       Compilato con:
#           g++ -no-pie -g codifica_2.s -o codifica_2
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
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
    kappa:  .FILL   8, 1
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
esamina:
    PUSHQ   %RAX
    PUSHQ   %RSI        # salva il contenuto dei registri RAX e RSI
    MOVQ    $0, %RSI    # azzera il contenuto del registro RSI

ciclo:
    TESTB   $0x80, %AL        # test del bit piu' significativo di AL
    JZ      zero              # se vale zero salta a zero
    MOVQ    $'1', (%RBX, %RSI)# copia '1' nella locazione di memoria indirizzata
    JMP     avanti            # salto incondizionato ad avanti

zero:
    MOVQ    $'0', (%RBX, %RSI)# copia '0' nella locazione di memoria indirizzata

avanti:
    SHLB    $1, %AL     # shift left del cotenuto di AL
    INCQ    %RSI        # incrementa di 1 il contenuto di RSI
    CMPQ    $8, %RSI    # controlla se RSI e' uguale a 8
    JB      ciclo       # in caso contrario salta a ciclo

    POPQ    %RSI    # altrimenti,
    POPQ    %RAX    # ripristina il contenuto dei registri RSI e RAX
    RET             # ritorna
#-------------------------------------------------------------------------------
main:
ancora:
    # lettura del prossimo carattere

    CALL    leggisuccessivo     # legge il carattere successivo in AL
    CMPB    $'\n', %AL          # controllo se e' stato letto il carattere '\n'
    JE      fine                # in tal caso salta a fine

    # preparazione parametri per la chiamata a esamina

    MOVB    %AL, %DIL           # copia il contenuto di AL in DIL per scrittura
    CALL    scrivicarattere     # scrive su terminale il carattere ASCII in DIL
    CALL    scrivispazio        # scrive su terminale il carattere spazio
    MOVQ    $kappa, %RBX        # copia in RBX l'indirizzo puntato da kappa
    CALL    esamina             # chiama esamina

    # stampa del contenuto di kappa usando RCX come registro indice

    MOVQ    $0, %RCX            # azzera il contenuto di RCX
ripeti:
    MOV     kappa(%RCX), %AL    # copia in AL l'elemento di indice RCX di kappa
    MOVB    %AL, %DIL           # copia il contenuto di AL in DIL per scrittura
    PUSHQ   %RCX
    CALL    scrivicarattere     # scrive su terminale il carattere ASCII in DIL
    POPQ    %RCX
    INCQ    %RCX                # incrementa RCX
    CMPQ    $8, %RCX            # controlla se RCX contiene 8
    JB      ripeti              # se minore, salta a ripeti
    CALL    nuovalinea          # altrimenti stampa su terminale una nuova linea
    JMP     ancora              # salto incondizionato ad ancora

    # termina e ritorna
fine:
    XOR     %RAX, %RAX  # execution result 0
    RET                 # return main

