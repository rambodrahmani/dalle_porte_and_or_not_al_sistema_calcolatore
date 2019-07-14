/**
 * File:    RL-20180911.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 14/07/2019.
 */

module RL_20180911(dav_, rfd, enne, a13_a0, d7_d0, campione, clock, reset_);
    input           clock, reset_;
    input           dav_;
    output          rfd;
    input   [3:0]   enne;
    output  [13:0]  a13_a0;
    input   [7:0]   d7_d0;
    output  [7:0]   campione;

    reg          RFD;
    reg  [13:0]  A13_A0;
    reg  [7:0]   CAMPIONE;
    reg  [3:0]   COUNT;

    assign rfd = RFD;
    assign a13_a0 = A13_A0;
    assign campione = CAMPIONE;

    reg  [1:0]  STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    parameter NumCampioni = 1024;

    always @(reset_ == 0) #1 begin
                                RFD <= 0;
                                COUNT <= NumCampioni;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    RFD <= 1;
                    CAMPIONE <= 'H00;
                    A13_A0 <= {enne, 10'B0000000000};
                    STAR <= (dav_ == 1)? S0:S1;
                end
            S1: begin
                    RFD <= 0;
                    STAR <= (dav_ == 0)? S1:S2;
                end
            S2: begin
                    CAMPIONE <= d7_d0;
                    STAR <= S3;
                end
            S3: begin
                    A13_A0 <= A13_A0 + 1;
                    COUNT <= (COUNT == 1)? NumCampioni : (COUNT - 1);
                    STAR <= (COUNT == 1)? S0:S2;
                end
        endcase
endmodule

