##
#
# File: conteggio_bit_2b.s (sottoprogramma 'conta')
#       Scrivere un programma che:
#       - definisce un vettore numeri di enne numeri naturali a 16 bit in
#         memoria (enne sia una costante simbolica);
#       - definisce un sottoprogramma per contare il numero di bit a 1 di un
#         numero a 16 bit. Tale sottoprogramma ha come parametro di ingresso il
#         numero da analizzare (in AX), e restituisce il numero di bit a 1 in
#         CL;
#       - utilizzando il sottoprogramma appena descritto, calcola il numero
#         totale di bit a 1 nel vettore ed inserisce il risultato in una
#         variabile conteggio di tipo word.
#
#       Conta il numero di bit a 1 in una WORD.
#           ingresso: %AX, [word da analizzare]
#           uscita:   %CL, [conto dei bit a 1]
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/05/2019.
#
##

.TEXT

.GLOBAL conta
conta:
    PUSH %AX        # salvo il contenuto di %AX
    MOVB $0x00, %CL # azzero $CL

comp:
    CMP  $0x00, %AX
    JE   fine        # se %AX e' uguale a zero ho finito
    SHR  %AX         # Shifto a destra il contenuto di %AX
    ADCB $0x0, %CL   # ADD con carry. Se il shift precedente ha prodotto
                     # carry (il bit shiftato valeva 1) %CL viene incrementato
                     # di 1
    JMP  comp

fine:
    POP %AX     # ripristino il contenuto di %AX
    RET         # ritorno al programma principale

