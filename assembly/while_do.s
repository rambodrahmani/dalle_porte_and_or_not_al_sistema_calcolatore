##
#
# File: ciclo_for.s
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
    # Un qualunque ciclo puo' essere tradotto in un IF + salto a un’etichetta.
    # Di norma, per scrivere cicli in  Assembler  si  usa  incrementare/
    # decrementare il registro CX (ECX, CL) o i registri EDI, ESI (questi
    # ultimi, infatti, vengono utilizzati per l’accesso in memoria con registro
    # puntatore, quindi facomodo poterli usare nei cicli per indirizzare vettori
    # di variabili). Supponiamo di avere il seguente spezzone di codice:
    #
    #   for (int i=0; i<var; i++)       // dove ”var” è una variabile o costante
    #       {ist1; ...; istN}
    #
    # In Assembler posso  usare CX come contatore e scrivere:
    MOV $0,     %CX

ciclo:
    CMP var,    %CX
    JE  fuori   
    ist_1
    ...
    ist_N
    INC %CX
    JMP ciclo
    ...

fuori:
    #...

