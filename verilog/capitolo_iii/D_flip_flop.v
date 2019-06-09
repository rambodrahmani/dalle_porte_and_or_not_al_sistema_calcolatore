/**
 *
 * File: D_flip_flop.v
 *       Un flip-flop che si comporti, a prescindere dalla sua
 *       implementazione, come quello ora introdotto, e' detto
 *       positive-edge-triggered D flip-flop in quanto, visto da un
 *       utilizzatore, memorizza esclusivamente il valore della variabile di
 *       ingresso d che e' presente all'atto della transizione da 0 a 1 della
 *       variabile c, cioe', come si dice comunemente, all'arrivo del fronte
 *       di salita di c. Esistono anche i negative-edge-triggered D flip-flop,
 *       che memorizzano esclusivamente il valore della variabile d che e'
 *       presente all'atto della transizione da 1 a 0 della variabile c.
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

