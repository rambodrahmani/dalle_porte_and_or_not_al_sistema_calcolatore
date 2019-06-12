/**
 * File: Interfaccia_Parallela_di_Uscita.v
 *       Il funzionamento dell'interfaccia e' estremamente semplice. Quando
 *       essa e' selezionata (/s = 0) e /iow passa da 1 a 0 (inizio di un
 *       ciclo di scrittura), allora e passa da 0 a 1 e il registro TBR
 *       memorizza il byte presentato dal processore all'interfaccia come
 *       stato della variabile di ingresso d7_d0. Questo byte e' quindi
 *       disponibile per il dispositivo di uscita, come stato della variabile
 *       di uscita byte_out.
 *
 *       La descrizione, in linguaggio Verilog, dell'interfaccia e' la
 *       seguente:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 */

module Interfaccia_Parallela_di_Uscita(d7_d0, s_, iow_, byte_out);
    input           s_, iow_;
    input   [7:0]   d7_d0;
    output  [7:0]   byte_out;

    reg [7:0] TBR;
    assign byte_out = TBR;

    wire e;
    assign e = ({s_, iow_}=='B00)? 1 : 0;   // e = ~(s_ | iow_);

    always @(posedge e) #3 TBR<=d7_d0;
endmodule

