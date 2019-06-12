/**
 * File:    XNOR.v
 *          EXNOR (EXclusive NOR) e' una porta logica che riceve in ingresso "n"
 *          valori e restituisce "1" in uscita se, e solo se, tutti gli ingressi
 *          hanno il medesimo valore logico. In breve, e' equivalente alla
 *          negazione della porta EXOR (eXclusive OR).
 *
 *          Segue la tavola di verita' di una porta EXNOR a "n=2" ingressi: 
 *          
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |NOT{A^B}|
 *          |------|-----|--------|
 *          |   0  |  0  |   1    |
 *          |   0  |  1  |   0    |
 *          |   1  |  0  |   0    |
 *          |   1  |  1  |   1    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 */

module XNOR(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = ~(x1 ^ x0);
endmodule

