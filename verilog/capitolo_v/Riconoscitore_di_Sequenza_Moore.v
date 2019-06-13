/**
 * File: Riconoscitore_di_Sequenza_Moore.v
 *       Come secondo esempio consideriamo il riconoscitore della sequenza 11,
 *       01, 10. Esso e' una rete sequenziale sincronizzata con due variabili
 *       di ingresso x1 e x0 e una variabile di uscita z e che si evolve in
 *       accordo alle seguenti specifiche: quando arriva il segnale di
 *       sincronizzazione, se lo stato di ingresso e' 10 e se il precedente
 *       stato di ingresso era stato 01 e se quello ancora precedente era
 *       stato 11, allora e solo allora il riconoscitore mette a 1 il valore
 *       della variabile di uscita.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/06/2019.
 */

module Riconoscitore_di_Sequenza_Moore(z, x1_x0, clock, reset_);
    input       clock, reset_;
    input [1:0] x1_x0;
    output      z;

    reg [1:0]   STAR;
    parameter S0 = 'B00, S1 = 'B01, S2 = 'B10, S3 = 'B11;

    assign z = (STAR==S3)?1:0;

    always @(reset_ == 0) #1 STAR <= S0;

    always @(posedge clock) if (reset_ == 1) 33
        casex(STAR)
            S0: STAR <= (x1_x0 == 'B11)?S1:S0;
            S1: STAR <= (x1_x0 == 'B01)?S2:(x1_x0 == 'B11)?S1:S0;
            S2: STAR <= (x1_x0 == 'B10)?S3:(x1_x0 == 'B11)?S1:S0;
            S3: STAR <= (x1_x0 == 'B11)?S1:S0;
        endcase
endmodule

