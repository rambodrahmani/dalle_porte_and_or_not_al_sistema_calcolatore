/**
 * File:    Rete_Combinatoria.v
 *          Consideriamo una rete combinatoria con la seguente tabella di
 *          verita':
 *          
 *          |------------------------|
 *          |    INPUT     |  OUTPUT |
 *          |------------------------|
 *          | x2 | x1 | x0 | z1 | z0 |
 *          |----|----|----|----|----|
 *          | 0  | 0  | 0  | 0  | 0  |
 *          | 0  | 0  | 1  | 0  | 1  |
 *          | 0  | 1  | 1  | 1  | 0  |
 *          | 0  | 1  | 0  | 1  | 0  |
 *          | 1  | 0  | 0  | 1  | 1  |
 *          | 1  | 0  | 1  | 1  | 1  |
 *          | 1  | 1  | 1  | 0  | 0  |
 *          | 1  | 1  | 0  | 0  | 0  |
 *          |------------------------|
 *
 *          Vediamo dapprima alcuni metodi per inserire il concetto di tabella
 *          di verita' nello schema di descrizione in liguaggio Verilog delle
 *          reti combinatorie.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 */

module Rete_Combinatoria(x2, x1, x0, z1, z0);
    input x2, x1, x0;
    output z1, z0;

    // Un primo metodo e' quello di fare un uso reiterato delle espressioni
    // condizionali nello statement assign, riportando di fatto all'interno di
    // esso la tabella di verita':
    assign #20 {z1, z0} = ({x2, x1, x0}=='B000)?'B00:
                          ({x2, x1, x0}=='B001)?'B01:
                          ({x2, x1, x0}=='B011)?'B10:
                          ({x2, x1, x0}=='B010)?'B10:
                          ({x2, x1, x0}=='B100)?'B11:
                          ({x2, x1, x0}=='B101)?'B11:
                          ({x2, x1, x0}=='B111)?'B00:
                          ({x2, x1, x0}=='B110)?'B00:
                                                'B00;

    // Si puo' anche dare una formalizzazione piu' compatta, ricorrendo
    // (implicitamente) al concetto di "in tutti gli altri casi" e riscrivendo
    // il precedente statement assign nella seguente forma:
    assign #20 {z1, z0} = ({x2, x1, x0}=='B001)?'B01:
                          ({x2, x1, x0}=='B011)?'B10:
                          ({x2, x1, x0}=='B010)?'B10:
                          ({x2, x1, x0}=='B100)?'B11:
                          ({x2, x1, x0}=='B101)?'B11:
                          /*default*/           'B00;

    // Volendo compattare ulteriormente, si puo' ricorrere al concetto di
    // "quale che sia il valore di una variabile di ingresso" e si puo'
    // scrivere il precedente statement assign nella forma
    assign #20 {z1, z0} = ({x2, x1, x0}=='B001)?'B01:
                          ({x2, x1    }=='B01 )?'B10:
                          ({x2, x1    }=='B10 )?'B11:
                          /*default*/           'B00;
endmodule

