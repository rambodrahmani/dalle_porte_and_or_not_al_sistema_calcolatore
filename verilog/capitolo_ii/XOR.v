/**
 * File:    XOR.v
 *          EXOR (EXclusive OR) e' una porta logica che riceve in ingresso "n"
 *          valori e restituisce "1" in uscita se, e solo se, vi e' almeno un
 *          ingresso che differisce dagli altri.
 *
 *          Segue la tavola di verita' di una porta XOR a "n=2" ingressi:
 *
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |  A+B   |
 *          |------|-----|--------|
 *          |   0  |  0  |   0    |
 *          |   0  |  1  |   1    |
 *          |   1  |  0  |   1    |
 *          |   1  |  1  |   0    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 */

module XOR(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = x1 ^ x0;
endmodule

