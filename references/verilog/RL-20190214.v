/**
 * File:    RL-20190214.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 11/07/2019.
 */

module RL_20190214(A1, A2, eoc1, eoc2, soc, dav_, rfd, A, clock, reset_);
    input           clock, reset_;
    input   [7:0]   A1;
    input   [7:0]   A2;
    input           eoc1;
    input           eoc2;
    output          soc;
    output          dav_;
    input           rfd;
    output  [7:0]   A;

    reg         SOC;
    reg         DAV_;
    reg  [7:0]  OUT;
    reg  [7:0]  APP;
    reg  [9:0]  COUNT;

    assign soc = SOC;
    assign dav_ = DAV_;
    assign A = OUT;

    reg [2:0] STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    parameter NumPeriodi = 1023;

    always @(reset_ == 0) #1 begin
                                SOC <= 0;
                                DAV_ <= 1;
                                APP <= 'H00;
                                COUNT <= NumPeriodi;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    COUNT <= COUNT - 1;
                    OUT <= APP;
                    SOC <= 1;
                    STAR <= ({eoc1, eoc2} == 'B11)? S0:S1;
                end
            S1: begin
                    COUNT <= COUNT - 1;
                    SOC <= 0;
                    APP <= mia_funzione(A1, A2);
                    STAR <= ({eoc1, eoc2} == 'B11)? S2:S1;
                end
            S2: begin
                    COUNT <= COUNT - 1;
                    DAV_ <= 0;
                    STAR <= (rfd == 0)? S3:S2;
                end
            S3: begin
                    COUNT <= COUNT - 1;
                    DAV_ <= 1;
                    STAR <= (rfd == 1)? S4:S3;
                end
            S4: begin
                    COUNT <= (COUNT == 1)? NumPeriodi : (COUNT - 1);
                    STAR <= (COUNT == 1)? S0:S4;
                end
        endcase

    function [7:0] mia_funzione;
        input   [7:0]   A1;
        input   [7:0]   A2;
        mia_funzione = ((abs_di_intero(A1) - abs_di_intero(A2)) < 0) ? A2:A1;
    endfunction

    function [7:0] abs_di_intero;
        input   [7:0]   A;
        abs_di_intero = (A[7] == 0)? A:(~A + 1);
    endfunction
endmodule

