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
 *         Created on 11/05/2019.
 *
 */

module D_Latch_System(q, qN, s, r, c, d);
    input c, d;
    output q, qN, s, r;

    assign #1 s = d & c;
    assign #1 r = ~d & c;

    // Default SR Latch Behavoir
    assign #1 q = ~(r|qN);
    assign #1 qN = ~(s|q);
endmodule

