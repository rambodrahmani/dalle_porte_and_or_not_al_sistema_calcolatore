/**
 * File:    RL-20190108.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 12/07/2019.
 */

module RL_20190108(ior_, iow_, d7_d0, a1_a0, clock, reset_);
    input           clock, reset_;
    output          ior_;
    output          iow_;
    inout   [7:0]   d7_d0;
    output  [1:0]   a1_a0;

    reg         IOR_;
    reg         IOW_;
    reg  [7:0]  D7_D0;
    reg         DIR;
    reg  [1:0]  A1_A0;
    reg  [3:0]  COUNT;

    assign ior_ = IOR_;
    assign iow_ = IOW_;
    assign d7_d0 = (DIR == 1)? D7_D0 : 'HZZ;
    assign a1_a0 = A1_A0;
    
    reg [2:0] STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    parameter Num_Cicli = 9;

    always @(reset_ == 0) #1 begin
                                COUNT <= Num_Cicli;
                                IOR_ <= 1;
                                IOW_ <= 1;
                                DIR <= 0;
                                A1_A0 <= 0;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    COUNT <= COUNT - 1;
                    IOR_ <= 0;
                    STAR <= S1;
                end
            S1: begin
                    COUNT <= COUNT - 1;
                    D7_D0 <= d7_d0;
                    IOR_ <= 1;
                    A1_A0 <= A1_A0 + 1;
                    DIR <= 1;
                    STAR <= S2;
                end
            S2: begin
                    COUNT <= COUNT - 1;
                    IOW_ <= 0;
                    STAR <= S3;
                end
            S3: begin
                    COUNT <= COUNT - 1;
                    IOW_ <= 1;
                    STAR <= S4;
                end
            S4: begin
                    COUNT <= (COUNT == 1)? Num_Cicli : (COUNT - 1);
                    STAR <= (COUNT == 1)? S0:S4;
                end
        endcase
endmodule

