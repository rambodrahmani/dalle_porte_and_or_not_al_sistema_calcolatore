/**
 * File: D_flip_flop_Reg.v
 *       
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 */

`include "Clock.v"

module D_flip_flop_Reg(d, q, reset_);
    input reset_;
    input d;
    output q;

    wire c;
    Clock clock(c);

    reg D_EDGE;

    assign q = D_EDGE;

    always @(reset_ == 0) #1 D_EDGE <= 0;

    always @(posedge c) if (reset_ == 1) #3 D_EDGE <= (c == 1) ? d:D_EDGE;
    
endmodule

