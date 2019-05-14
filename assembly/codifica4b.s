##
#
# File: codifica4b.s
#       Quarta nuova versione del programma codifica. Programma misto.
#
#       In Assembly, oppositamente a quanto si fa in C++, l'identificatore
#       .global e' obbligatorio mentre quello .extern e' opzionale. In un file
#       C++, gli identificatori delle variabili definite al di fuori delle
#       funzioni e gli identificatori delle funzioni sono implicitamente
#       globali (la dichiarazione .global puo' quindi essere omessa). In un
#       file C++ si posso riferire identificatori definiti in altri file,
#       purche' siano esplicitamente dichiarati esterni e siano globali nei file
#       dove sono definiti. Per le funzioni la parola chiave extern puo' essere
#       omessa, ma resta obbligatoria la dichiarazione.
#
#       Esempio di utilizzo:
#
#       [rambodrahmani@rr-workstation assembly]$ ./codifica2
#       rambod
#       r 01110010
#       a 01100001
#       m 01101101
#       b 01100010
#       o 01101111
#       d 01100100
#
#       - Sviluppo della versione C++ numero 3:
#           g++ codifica3a.cpp codifica3b.cpp -o codifica3
#           ./codifica3
#
#       - Sviluppo della versione mista numero 4:
#           g++ codifica4a.cpp codifica4.s -o codifica4
#           ./codifica4
#
#       - Sviluppo della versione mista numero 5:
#           g++ codifica5a.s codifica5b.cpp -o codifica5
#           ./codifica5
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 14/05/2019.
#
##

.DATA

.GLOBAL alfa, beta
    alfa:   .BYTE   0
    beta:   .QUAD   0

.TEXT

.GLOBAL esamina     # in questa quarta versione nessun salvataggio e ripristino,
                    # non essendoci registri utilizzati il cui valore va
                    # preservato da un chiamante C++
esamina:
    MOVB    alfa(%RIP), %AL
    MOVQ    beta(%RIP), %RDX
    MOVQ    $0, %RSI

ciclo:
    TESTB   $0x80, %AL
    JZ      zero
    MOVB    $'1', (%RDX, %RSI)
    JMP     avanti

zero:
    MOVB    $'0', (%RDX, %RSI)

avanti:
    SHLB    $1, %AL
    INCQ    %RSI
    CMPQ    $8, %RSI
    JB      ciclo
    RET

