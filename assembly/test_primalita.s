##
#
# File: test_primalita.s
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
    MOV $2, %BX     # AX contiene il numero N su 16 bit. BX contiene il
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
    INC     %BX         # altrimenti incremento il dividendo di uno
    CMP     %AX, %BX    # controllo che il divisore non sia uguale al numero
    JAE     fine        # salto a fine poiche' il numero e' primo

    # Una finezza: visto che il numero da dividere sta su 16 bit, se non e'
    # primo ha un divisore che sta su 8 bit (teorema di Gauss).
    # Quindi, quando BH e' diverso da 0 (ovvero BX contiene un numero maggiore
    # di 8 bit), posso terminare il ciclo.

    CMP $0, %BH
    JNE fine
    JMP ciclo

nonprimo:
    MOVB    $0, primo

fine:
    JMP     uscita

