/**
 * File:    NOT.v
 *          Porta logica che inverte il segnale in ingresso.
 *          Questa porta logica ha un solo ingresso ed una uscita che sara' 1 se
 *          l'ingresso e' 0 o 0 se l'ingresso e' 1.
 *          
 *          Segue la tavola di verità:
 *
 *          |----------------|
 *          | INPUT | OUTPUT |
 *          |----------------|
 *          |   A   |  NOT A |
 *          |----------------|
 *          |   0   |    1   |
 *          |   1   |    0   |
 *          |----------------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 18/04/2019.
 */

module NOT(x, z);
    input x;
    output z;

    assign z = (x == 0)?1:0;
    
    // equivalentemente potevamo scrivere
    // assign z = ~x;
endmodule

