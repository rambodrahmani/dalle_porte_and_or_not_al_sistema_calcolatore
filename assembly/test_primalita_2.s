##
#
# File: test_primalita_2.s
#       Questa e' una seconda versione modificata del programma test_primalita.s
#       piu' efficiente: si testa la divisione per 2 fuori dal ciclo (basta
#       guardare il LSB di AX), si parte testando 3 come primo divisore, e si
#       saltano tutti i divisori pari sommando ogni volta 2 al divisore.
#
#       Scrivere un programma che si comporta come segue:
#       1. prende in ingresso un numero a 16 bit, contenuto in memoria nella
#          variabile numero;
#       2. controlla se numero e' o meno un numero primo. Se lo e', mette in
#          primo il numero 1. Altrimenti mette in primo il numero 0.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 10/05/2019.
#
##

.INCLUDE "util.s"

.DATA
    numero:     .WORD   39971
    primo:      .BYTE   1

.TEXT

.GLOBAL _start
_start:
    NOP
    MOV numero, %AX
    CMP $3, %AX
    JBE fine        # 1, 2 e 3 sono numeri primi
    RCR %AX
    JNC nonprimo    # testo subito la divisibilita' per 2
    RCL %AX

    # AX contiene il numero N su 16 bit. BX contiene il divisore. BX va
    # inizializzato a 3 e portato, al piu', fino a N - 1.

    MOV $3, %BX     # AX contiene il numero N su 16 bit. BX contiene il
                    # divisore. BX va inizializzato a 2 e portato, al piu', fino
                    # a N - 1.

ciclo:
    MOV     $0, %DX # [DX, AX] contiene il numero N su 32 bit
    PUSH    %AX     # salvo il contenuto di AX prima di effettuare la divisione
    DIV     %BX
    POP     %AX     # si ripristina il contenuto di AX dopo la divisione
    CMP     $0, %DX # DX contiene il resto della divisione. Se il resto vale 0
                    # allora il numero ammette divisore e non e' primo
    JE      nonprimo    # salto a nonprimo se il resto vale zero
    ADD     $2, %BL     # ogni volta che incremento il divisore, controllo se il
    JC      fine        # divisore sta su 8 bit o no (teorema di Gauss)
    CMP     %AX, %BX
    JAE     fine
    JMP     ciclo

nonprimo:
    MOVB    $0, primo

fine:
    JMP     uscita

