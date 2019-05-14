##
#
# File: codifica5a.s
#       Uguale al file codifica2a.s.
#       Quinta nuova versione del programma codifica. Programma misto.
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

.INCLUDE "servi.s"

.EXTERN alfa, beta, esamina

.DATA
    kappa:  .FILL   8, 1

.TEXT

.GLOBAL main
main:

ancora:
    CALL    leggisucc
    MOVB    %AL, %R12B
    CMPB    $'\n', %R12B
    JE      fine
    MOVB    %R12B, %DIL
    CALL    scrivichar
    MOVB    %R12B, alfa(%RIP)
    LEAQ    kappa(%RIP), %RAX
    MOVQ    %RAX, beta(%RIP)
    CALL    esamina
    MOVQ    $0, %R12
    LEAQ    kappa(%RIP), %R13

ripeti:
    MOVB    (%R13, %R12), %DIL
    CALL    scrivisucc
    INCQ    %R12
    CMPQ    $8, %R12
    JB      ripeti
    CALL    nuovalinea
    JMP     ancora

fine:
    MOVL    $0, %EAX
    RET

