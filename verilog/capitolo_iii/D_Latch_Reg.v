/**
 *
 * File: D_Latch_Reg.v
 *       Si consideri ora un sistema digitale o una rete logica in cui sono
 *       inclusi dei D latch. Il linguaggio Verilog permette di evitare la
 *       descrizione della loro struttura, purche' ciascuno di essi sia
 *       dichiarato come rete di tipo predefinito reg e purche' nel descrivere
 *       il suo utilizzo si seguano regole ben precise.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 08/06/2019.
 *
 */

module D_Latch_Reg(d, c, q, reset_);
    input reset_;
    input d;
    input c;
    output q;

    reg D_LATCH;

    assign q = D_LATCH;

    always @(reset_ == 0) #1 D_LATCH <= 0;

    always @(c or d) if (reset_ == 1) #2 D_LATCH <= (c == 1) ? d:D_LATCH;
endmodule

