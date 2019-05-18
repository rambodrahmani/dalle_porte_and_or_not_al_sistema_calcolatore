##
#
#   File: esempio_programma.s
#         Prepariamo un semplice esempio di programma da far eseguire al nostro
#         elaboratore. Dato che ci interessa principalmente sapere cosa succede
#         durante l'esecuzione all'interno dell'elaboratore, usiamo il
#         linguaggio Assembly, che e' il piu' vicino al linguaggio macchina:
#         ogni istruzione Assembly si traduce in una istruzione di linguaggio
#         macchina. Sempre per lo stesso motivo, ci conviene pensare che tutta
#         la procedura di preparazione del programma in linguaggio macchina
#         (scrittura del file sorgente, assemblamento, collegamento) sia svolta
#         all'esterno del calcolare, su un altro calcolare o in qualunque altro
#         modo, anche se in pratica usiamo lo stesso calcolatore per fare tutto.
#         L'esecuzione del nsotro programma comincia dal momento in cui esso e'
#         stato caricato in memoria; a quel punto esiste solo il linguaggio
#         macchina e tutta la procedura precedente non conta piu'.
#
#         La procedura inizia preparando un file di testo che contiene il
#         programma in linguaggio Assembly. Si consideri l'esempio a seguire nel
#         presente file.
#
#   Author: Rambod Rahmani <rambodrahmani@autistici.org>
#           Created on 17/05/2019.
#
##

.DATA
    num1:   .QUAD   0x1122334455667788

    num2:   .QUAD   0x9900aabbccddeeff

    risu:   .QUAD   -1

    # il programma vuole calcolare la somma dei due numeri memorizzati agli
    # indirizzi num1 e num2 e scrivere il risultato all'indirizzo risu.

.TEXT

.GLOBAL _start, start
start:
_start:
    MOVABSQ  $num1,  %RAX   # carica l'indirizzo del primo numero in RAX
    MOVQ     (%RAX), %RCX   # carica il primo numero nel registro RCX
    MOVABSQ  $num2,  %RAX
    MOVQ     (%RAX), %RBX   # carica il secondo numero nel registro RBX
    ADDQ     %RBX,   %RCX   # somma i due numeri scrivendo il risultato in RCX
    MOVABSQ  $risu,  %RAX
    MOVQ     %RCX,   (%RAX) # copia il risultato della somma in risu

    # le righe 52-54 servono a dire al sistema operativo che il programma e'
    # terminato

    MOVQ     $13,    %RBX
    MOV      $1,     %RAX
    int      $0x80

