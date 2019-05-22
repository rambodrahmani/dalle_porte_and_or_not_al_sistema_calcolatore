##
#
#   File:   proprieta_pic.s
#           Compilato con
#               g++ -fpic proprieta_pic.s -o proprieta_pic
#
#           Specifica della proprieta PIC nell'ambiente GNU/GCC (col comando
#           g++):
#                   -fpic
#                   -fno-pic
#
#           Proprieta' PIC:
#               - indipendenza dalla posizione.
#
#           Compilatore:
#               - puo' tradurre tutte le istruzioni operative e tutte quelle di
#                 salto (condizionato o incondizionato) che utilizzano un
#                 indirizzamento relativo rispetto a RIP;
#               - puo' anche tradurre le istruzioni operative utilizzando un
#                 indirizzamento con espressioni canoniche aventi registro base,
#                 previo caricamento del registro base stesso con l'istruzione
#                 LEAQ, avente a sua volta un indirizzamento relativo;
#               - puo' effettuare chiamate di funzione esterne, usando il salto
#                 indiretto.
#
#           Modello PIC:
#               - la sezione .TEXT e la sezione .DATA non devono occupare
#                 complessivamente piu' di 2 GByte consecutivi di memoria, in
#                 qualunque zona.
#
#           Modello Piccolo + PIC:
#           - la proprieta' PIC puo' combinarsi col modello piccolo, ottenendo
#             un modello piccolo esteso a tutta la memoria;
#           - per operandi che si trovano in pila (o nello HEAP) non ci sono
#             restrizioni rispetto a quanto detto, potendo essere memorizzati
#             ovunque;
#
#           Modello Grande + PIC:
#           - la proprieta' PIC puo' combinarsi col modello grande, facendo
#             predisporre al Compilatore una Global Offset Table (GOT):
#               - la tabella viene utilizzata per memorizzarvi indirizzi di 64
#                 bit, ed utilizzata per caricare registri su cui fare
#                 un'indirezione (operatore C++ *) o da utilizzare in
#                 un'espressione canonica.
#
#           Esempi riportati nel testo ed esercizio di esame:
#           - nessuna opzione per il comando g++
#           - file C++: traduzione secondo il modello piccolo;
#           - file Assembly: possono essere usate istruzioni PIC.
#
#   Author: Rambod Rahmani <rambodrahmani@autistici.org>
#           Created on 16/05/2019.
#
##

.INCLUDE "servi.s"

.DATA
    i:  .LONG   0
    ar: .FILL   10, 4, 30

.TEXT

fai:
    MOVL    $5, i(%RIP)     # i = 5
    RET                     # return

.GLOBAL main
main:
    CALL    fai     # RIP implicito, chiama la funzione fai
    LEAQ    ar(%RIP), %R12  # copia l'indirizzo del primo elemento di ar in R12
    MOVSLQ  i(%RIP), %R15   # copia l'indirizzo di i in R15
    MOVL    $8, (%R12, %R15, 4)     # ar[5] = 8

 # stampa il contenuto di ar
    MOVL    $0, i(%RIP)     # azzera il valore di i

ciclo:
    MOVSLQ  i(%RIP), %R15   # copia il valore di i in R15
    MOVL    (%R12, %R15, 4), %EDI   # [1]
    CALL    scriviint   # PIC implicito, chiama la funzione scriviint
    INCL    i(%RIP)
    CMPL    $10, i(%RIP)
    JL      ciclo       # PIC implicito, salta all'etichetta 'ciclo'
    CALL    nuovalinea  # PIC implicito, chiama la funzione nuovalinea

    MOVL    $0, %EAX    # return value
    RET                 # return

# [1]
# Copia progressivamente gli elementi di ar in EDI.

