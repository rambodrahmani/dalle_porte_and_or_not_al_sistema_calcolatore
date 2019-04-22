/**
 *
 * File:    Decoder_2_to_4_EN.v
 *          Il decoder con abilitazione e' un decoder N_to_2^N dotato di
 *          un'ulteriore variabile di ingresso en, avente lo scopo di forzare
 *          a zero, quando essa stessa vale zero, il valore di tutte le
 *          variabili di uscita.
 *          
 *          Di seguito l'implementazione di un Decoder 2 to 4 con enabler.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 *
 */

module Decoder_2_to_4_EN(en, x1, x0, z3, z2, z1, z0);
    input en, x1, x0;
    output z3, z2, z1, z0;

    assign z3 = en & ({x1, x0}=='B11)?1:0;
    assign z2 = en & ({x1, x0}=='B10)?1:0;
    assign z1 = en & ({x1, x0}=='B01)?1:0;
    assign z0 = en & ({x1, x0}=='B00)?1:0;
endmodule

