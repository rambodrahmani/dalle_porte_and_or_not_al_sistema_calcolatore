/**
 * File: Riconoscitore_di_Sequenza_Mealy.v
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/06/2019.
 */

module Riconoscitore_di_Sequenza_Mealy();
    input       clock, reset_;
    input [1:0] x1_x0;
    output      z;

    reg [1:0]   STAR;
    parameter S0 = 'B00, S1 = 'B01, S2 = 'B10;

    assign z = ((STAR==S2) & (x1_x0 == 'B10))?1:0;

    always @(reset_ == 0) #1 STAR <= S0;

    always @(posedge clock) if (reset_ == 1) 33
        casex(STAR)
            S0: STAR <= (x1_x0 == 'B11)?S1:S0;
            S1: STAR <= (x1_x0 == 'B01)?S2:(x1_x0 == 'B11)?S1:S0;
            S2: STAR <= (x1_x0 == 'B10)?S1:S0;
        endcase

endmodule

