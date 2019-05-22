##
#
# File: if_else.s
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
    # Se voglio scrivere una porzione di codice come:
    #
    #   if (%AX < variabile)        // interpretati come contenitori di naturali
    #       {ist1; ...; istN;}
    #   else
    #       {istN+1; ...; istN+M;}
    #   ist_nuova;
    #
    # Invece dell’if, in Assembler posso scrivere CMP + JCond:
    #
    #   CMP variabile, %AX
    #   JB label             # JB consistente con i naturali = Salta se minore
    #
    # Il trucco (banale) è il seguente: invertire il ramo else con quello then,
    # e scrivere il codice come:
    CMP variabile,  %AX
    JB  ramothen

ramoelse:
    istN + 1
    ...
    istN + M
    JMP segue

ramothen:
    ist1
    ...
    istN

segue:
    ist_nuova

##
# In alternativa, se voglio mantenere l’ordine del codice (ramo then prima del
# ramo else), devo invertire la condizione:
##

.TEXT
_start:
    CMP variabile, %AX
    JAE ramoelse

ramothen:
    ist1
    ...
    istN
    JMP segue

ramoelse:
    istN + 1
    ...
    istN + M

segue:
    ist_nuova

