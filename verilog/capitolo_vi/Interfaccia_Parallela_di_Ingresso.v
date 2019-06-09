/**
 *
 * File: Interfaccia_Parallela_di_Ingresso.v
 *       Il funzionamento dell'interfaccia e' estremamente semplice. Quando
 *       essa e' selezionata (/s = 0) e /ior passa da 1 a 0 (inizio di un
 *       ciclo di lettura), allora anche e passa da 0 a 1 e il registro RBR
 *       memorizza il byte che il dispositivo di ingresso ha presentato
 *       all'interfaccia come stato della variabile byte_in.
 *       Per tutta la durata del ciclo di lettura, /s e /ior rimangono
 *       entrambe a 0, cosicche' anche e rimane a 1; questo implica che le
 *       8 porte 3-state interne all'interfaccia sono in conduzione, che la
 *       variabile d7_d0 e' variabile di uscita e che lo stato di questa
 *       variabile coincide con il contenuto del registro RBR. In tutte le
 *       altre condizioni, le porte 3-state sono in alta impedenza.
 *       
 *       La descrizione, in linguaggio Verilog, dell'interfaccia e' la
 *       seguente:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

module Interfaccia_Parallela_di_Ingresso(d7_d0, s_, ior_, byte_in);
    input           s_, ior_;
    output  [7:0]   d7_d0;
    input   [7:0]   byte_in;
    reg     [7:0]   RBR;
    
    wire   e;
    assign e = ({s_, ior_}=='B00)?1:0;  // e = ~(s_|ior_);

    assign d7_d0 = (e == 1)?RBR:'HZZ;

    always @(posedge e) #3 RBR<=byte_in;
endmodule

