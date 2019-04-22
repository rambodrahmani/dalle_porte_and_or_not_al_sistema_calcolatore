/**
 *
 * File:    NOR.v
 *          Al contrario la porta NOR restituisce la negazione di una porta OR e
 *          quindi restituisce 1 solo quando tutti i valori in ingresso sono 0.
 *          
 *          Segue la tabella di verità:
 *
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |NOT{A+B}|
 *          |------|-----|--------|
 *          |   0  |  0  |   1    |
 *          |   0  |  1  |   0    |
 *          |   1  |  0  |   0    |
 *          |   1  |  1  |   0    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 18/06/2019.
 *
 */

module NOR(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = ({x1,x0} == 'B00)?1:0;
    
    // equivalentemente potevamo scrivere
    // assign z = ~(x1 | x0);
    // assign z = ~|{x1, x0};
endmodule

