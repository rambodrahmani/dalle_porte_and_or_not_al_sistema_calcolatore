/**
 *
 * File:    OR.v
 *          OR e' una porta logica che riceve in ingresso almeno 2 valori e
 *          restituisce 1 se almeno un valore di ingresso ha valore 1. Viene
 *          chiamata in italiano "porta di sufficienza" perche' appunto e'
 *          SUFFICIENTE che almeno uno dei [due o piu'] valori in entrata sia
 *          verificato affinche' il valore in uscita sia vero.
 *          
 *          Segue la tabella di verità:
 *
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |  A+B   |
 *          |------|-----|--------|
 *          |   0  |  0  |   0    |
 *          |   0  |  1  |   1    |
 *          |   1  |  0  |   1    |
 *          |   1  |  1  |   1    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 18/06/2019.
 *
 */

module OR(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = ({x1,x0} == 'B00)?0:1;
    
    // equivalentemente potevamo scrivere
    // assign z = x1 | x0;
    // assign z = |{x1, x0};
endmodule

