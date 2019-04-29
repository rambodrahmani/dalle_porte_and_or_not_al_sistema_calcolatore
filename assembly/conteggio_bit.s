##
# Conteggio dei bit a 1 in un long.
##

.GLOBAL _start

# Dichiarazioni di variabile (direttive).
.DATA
    # La prima e' un LONG, cioè uno spazio da 4 locazioni contigue, che
    # contengono (inizialmente) il numero 0x0F0F0101. L’indirizzo della prima
    # locazione e' riferibile nel programma con il nome "dato".
    dato:       .LONG 0x0F0F0101

    # La seconda e' un BYTE, cioè uno spazio da 1 locazione, che contiene
    # (inizialmente) il numero 0x00. L’indirizzo di tale locazione e' riferibile
    # nel programma con il nome "conteggio".
    conteggio:  .BYTE 0x00

.TEXT

_start:
    NOP     # 1
    MOVB    $0x00, %CL

    # Questo e' un caso di indirizzamento diretto, in cui l'indirizzo della
    # (prima) locazione e' stato sostituito dal nome simbolico.
    MOVL dato, %EAX

# In questo caso assegno all’istruzione CMPL un nome simbolico, che posso
# riferire dentro la succes-sive JMP. Questo viene tradotto
# dall’assemblatore come se fosse un salto relativo (vedere codice
# mnemonico a destra). L’aspetto positivo e', ovviamente, che non sono
# tenuto a farmi i conti per poterlo scrivere.
comp:
    CMPL    $0x00, %EAX
    JE      fine
    SHRL    %EAX
    ADCB    $0x0, %CL
    JMP     comp

# Stessa cosa di prima. Attenzione ad una sottigliezza. Il nome finenon e' stato
# dichiarato al momento del suo utilizzo.
# 2
fine:
    MOVB    %CL,    conteggio
    MOVL    $0,     %EBX    # risultato per UNIX
    MOVL    $1,     %EAX    # primitiva UNIX exit

##
# 1
#
# NOP (No OPeration) e' un'istruzione assembly, il cui scopo e' quello di
# permettere all'unita' di esecuzione della pipeline di oziare per N cicli di
# clock (dove N cambia a seconda del processore utilizzato), come deducibile dal
# nome dunque, non esegue alcuna operazione.
# L'istruzione NOP occupa dunque tempo e memoria, ma ha una sua utilita' nel
# mondo della programmazione (oltre che alla creazione di ritardi convenzionali
# e di riserve di spazio in memoria), risolvendo alcuni problemi chiamati
# "hazard", ovvero quei tipi di conflitti ed incongruenze che possono avvenire
# all'interno di una pipeline durante l'esecuzione del programma. L'istruzione
# puo' anche essere utilizzata per risolvere i problemi della branch delay slot
# in modo poco efficiente.
##

##
# 2
# In Assembler, i nomi possono essere usati prima di essere stati definiti. Ci
# pensa l’assemblatore a strigare il tutto (fa due passate: nella prima
# controlla che i nomi riferiti ci siano tutti, nella seconda fa la traduzione
# vera e propria). Il motivo per cui cio' e' necessario e' ovvio: altrimenti non
# sarebbe possibile scrivere codice con salti in avanti, come quello che c’e' in
# questo programma. Dall’altra parte, questo consente di scrivere programmi di
# devastante incomprensibilita'. Ad esempio, nessuno mi obbliga a mettere tutte
# le dichiarazioni di variabili raggruppate in cima, ne' a mettere la
# definizione delle costanti prima del loro primo utilizzo, magari insieme alle
# dichiarazioni di variabile. Questi stili di programmazione vanno evitati.
# L'unico caso in cui e' lecito (stilisticamente) usare un'etichetta non ancora
# definita e' quello di salto in avanti nel codice. Non va fatto in nessun altro
# caso.
##

