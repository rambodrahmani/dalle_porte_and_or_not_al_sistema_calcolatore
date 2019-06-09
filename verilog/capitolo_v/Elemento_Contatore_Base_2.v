/**
 *
 * File: Elemento_Contatore_Base_2.v
 *       Base B = 2. Con cifra 0 codificata come 0 e cifra 1 codificata con 1.
 *       Il registro ha la capacita' di un bit; indicando con q la sua
 *       variabile di uscita e con a la sua variabile di ingresso, ne deriva
 *       che l'incrementatore interno al contatore ha q ed ei come variabili
 *       di ingresso e a ed eu come variabili di uscita. Una possibile
 *       descrizione, in linguaggio Verilog, di un elemento di contatore in
 *       base 2 con incrementatore interno, e' la seguente:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

module Elemento_Contatore_Base_2(eu, q, ei, clock, reset_);
    input clock, reset_;
    input ei;
    output eu, q;
    
    reg OUTR;
    assign q=OUTR;

    wire a; // variabile di uscita dell'incrementatore

    assign {a, eu} = ({q, ei} == 'B00)? 'B00:
                     ({q, ei} == 'B10)? 'B10:
                     ({q, ei} == 'B01)? 'B10:
                   /*({q, ei} == 'B11)*/? 'B01;
    
    always @(reset_ == 0) #1 OUTR <= 0;
    always @(posedge clock) if (reset_ == 1) #3 OUTR <= a;
endmodule

