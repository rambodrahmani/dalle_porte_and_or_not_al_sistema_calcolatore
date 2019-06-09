/**
 *
 * File: Elemento_Contatore_Base_3.v
 *       Base B = 3. Con cifra 0 codificata oo, cifra 1 codificata 01 e cifra
 *       2 codificata 10. Il registro ha capiacita' di due bit; indicando con
 *       q1_q0 la sua variabile di uscita a due bit e con a1_a0 la sua
 *       variabile di ingresso a due bit, ne deriva che l'incrementatore
 *       interno al contatore ha q1_q0 ed ei come variabili di ingresso
 *       e a1_a0 ed eu come variabili di uscita. Una possibile descrizione, in
 *       linguaggio Verilog, di un elemento contatore in base 3 con
 *       incrementatore interno, e' la seguente:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

module Elemento_Contatore_Base_3(eu, q1_q0, ei, clock, reset_);
    input clock, reset_;
    input ei;
    output eu;
    output [1:0] q1_q0;

    reg [1:0] OUTR;
    assign q=OUTR;

    wire [1:0] a1_a0;   // variabile di uscita dell'incrementatore

    assign {a1_a0, eu} = ({q1_q0, ei} == 'B000)?'B000:
                         ({q1_q0, ei} == 'B010)?'B010:
                         ({q1_q0, ei} == 'B100)?'B100:
                         ({q1_q0, ei} == 'B001)?'B010:
                         ({q1_q0, ei} == 'B011)?'B100:
                         ({q1_q0, ei} == 'B101)?'B001:
                         /* default */  'BXXX;

    always @(reset_ == 0) #1 OUTR<='B00;
    always @(posedge clock) if (reset_ == 1) #3 OUTR <= a1_a0;
endmodule

