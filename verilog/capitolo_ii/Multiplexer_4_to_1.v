/**
 * File:    Multiplexer_4_to_1.v
 *          La rete combinatoria che svolte funzioni complementari rispetto al
 *          demultiplexer e' nota come multiplexer 2^N_to_1. Essa ha
 *          N variabili di ingresso di comando b, P = 2^N variabili di
 *          ingresso da commutare x, una variabile di uscita z e la sue legge
 *          di evoluzione e' la seguente: "il valore della variabile di uscita
 *          z insegue il valore della variabile x p-esima quando lo stato
 *          delle variabili di comando b, interpretato come la
 *          rappresentazione in base due di un numero naturale, rappresenta p.
 *          
 *          Di seguito l'implementazione di un Multiplexer 4 a 1.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 23/04/2019.
 */

/**
 * Multiplexer 4 to 1.
 */
module Multiplexer_4_to_1(x3, x2, x1, x0, b1, b0, z);
    input x3, x2, x1, x0, b1, b0;
    output z;

    assign z = ({b1, b0}=='B11)?x3: // 'B11 = 3
               ({b1, b0}=='B10)?x2: // 'B10 = 2
               ({b1, b0}=='B01)?x1: // 'B01 = 1
          /*({b1, b0}=='B00)?*/ x0; // 'B00 = 0
endmodule

