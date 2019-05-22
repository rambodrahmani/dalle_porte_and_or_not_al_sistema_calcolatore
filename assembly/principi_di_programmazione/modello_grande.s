##
#
#   File:   modello_grande.s
#           Compilato con g++ modello_grande.s -o modello_grande_as
#
#           Compilato con
#               g++ -mcmodel=large modello_grande.cpp -o modello_grande
#
#           -mcmodel=large
#               Generate code for the large model. This model makes no
#               assumptions about addresses and sizes of sections.
#
#           Modello di un programma:
#            - stabilisce come si deve effettuare la memorizzazione delle parti
#              del programma per assicurare che tutti gli indirizzi prodotti
#              dalle istruzioni elaborative possano correttamente indirizzare i
#              dati, e quelli prodotti dalle istruzioni di controllo possano
#              saltare nei punti previsti.
#
#           Parti di un programma:
#            - sono 4, ossia la sezione .TEXT, la sezione .DATA, la pila e la
#              heap (gli indirizzi devono comunque essere canonici, altrimenti
#              la MMU non li traduce);
#            - la pila e lo heap possono essere memorizzati ovnque, poiche'
#              viene utilizzato un indirizzamento canonico con un registro base 
#              (la pila viene indirizzata tramite i registri RSP e RBP e lo heap
#              tramite un puntatore);
#            - le zone istruzioni .TEXT e .DATA devono obbedire a determinate
#              regole.
#
#           File in C++ e modello:
#            - il concetto di modello ha effetto quando nel programma si
#              utilizza un file C++ da far tradurre al compilatore;
#            - un file scritto direttamente in Assembly deve rispettare il
#              modello e non viene modificato dal compilatore.
#
#           Modello di Programma Grande:
#           - la sezione .TEXT e la sezione .DATA possono essere memorizzati
#             ovunque;
#           - gli indirizzi simbolici vengono tradotti, modificati per
#             collegamento ed eventualmente rilocati;
#           - se rappresentabili con 32 bit, possono essere posti singolarmente
#             nei campi DISP e IMM delle istruzioni che prevedono tali campi;
#           - se richiedono per la rappresentazione piu' di 32 bit (uno o piu'
#             bit dei 32 bit significativi sono diversi dal bit alla loro
#             destra), tipicamente 64, viene utilizzata dal Cimpilatore
#             l'istruzione MOVABSQ, l'unica che possiene un campo IMM di 64 bit.
# 
#           Indirizzamenti usati nel modello Grande:
#           - per indirizzare un dato, il compilatore usa tipicamente
#             un'espressione canonica, con un registro base di 64 bit
#             preventivamente caricato con una sitruzione MOVABSQ, quest'ultima
#             avente un operando immediato di 64 bit;
#           - per effettuare un salto incondizionato, il compilatore usa
#             tipicamente un'espressione indiretta, con un registro
#             preventivamente caricato con una istruzione MOVABSQ, quest'ultima
#             avente un operando immediato di 64 bit;
#           - per effettuare un salto condizionato, con cicli manifestatamente
#             cortim il compilatore utilizza un'espressione relativa (rispetto
#             a RIP).
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
    MOVABSQ  $i, %R14       # [1]
    MOVL     $5, (%R14)     # i = 5, [2]
    RET                     # return

.GLOBAL main
main:
    MOVABSQ  $fai, %RBX     # copia l'indirizzo di fai in RBX
    CALL     *%RBX          # chiama la funzione il cui indirizzo e' in RBX
    MOVABSQ  $ar, %R12      # copia l'indirizzo del primo elemento di ar in R12
    MOVABSQ  $i, %R14       # copia l'indirizzo di i in R14
    MOVSLQ   (%R14), %R15   # [5]
    MOVL     $8, (%R12, %R15, 4) # ar[i] = 8, i = 5 => ar[5] = 8
                                 # [3]

    # stampa tutti gli elementi di ar
    MOVL    $0,  (%R14)

ciclo:
    MOVSLQ   (%R14), %R15
    MOVL     (%R12, %R15, 4), %EDI  #[4]
    MOVABSQ  $scriviint, %R13   # copia l'indirizzo di scriviint in R13
    CALL     *%R13              # chiama la funzione il cui indirizzo e' in R13
    INCL     (%R14)             # incrementa R14
    CMPL     $10, (%R14)        # confronta R14 con 10
    JL       ciclo              # ripeti il ciclo se R14 ha valore minore di 10
    MOVABSQ  $nuovalinea, %R13  # copia l'indirizzo di nuovalinea in R13
    CALL     *%R13              # chiama la funzione il cui indirizzo e' in R13

    MOVL     $0, %EAX           # valore di ritorno
    RET                         # ritorno

# [1]
# movabs is just a GAS-specific way to enforce encoding a 64-bit memory offset
# or immediate. It's still the same standard MOV opcode.
# Copia l'indirizzo di 'i' in R14.

# [2]
# Copia il valore 5 nella locazione di memoria il cui indirizzo si trova in R14.

# [3]
# In AT&T syntax this form represents
#   OFFSET(BASE REGISTER, INDEX REGISTER, INDEX SCALE)
# so the address represented is the value of
# BASE REGISTER (if present) + INDEX * SCALE (if present) + OFFSET
#
# Copia il valore immediato 8 nella locazione di memoria puntata da ar
# incrementata del valore in R15 (5). Ricordiamo che si tratta di un array da
# elementi di 4 byte ciascuno.

# [4]
# Copia progressivamente, ad ogni passo incremento R15, gli elementi del vettore
# in EDI.

# [5]
# Copia il valore nella locazione di memoria il cui indirizzo si trova in R14 in
# R15.

