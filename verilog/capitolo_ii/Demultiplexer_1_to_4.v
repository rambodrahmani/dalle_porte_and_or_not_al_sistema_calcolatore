/**
 *
 * File:    Demultiplexer_1_to_4.v
 *          Il demultiplexer_1_to_2^N e' una rete combinatoria dotata di una
 *          variabile di ingresso x detta variabile da commutare, di
 *          N variabile di ingresso b dette variabili di comando, di P = 2^N
 *          variabili di uscita z. Le variabili di ingresso b selezionano la
 *          variabile di uscita z p-esima che assumera' il valore della
 *          variabile x, tutte le altre uscite vengono poste a zero. Le
 *          variabili di comando b rappresentano in base due il numero
 *          naturale p dell'uscita p-esima che "insegue" il valore della
 *          variabile di ingresso x.
 *          
 *          Di seguito l'implementazione di un Demultiplexer 1 to 4.
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

