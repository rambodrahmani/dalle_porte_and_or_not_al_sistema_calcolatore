/**
 *
 * File:    Decoder_2_to_4.v
 *          Il decoder N_to_2^N e' una rete combinatoria dotata di N variabili
 *          di ingresso e di P = 2^N variabili di uscita, ed in cui ogni
 *          variabile di uscita riconosce uno ed uno solo degli stati di
 *          ingresso: in particolare la p-esima variabile di uscita (z)
 *          riconosce lo stato di ingresso che, interpretato come
 *          rappresentazione in base due di un numero naturale, rappresenta
 *          porprio il numero p.
 *          
 *          Puo' anche essere pensato come un convertitore da binario
 *          a decimale.
 *          
 *          Di seguito l'implementazione di un Decoder 2 to 4.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 *
 */

module Decoder_2_to_4(x1, x0, z3, z2, z1, z0);
    input x1, x0;
    output z3, z2, z1, z0;

    assign z3 = ({x1, x0}=='B11)?1:0;
    assign z2 = ({x1, x0}=='B10)?1:0;
    assign z1 = ({x1, x0}=='B01)?1:0;
    assign z0 = ({x1, x0}=='B00)?1:0;
endmodule

