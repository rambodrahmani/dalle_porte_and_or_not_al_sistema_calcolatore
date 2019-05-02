##
#
# File: while_do.s
#       Il linguaggio Assembler non ha costrutti di controllo di flusso di alto
#       livello come il C++ (cicli, o if...then...else). Le uniche istruzioni di
#       controllo che possono essere usate (a parte quelle per le chiamate di
#       sottoprogramma, che non servono a questo scopo) sono salti e salti
#       condizionati. Pertanto, sia i costrutti condizionali if...then...else
#       che i cicli vanno scritti in termini di queste istruzioni.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 02/05/2019.
#
##

.GLOBAL _start

.TEXT
_start:
    # In questo caso il test della condizione è in fondo al ciclo, quindi
    # scriveremo che
    #
    #   do
    #       {ist1; ...; istN;}
    #   while (AX < var);
    #
    # in assembly puo' essere tradotto come
    MOV $0, %AX

ciclo:
    INC %AX
    ist_1
    ...
    ist_N
    CMP var,    %AX
    JB  ciclo

##
#
# Osservazione: niente mi vieta di saltare nel mezzo di un ciclo programmando in
# assembly. In C++ non lo si puo' fare, a meno di non usare l’istruzione goto,
# che credo non vi sia stata descritta (perche', in un linguaggio dove il
# controllo di flusso e' strutturato, serve solo a far danni). Una prassi del
# genere va evitata come la peste, perche' conduce a programmi incomprensibili
# ed inverificabili.  Avendo a che fare con JMP e JCond e' molto facile farsi
# prendere la mano e scrivere programmi disordinati, nei quali si fanno salti e
# contro salti al solo scopo di risparmiare un’istruzione, con il risultato che
# si scrivono programmi incomprensibili ed impossibili da testare e debuggare
# quando non funzionano (spaghetti-like programming). I linguaggi strutturati
# (Pascal, C, etc.) sono stati inventati apposta alla fine degli anni '60
# perche' i linguaggi che c'erano allora (Fortran, Assembler, etc.) consentivano
# questo tipo di programmazione, che risultava inverificabile e non debuggabile.
# La raccomandazione per un programmatore esperto di linguaggi ad alto livello
# e' quindi la seguente: si ragioni pure in termini di costrutti di controllo di
# flusso C++ (if...then...else, for, while, etc.), e si traduca ciascuno di
# questi in Assembler nel modo sopra indicato, perche' questo e' uno stile di
# programmazione (programmazione strutturata)  sicuro  e  corretto. Mentre i
# linguaggi ad alto livello obbligano il programmatore a tenere questo stile
# (forzandolo a scrivere blocchi di programma con un unico punto di ingresso ed
# un unico punto di uscita), in Assembler il programmatore deve limitarsi da
# solo.
#
##

