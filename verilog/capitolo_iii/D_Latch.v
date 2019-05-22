/**
 *
 * File: D_Latch.v
 *       Si consideri ora un sistema digitale o una rete logica in cui siano
 *       inclusi dei D latch. Il linguaggio Verilog permette di evitare la
 *       descrizione della loro struttura, a patto che ciascuno di essi sia
 *       dichiarato come rete di tipo predefinito reg e che nel descrivere il
 *       suo utilizzo si seguano regole ben precise, quale le seguenti (le
 *       variabili c, d, q, /reset hanno il solito significiato e debbono
 *       essere precedentemente dichiarate):
 *          
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 22/05/2019.
 *
 */

module D_Latch(q, qN, s, r, preset_, preclear_, d, c);
    input preset_, preclear_;
    input d, c;
    output s, r;
    output q, qN;

    // d latch additional circuitry
    assign #1 s = d & c;
    assign #1 r = ~d & c;

    // default SR Latch with reset implementation
    assign #2 q = ~((preset_ & r) | qN | ~preclear_);
    assign #2 qN = ~(~preset_ | (s & preclear_) | q);
endmodule

