##
#
# File: conteggio_bit_2a.s
#       Scrivere un programma che:
#       - definisce un vettore numeri di enne numeri naturali a 16 bit in
#         memoria (enne sia una costante simbolica);
#       - definisce un sottoprogramma per contare il numero di bit a 1 di un
#         numero a 16 bit. Tale sottoprogramma ha come parametro di ingresso il
#         numero da analizzare (in AX), e restituisce il numero di bit a 1 in
#         CL;
#       - utilizzando il sottoprogramma appena descritto, calcola il numero
#         totale di bit a 1 nel vettore ed inserisce il risultato in una
#         variabile conteggio di tipo word.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/05/2019.
#
##

.INCLUDE "util.s"

.DATA
    .SET    enne,    10
    numeri:     .WORD   0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    conteggio:  .WORD   0x00

.TEXT

.GLOBAL _start
_start:
    NOP
    MOV $0, %ESI    # azzero il contatore
    MOV $0, %CX     # azzero CX
    MOV $0, %DX     # azzero DX che usero' per la somma totale

ciclo:
    MOV  numeri(, %ESI, 2),  %AX    # posiziono il parametro per 'conta'
    CALL conta          # chiamo il sottoprogramma 'conta'
    INC  %ESI           # incremento il contatore
    ADD  %CX, %DX       # aggiungo l'ultimo risultato prodotto alla somma totale
    CMP  $enne, %ESI    # comparo il numero di elementi da analizzare
    JB   ciclo          # se ne ho altri da analizzare ripeto il ciclo
    MOV  %DX, conteggio # altrimenti metto la somma totale in DX (ho finito)
    JMP  uscita

##
# Abbiamo visto le istruzioni per la gestione di sottoprogrammi, CALL e RET. Un
# sottoprogramma, generalmente, opera su dei parametri. Visto che la CALL e la
# RET non prevedono il passaggio di parametri alla chiamata, ne' il ritorno di
# un valore al ritorno da sottoprogramma, e' necessario che il programmatore
# stabilisca una convenzione tra sottoprogramma chiamante e chiamato per gestire
# questi aspetti. Ci sono, sostanzialmente due modi di gestire i parametri
# (d'ora in avanti parlo genericamente di "parametri", includendo in essi il
# valore di ritorno del sottoprogramma):
#   1) usare variabili (i.e. locazioni di memoria) condivise
#   2) usare i registri
# Ovviamente, le due modalita' possono essere usate in concorso. Ricordiamo che
# sia i registri sia le locazioni di memoria possono contenere indirizzi, quindi
# e' possibile usare sia locazioni di memoria che registri per passare indirizzi
# ad altre zone di memoria. In Assembly non esiste il concetto di variabile
# locale ad un sottoprogramma. Tutte le variabili (cioe' la memoria
# indirizzabile) sono globali. Non esistono regole di scopo. La memoria e'
# accessibile da qualunque sottoprogramma, in qualunque punto. Non esiste il
# concetto di variabile locale ad un sottoprogramma. Quando qualcuno scrive un
# sottoprogramma, deve specificare (con dei commenti) quali sono i parametri che
# il sottoprogramma richiede, dove vuole  che trovarli, come passera'
# all'indietro un valore di ritorno e cosa questo significhi. Fondamentale: un
# sottoprogramma dovra' fare dei conti. Per farli utilizzera', in generale, dei
# registri del processore (difficilmente potra' farne a meno). A meno che questi
# registri non siano dichiarati come contenitori di parametri di ritorno, non
# devono essere modificati dal sottoprogramma. Questo e' fondamentale: chi
# scrive un programma si aspetta che dopo la CALL il contenuto dei registri non
# interessati da valori di ritorno del sottoprogramma rimanga inalterato. Ci
# deve pensare il programmatore, ed il modo per pensarci e' salvare i registri
# in pila e ripristinarli.  L'unico registro che fa eccezione e' quello dei
# flag, che si assume che possa cambiare. Attenti ai registri da salvare: non
# sempre si vedono scorrendo il sottoprogramma. Per esempio, se uno fa una MUL o
# una DIV puo' finire a sporcare anche DX o EDX (perche' un risultato o un
# dividendo a 32/64 bit viene messo li'). Magari uno non scrive direttamente DX
# come destinatario nel sottoprogramma, ma nel frattempo l'ha sporcato.
# Attenzione: per ogni PUSH ci deve essere una POP (e viceversa), altrimenti il
# programma va in crash. Infatti, alla RET l'indirizzo di ritorno viene
# ripescato dalla pila, e se si e' messo qualcosa in pila senza toglierlo (o
# viceversa) l’indirizzo sara' casuale. Quindi la pila va lasciata come e' stata
# trovata.
##

