##
#
# File: codifica2b.s
#       Versione alternativa del programma codifica.s compilabile utilizzando il
#       comando g++.
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

.DATA

.GLOBAL alfa, beta
    alfa:   .BYTE   0
    beta:   .QUAD   0

.TEXT

.GLOBAL esamina
esamina:
    PUSHQ   %RAX
    PUSHQ   %RBX
    PUSHQ   %RSI
    MOVB    alfa(%RIP), %AL
    MOVQ    beta(%RIP), %RBX
    MOVQ    $0, %RSI

ciclo:
    TESTB   $0x80, %AL
    JZ      zero
    MOVB    $'1', (%RBX, %RSI)
    JMP     avanti

zero:
    MOVB    $'0', (%RBX, %RSI)

avanti:
    SHLB    $1, %AL
    INCQ    %RSI
    CMPQ    $8, %RSI
    JB      ciclo
    POPQ    %RSI
    POPQ    %RBX
    POPQ    %RAX
    RET

