/**
 *
 * File:    NAND.v
 *          Al contrario la porta NAND restituisce la negazione di una porta
 *          AND, quindi restituisce 1 quando negli ingressi e' presente lo 0, e
 *          0 solo quando tutti i valori in ingresso sono 1. Il valore uscente
 *          si puo' trovare tramite la formula Y = 1-(A*B) in cui Y e' l'output,
 *          con tre input Y = 1-(A*B*C) e cosi' via.
 *
 *          Segue la tavola di verità: 
 *
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |NOT{A*B}|
 *          |------|-----|--------|
 *          |   0  |  0  |   1    |
 *          |   0  |  1  |   1    |
 *          |   1  |  0  |   1    |
 *          |   1  |  1  |   0    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 18/04/2019.
 *
 */

module NAND(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = ({x1,x0} == 'B11)?0:1;
    
    // equivalentemente potevamo scrivere
    // assign z = ~(x1 & x0);
    // assign z = ~&{x1, x0};
endmodule

