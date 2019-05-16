##
#
# File: calcolo_del_fattoriale.s
#       Si scriva un programma che calcola il fattoriale di un numero naturale
#       (da 0 a 9) contenuto nella variabile numero, di tipo byte. Il risultato
#       deve essere inserito in una variabile risultato, di dimensione
#       opportuna. Si controlli che dato non ecceda 9. Prestare attenzione al
#       dimensionamento della moltiplicazione.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 02/05/2019.
#
##

.INCLUDE "util.s"

.GLOBAL _start

.DATA
    numero:     .BYTE   9
    risultato:  .LONG   1

.TEXT
_start:
    NOP
    MOV $0, %ECX        # azzera il contenuto di ECX
    MOV $1, %EAX        # mette a 1 EAX, il moltiplicando default a 32 bit
    MOV numero, %CL     # copia numero in CL (parte bassa di ECX)
    CMP $9, %CL
    JA  fine            # se CL contiene un numero piu' grande di 9 mi fermo
    CMP $1, %CL
    JBE fine            # se CL contiene un numero piu' piccolo di 1 mi fermo

# Se numero e' compreso tra 1 e 9 continuo, ricordiamo infatti che il fattoriale
# di 0 e' uguale ad 1 che si trova gia' inserito dentro EAX.

ciclo_f:
    MUL %ECX        # AEX = AEX*ACX, ricordiamo che in CL e' stato inserito
                    # numero
    DEC %CL         # decremento CL di 1
    JNZ ciclo_f     # sinche' CL non vale 0 ripeto il ciclo, devo infatti
                    # moltiplicare 'numero' per tutti i valori da 9 a 1

fine:
    MOV %EAX,   risultato   # copia il fattoriale nella variabile risultato
    JMP uscita

