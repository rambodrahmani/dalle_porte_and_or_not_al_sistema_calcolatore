/**
 * File:    Rete_Totale_3.v
 *          La descrizione della Rete_Totale puo' essere fortemente compattata
 *          esplicitando solo le variabili strettamente necessarie per
 *          i collegamenti interni e cioe', nel caso in esame, o l'unica
 *          variabile a_R3 ovvero la coppia di variabili da_R1 e da_R2.
 *          TERZA IMPLEMENTAZIONE.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 16/06/2019.
 */

/*
 * Nel secondo caso, usando la coppia di variabili da_R1 e da_R2 la descrizione
 * della Rete_Totale diventa:
 */
module Rete_Totale_3(z3_z0, x7_x0);
    input   [7:0]   x7_x0;
    output  [3:0]   z3_z0;
    wire    [7:0]   da_R1, da_R2;

    Rete_di_Tipo_A R1(da_R1, x7_x0[7:4], z3_z0[0]),
                   R2(da_R2, x7_x0[3:0], z3_z0[0]);

    Rete_di_Tipo_B R3(z3_z0, {da_R1, da_R2});
endmodule

/**
 * Il tipo di rete Rete_di_Tipo_A e' descritto dal secondo dei costrutti
 * module...endmodule. Una rete di questo tipo ha una variabile di ingresso
 * a quattro bit di nome locale x3_x0, una variabile di ingresso a un bit di
 * nome locale b0 e una variabile di uscita a otto bit di nome locale z7_z0.
 */
module Rete_di_Tipo_A(z7_z0, x3_x0, b0);
    input   [3:0]   x3_x0;
    input           b0;
    output  [7:0]   z7_z0;

    // descrizione della struttura interna delle reti di tale tipo
endmodule

/**
 * Il tipo di rete Rete_di_Tipo_B e' descritto dal terzo dei costrutti
 * module...endmodule. Una rete di questo tipo ha una variabile di ingresso
 * a sedici bit di nome locale x15_x0 e una variabile di uscita a quattro bit
 * di nome locale z3_z0.
 */
module Rete_di_Tipo_B(z3_z0, x15_x0);
    input   [15:0]  x15_x0;
    output  [3:0]   z3_z0;

    // descrizione della struttura interna delle reti di tale tipo
endmodule

