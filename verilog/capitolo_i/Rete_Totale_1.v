/**
 *
 * File:    Rete_Totale_1.v
 *          La seguente descrizione in linguaggio Verilog evidenzia invece
 *          come, in tale linguaggio si possono dichiarare e usare le
 *          variabili a piu' bit (considerare un insieme ordinato di
 *          N variabili a un bit come un'unica variabile a N bit, avente per
 *          componenti le N variabili a un bit). Ogni delle 2^N configurazioni
 *          di bit che le N variabili a un bit possono assumere, costituisce
 *          anche uno dei @^N possibili valori (o stati) della variabile
 *          a N bit.
 *          PRIMA IMPLEMENTAZIONE.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 16/06/2019.
 *
 */

/*
 * La Rete_Totale e' globalmente descritta dal primo dei tre costruitti
 * module...endmodule. Essa ha una variabile di ingresso a otto bit x7_x0
 * e una variabile di uscita a quattro bit z3_z0. Le variabili per il
 * collegamento delle sottoreti interne sono in parte a quattro bit (variabili
 * a_R1, a_R2 e da_R3), in parte a otto bit (variabili da_R1 e da_R2), in
 * parte a sedici bit (variabile a_R3) e in parte a un bit (variabile
 * a_R1_e_R2).
 * 
 * Questa implementazione e' volutamente espansiva per facilitarne la
 * comprensione. Verranno fornite altre due versioni alternative cpattate.
 */
module Rete_Totale_1(z3_z0, x7_x0);
    input   [7:0]   x7_x0;
    output  [3:0]   z3_z0;
    wire    [3:0]   a_R1, a_R2;
    wire    [7:0]   da_R1, da_R2;
    wire    [15:0]  a_R3;
    wire    [3:0]   da_R3;
    wire            a_R1_e_R2;

    // gli statement contenenti la parola chiave assign (li troveremo
    // frequentemente) sono detti assegnamenti continui; ciascuno di essi ha,
    // in generale, un formato del tipo variabile=espressione e indica il
    // continuo adeguamento del valore della variabile a sinistra del simbolo
    // = al valore che assume l'espressione a destra di tale simbolo
    assign a_R1 = x7_x0[7:4];
    assign a_R2 = x7_x0[3:0];
    assign a_R3 = {da_R1, da_R2};
    assign a_R1_e_R2 = da_R3[0];
    assign z3_z0 = da_R3;

    Rete_di_Tipo_A R1(da_R1, a_R1, a_R1_e_R2),
                   R2(da_R2, a_R2, A_R1_e_R2);

    Rete_di_Tipo_B R3(da_R3, a_R3);
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

