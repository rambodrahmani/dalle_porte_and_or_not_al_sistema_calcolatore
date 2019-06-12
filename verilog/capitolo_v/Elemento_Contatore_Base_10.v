/**
 * File: Elemento_Contatore_Base_10.v
 *       Base B = 10. Con cifra 0 codificata 0000, cifra 1 codificata 0001,
 *       ..., cifra 9 codificata 1001 (codifica 8-4-2-1). Il registro ha la
 *       capacita' di quattro bit; indicando con q3_q0 la sua variabile di
 *       uscita a quattro bit e con a3_a0 la sua variabile di ingresso
 *       a quattro bit, ne deriva che l'incrementatore interno al contatore ha
 *       q3_q0 ed ei come variabili di ingresso e a3_a0 ed eu come variabili
 *       di uscita. Una possibile descrizione, in linguaggio Verilog, di un
 *       elemento contatore in base 1- con incrementatore interno, e' la
 *       seguente:
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 */

module Elemento_Contatore_Base_3(eu, q3_q0, ei, clock, reset_);
    input clock, reset_;
    input ei;
    output eu;
    output [3:0] q3_q0;

    reg [3:0] OUTR;
    assign q=OUTR;

    wire [3:0] a1_a0;   // variabile di uscita dell'incrementatore

    assign {a1_a0, eu} = ({q3_q0, ei} == 'B00000)?'B00000:  // 0 + 0 = 0
                         ({q3_q0, ei} == 'B00010)?'B00010:  // 1 + 0 = 1
                         ({q3_q0, ei} == 'B00100)?'B00100:  // 2 + 0 = 2
                         ({q3_q0, ei} == 'B00110)?'B00110:  // 3 + 0 = 3
                         ({q3_q0, ei} == 'B01000)?'B01000:  // 4 + 0 = 4
                         ({q3_q0, ei} == 'B01010)?'B01010:  // 5 + 0 = 5
                         ({q3_q0, ei} == 'B01100)?'B01100:  // 6 + 0 = 6
                         ({q3_q0, ei} == 'B01110)?'B01110:  // 7 + 0 = 7
                         ({q3_q0, ei} == 'B10000)?'B10000:  // 8 + 0 = 8
                         ({q3_q0, ei} == 'B10010)?'B10010:  // 9 + 0 = 9
                         ({q3_q0, ei} == 'B00001)?'B00010:  // 0 + 1 = 1
                         ({q3_q0, ei} == 'B00011)?'B00100:  // 1 + 1 = 2
                         ({q3_q0, ei} == 'B00101)?'B00110:  // 2 + 1 = 3
                         ({q3_q0, ei} == 'B00111)?'B01000:  // 3 + 1 = 4
                         ({q3_q0, ei} == 'B01001)?'B01010:  // 4 + 1 = 5
                         ({q3_q0, ei} == 'B01011)?'B01100:  // 5 + 1 = 6
                         ({q3_q0, ei} == 'B01101)?'B01110:  // 6 + 1 = 7
                         ({q3_q0, ei} == 'B01111)?'B10000:  // 7 + 1 = 8
                         ({q3_q0, ei} == 'B10001)?'B10010:  // 8 + 1 = 9
                         ({q3_q0, ei} == 'B10011)?'B00001:  // 9 + 1 = 0 => ei = 1
                         /* default */  'BXXXXX;

    always @(reset_ == 0) #1 OUTR<='H0;
    always @(posedge clock) if (reset_ == 1) #3 OUTR <= a3_a0;
endmodule

