/**
 * File:    RL-20190604.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 10/07/2019.
 */

module RL_20190604(x, d15_d0, a3_a0, z7_z0, clock, reset_);
    input           clock, reset_;
    input           x;
    input   [15:0]  d15_d0;
    output  [3:0]   a3_a0;
    output  [7:0]   z7_z0;

    reg  [3:0]  A3_A0;
    reg  [7:0]  OUT;
    reg  [3:0]  COUNT;

    assign a3_a0 = A3_A0;
    assign z7_z0 = OUT;

    reg  [1:0] STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    parameter Num_Periodi = 10;

    always @(reset_ == 0) #1 begin
                                A3_A0 <= 0;
                                OUT <= 0;
                                COUNT <= Num_Periodi;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    COUNT <= COUNT - 1;
                    A3_A0 <= (x == 0)? d15_d0[15:12] : d15_d0[11:8];
                    OUT <= d15_d0[7:0];
                    STAR <= S1;
                end
            S1: begin
                    COUNT <= (COUNT == 1)? Num_Periodi : (COUNT - 1);
                    STAR <= (COUNT == 9)? S0 : S1;
                end
        endcase
endmodule

