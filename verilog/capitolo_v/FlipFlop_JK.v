/**
 * File: FlipFlop_JK.v
 *       E' caratterizzato da due ingressi, due uscite complementari e un
 *       ingresso di sincronizzazione. Ha funzioni di memoria, reset, set. A
 *       differenza dei Flip-flop SR non ha stati proibiti, ovvero le due
 *       entrate possono assumere qualsiasi valore (0-0,0-1,1-0,1-1).
 *
 *       Quindi, quando J e K valgono entrambi 1, le uscite vengono
 *       completamente scambiate (ossia se erano 1 diventano 0 e viceversa),
 *       trasformandosi in un flip-flop T; quando valgono zero, vengono
 *       mantenute in memoria. 
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 23/05/2019.
 */

module FlipFlop_JK(q, j, k, clock, reset_);
    input clock, reset_;
    input j, k;
    output q;

    reg STAR;
    parameter S0 = 'B0, S1 = 'B1;

    assign q = (STAR == S0)?0:1;

    always @(reset_ == 0) #1 STAR <= S0;

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0: STAR <= (j == 0)? S0:S1;
            S1: STAR <= (k == 0)? S1:S0;
        endcase
endmodule

