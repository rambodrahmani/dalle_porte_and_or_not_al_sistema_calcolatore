/**
 * File:    RL-20190129.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 12/07/2019.
 */

module RL_20190129(soc, eoc, x7_x0, out, pulse_sicuro, reset_sr, clock, reset_);
    input           clock, reset_;
    output          soc;
    input           eoc;
    input   [7:0]   x7_x0;
    output  [7:0]   out;
    input           pulse_sicuro;
    output          reset_sr;

    reg         SOC;
    reg  [7:0]  APP;
    reg  [7:0]  OUT;
    reg  [6:0]  COUNT;
    reg         RESET_SR;

    assign soc = SOC;
    assign out = OUT;
    assign reset_sr = RESET_SR;

    reg  [1:0]  STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    parameter Num_Periodi = 100;

    always @(reset_ == 0) #1 begin
                                SOC <= 0;
                                COUNT <= Num_Periodi;
                                APP <= 'H00;
                                RESET_SR <= 1;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    COUNT <= COUNT - 1;
                    OUT <= APP;
                    RESET_SR <= 0;
                    SOC <= 1;
                    STAR <= (eoc == 1)? S0:S1;
                end
            S1: begin
                    COUNT <= COUNT - 1;
                    SOC <= 0;
                    APP <= x7_x0;
                    STAR <= (eoc == 1)? S2:S1;
                end
            S2: begin
                    COUNT <= (COUNT == 1)? Num_Periodi:(COUNT - 1);
                    OUT <= (pulse_sicuro == 1)? 'H00:OUT;
                    RESET_SR <= (pulse_sicuro == 1)? 1:0;
                    STAR <= (COUNT == 1)? S0:S2;
                end
        endcase
endmodule

