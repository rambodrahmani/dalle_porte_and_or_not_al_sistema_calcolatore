##
#
#   File:   modello_piccolo.s
#           Compilato con
#               g++ -mcmodel=small modello_piccolo.cpp -o modello_piccolo
#
#           -mcmodel=small
#               Generate code for the small code model: the program and its
#               symbols must be linked in the lower 2 GB of the address space.
#               Pointers are 64 bits. Programs can be statically or dynamically
#               linked. This is the default code model.
#
#           Modello di Programma Piccolo:
#               - la sezione .TEXT e la sezione .DATA vengono complessivamente
#                 memorizzate nei primi 3 Gbyte di memoria;
#               - gli indirizzi numerici sono rappresentabili con 32 bit, e
#                 possono essere posti nel campo IMM o nel campo DISP, delle
#                 istruzioni che prevedono tali campi.
#
#           Indirizzamenti usati nel modello di Programma Piccolo:
#               - con il modello piccolo, il Compilatore, per esprimere un
#                 indirizzo di memoria, puo' utilizzare un'espressione canonica,
#                 anche senza registro base;
#               - il valore numerico che puo' assumere il campo DISP va da
#                 (2*31 - 1) a -2*31 (lo stesso dicasi per il campo IMM);
#               - senza l'utilizzo del registro base, il massimo valore di DISP
#                 eventualmente presente nella prima istruzione deve assicurare
#                 di raggiungere l'indirizzo dell'ultima, e il minimo valore di
#                 DISP eventualmente presente nell'ultima istruzione deve
#                 assicurare di raggiungere l'indirizzo della prima.
#
#           Blocco di memoria di utilizzare per la memorizzazione delle zone
#           .TEXT e .DATA:
#               - deve quindi avere dimensioni inferiori ai 2*31 (2 Gigabyte).
#
#   Author: Rambod Rahmani <rambodrahmani@autistici.org>
#           Created on 14/05/2019.
#
##

.INCLUDE "servi.s"

.DATA
    i:  .LONG   0
    ar: .FILL   10, 4, 30

.TEXT

fai:
    MOVL    $5, i   # i = 5
    RET             # return

.GLOBAL main
main:
    CALL    fai     # RIP implicito, chiama la funzione fai
    MOVSLQ  i, R15
    MOVL    $8, ar(, %R15, 4)   # ar[5] = 8, [1]

    # stampa tutti gli elementi di ar
    MOVL    $0, i

ciclo:
    MOVSLQ  i, %R15     # copia il valore di i in R15
    MOVL    ar(, %R15, 4), %EDI     # [2]
    CALL    scriviint   # RIP implicito, chiama la funzione scriviint, [3]
    INCL    i           # incrementa i di 1
    CMPL    $10, i      # confronta il valore di i con 10
    JL      ciclo       # RIP implicito, salta all'etichetta ciclo se i < 10
    CALL    nuovalinea  # RIP implicito, chiama la funzione nuovalinea

    MOVL     $0, %EAX   # return value
    RET                 # return

# [1]
# In questo caso l'offset per raggiungere il quinto elemento di ar.
# In AT&T syntax this form represents
#   OFFSET(BASE REGISTER, INDEX REGISTER, INDEX SCALE)
# so the address represented is the value of
# BASE REGISTER (if present) + INDEX * SCALE (if present) + OFFSET

# [2]
# Copia gli elementi di ar progressivamente in EDI.

# [3]
# Stampa progressivamente gli elementi di ar che vengono precedentemente copiati
# in EDI.

