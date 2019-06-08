/**
 *
 * File: D_flip_flop.v
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 08/06/2019.
 *
 */

`include "Clock.v"

module D_flip_flop(q, preset_, preclear_, d);
    input preset_, preclear_;
    input d;
    output q;
    
    wire qN;

    // additional D-flip-flip circuitry
    wire c;
    Clock clock(c);

    // default SR Latch with reset implementation
    assign #3 q = ~((preset_ & (~d & c)) | qN | ~preclear_);
    assign #3 qN = ~(~preset_ | ((d & c) & preclear_) | q);
endmodule

