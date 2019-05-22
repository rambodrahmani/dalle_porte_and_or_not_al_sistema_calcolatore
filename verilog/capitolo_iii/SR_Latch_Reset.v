/**
 *
 * File: SR_Latch_Reset.v
 *       Latch SR dotato di preset e preclear per poter impostare lo stato
 *       iniziale.
 *
 *       Le modifiche da apportare consistono nel dotarlo di due ulteriori
 *       variabili di ingresso, attive basse, preset_ e preclear_ che
 *          i)   debbono risultare ininfluenti quando sono a 1;
 *          ii)  non debbono essere contemporaneamente a 0;
 *          iii) l'esser preset_ a 0 e preclear_ a 1, deve imporre S1
 *               (q a 1 qN a 0) come stato interno iniziale;
 *          iv)  l'esser preset_ a 1 e preclear_ a 0, deve imporre S0
 *               (q a 0 qN a 1) come stato interno iniziale.
 *          
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 22/05/2019.
 *
 */

module Latch_SR(q, qN, s, r, preset_, preclear_);
    input s, r, preset_, preclear_;
    output q, qN;

    assign #1 q = ~((preset_ & r) | qN | ~preclear_);
    assign #1 qN = ~(~preset_ | (s & preclear_) | q);
endmodule

