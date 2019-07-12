/**
 * File:    RL-20190625.v
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 10/07/2019.
 */

module RL_20190625(in_comb, out_comb, dav_, rfd, riga, clock, reset_);
    input			clock, reset_;
    output	[3:0]	in_comb;
    input	[3:0]	out_comb;
    output			dav_;
    input			rfd;
    output	[23:0]	riga;

    reg	[3:0]	IN_COMB;
    reg			DAV_;
    reg	[23:0]	RIGA;

    assign in_comb = IN_COMB;
    assign dav_ = DAV_;
    assign riga = RIGA;

    reg	[1:0]	STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    always @(reset_ == 0) #1 begin
                                IN_COMB <= 'B000;
                                DAV_ <= 1;
                                STAR <= S0;
                             end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: begin
                    RIGA <= {{5'B00110, IN_COMB}, {8'B00111010}, {5'B00110, out_comb}};
                    STAR <= S1;
                end
            S1: begin
                    DAV_ <= 0;
                    STAR <= (rfd == 1)? S1:S2;
                end
            S2: begin
                    DAV_ <= 1;
                    STAR <= (rfd == 1)? S3:S2;
                end
            S3: begin
                    IN_COMB <= (IN_COMB == 7)? IN_COMB:(IN_COMB + 1);
                    STAR <= (IN_COMB == 7)? S3:S0;
                end
        endcase
endmodule

