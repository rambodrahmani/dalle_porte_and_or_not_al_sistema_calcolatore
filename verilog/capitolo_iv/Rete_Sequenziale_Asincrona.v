/**
 *
 * File: Rete_Sequenziale_Asincrona.v
 *       Una rete sequenziale asincrona con N variabili di ingresso x[N-1],
 *       ...,x[0], M variabili di uscita z[M-1], ..., z[0] e K stati interni
 *       S0, S1, ..., S[k-1] e' una struttura che soddisfa i seguenti
 *       requisiti:
 *          i)   e' dotata di un dispositivo che gli permette di memorizzare a
 *               ogni istante uno stato interno, detto stato interno presente;
 *          ii)  e' caratterizzata da una legge A che associa a ogni coppia
 *               [stato interno S[k], stato di ingresso X[p]] uno stato interno
 *               S[j] = A(S[k], X[p]);
 *          iii) e' caratterizzata da una seconda legge Z che associa a ogni
 *               stato interno S[k] uno stato di uscita Z[k] = Z(S[k]);
 *          iv)  attempera alla seguente legge di evoluzione temporale: se
 *               X[p] e S[k] sono lo stato di ingresso e lo stato interno
 *               presenti a un certo istante, assegnare alle variabili di
 *               uscita lo stato Z[k] = Z(S[k]); individuare inoltre lo stato
 *               interno S[j] = A(S[k], X[p]), considerandolo come stato
 *               interno successivo e quindi memorizzarlo, promuovendo al
 *               rango di stato interno presente, e cosi' via all'infinito.
 *       
 *       Una rete sequenziale asincrona e' pertanto un circuito sempre in
 *       evoluzione; negli intervalli di tempo in cui lo stato interno
 *       successivo coincide con lo stato interno presente, la rete e' pero'
 *       in una situazione di stabilita', in quanto non cambiano ne' lo stato
 *       interno memorizzato ne lo stato di uscita.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

module Rete_Sequenziale_Asincrona(z7_z0, x7_x0);
    input [7:0] x7_x0;
    output [7:0] z7_z0;

    wire [3:0] y3_y0;
    wire [3:0] a3_a0;

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    assign #1 a3_a0 = A(y3_y0, z7_z0);

    assign #2 y3_y0 = a3_a0;

    assign #1 z7_z0 = Z(y3_y0);

    function [10:0] A;
        input [7:0] x7_x0;
        input [3:0] y3_y0;
        casex(y3_y0)
            S0: A = ...
                ...
            S3: A = ...
        endcase
    endfunction

    function [3:0] Z;
        input [3:0] y3_y0;
        casex(y3_y0)
            S0: Z = ...
                ...
            S3: Z = ...
        endcase
    endfunction
endmodule

