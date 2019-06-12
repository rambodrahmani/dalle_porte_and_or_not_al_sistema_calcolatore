/**
 * File: Registro_Multifunzionale.v
 *       Un registro multifunzionale e' una rete sequenziale sincronizzata
 *       che, come conseguenza dell'arrivo di un segnale di sincronizzazione,
 *       memorizza in un registro lo stato di uscita di una fra piu' reti
 *       combinatorie, selezionata dai valori di opportune variabili di
 *       comando.
 *       
 *       Si consideri come esempio un registro da quattro bit e due funzioni,
 *       definite come segue:
 *       1) caricamento parallelo: all'arrivo del segnale di sincronizzazione
 *          nel registro viene memorizzato lo stato della variabile di ingresso.
 *       2) traslazione sinistra: all'arrivo del segnale di sincronizzazione
 *          nel registro viene memorizzato il vecchio contenuto, traslato veriso
 *          sinistra di una posizione e con inserzione del bit 0 nella posizione
 *          meno significativa.
 *          
 *       La funzione di caricamento parallelo viene espletata se, all'arrivo
 *       del segnale di sincronizzazione, la variabile di comando b0 vale 0;
 *       la funzione di traslazione sinistra viene espletata se all'arrivo del
 *       segnale di sincronizzazione, la variabile di comando b0 vale 1.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 */

module Registro_Carica_Parallelo_TraslaSinistro(z3_z0, x3_x0, b0, clock, reset_);
    input clock, reset_;
    input [3:0] x3_x0;
    input b0;
    output [3:0] z3_z0;

    reg [3: 0] OUTR;
    assign z3_z0 <= OUTR;

    always @(reset_ == 0) #1 OUTR <= 'B0000;

    always @(posedge clock) if (reset_ == 1) #3
        casex(b0)
            'B0: OUTR<=x3_x0;
            'B1: OUTR<={OUTR[2:0], 1'B0}    // 1'B0 = 1 bit di valore 0
        endcase
endmodule

