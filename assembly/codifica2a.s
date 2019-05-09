##
#
# File: codifica2a.s
#       Versione alternativa del programma codifica.s compilabile utilizzando il
#       comando g++.
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
#       Il comando g++:
#           g++ id_file1.s ... id_fileN.s -o id_file
#
#       - richiama singolarmente l'assemblatore per i file id_file1.s ...
#         id_fileN.s, producendo N file oggetto aventi uguale identificatore e
#         estensione .o;
#       - richiama il collegatore per gli N file oggetti precedenti e alcuni
#         file di libreria, producendo il file eseguibile id_file;
#       - l'opzione -o id_file puo' essere omessa, ed in questo caso
#         l'identificatore del file eseguibile e' a.out.
#
#       In questo modo, uno dei file collegati deve fungere da interfaccia con
#       l'Assembly:
#       - contiene l'entry_point _start (identificatore esplicitamente
#         dichiarato globale);
#       - richiama il sottoprogramma main() (identificatore esplicitamente
#         dichiarato globale);
#       - il sottoprogramma main() deve produrre un risultato intero che lascia
#         in EAX;
#       - al ritorno dal sottoprogramma main(), restituisce il controllo a UNIX
#         con le istruzioni
#
#           MOVL    %EAX,   %EBX
#           MOVL    $1,     %EAX
#           INT     0x80
#
#       - utilizzando il comando g++, occottore pertanto organizzare il
#         programma principale come un sottoprogramma, avente identificatore
#         main() e che lascia il risultato in %EAX.
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
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 08/05/2019.
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

