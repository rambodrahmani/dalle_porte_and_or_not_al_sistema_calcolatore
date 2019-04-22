/**
 *
 * File:    AND.v
 *          AND e' una porta logica che riceve in ingresso almeno due valori e
 *          restituisce 1 solo se tutti i valori di ingresso hanno valore 1.
 *          Viene chiamata in italiano "porta di necessita'" perche' appunto
 *          NECESSITA che i valori in entrata siano uguali affinche' il valore
 *          d'uscita sia verificato. Il valore uscente si puo' trovare tramite
 *          la formula Y = A*B in cui Y e' l'output, con tre input Y = A*B*C e
 *          cosi' via.
 *
 *          Segue la tavola di verità:
 *
 *          |------------|--------|
 *          |   INPUT    | OUTPUT |
 *          |------------|--------|
 *          |   A  |  B  |  A*B   |
 *          |------|-----|--------|
 *          |   0  |  0  |   0    |
 *          |   0  |  1  |   0    |
 *          |   1  |  0  |   0    |
 *          |   1  |  1  |   1    |
 *          |------------|--------|
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 18/04/2019.
 *
 */

module AND(x1, x0, z);
    input x1;
    input x0;
    output z;

    assign z = ({x1,x0} == 'B11)?1:0;
    
    // equivalentemente potevamo scrivere
    // assign z = x1 & x0;
    // assign z = &{x1, x0};
endmodule

