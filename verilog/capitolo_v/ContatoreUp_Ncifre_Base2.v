/**
 *
 * File: ContatoreUp_Ncifre_Base2.v
 *       Un contatore e' una rete sequenziale sincronizzata il cui stato di
 *       uscita puo' essere interpretato come un numero che, all'arrivo di
 *       ogni segnale di sincronizzazione, viene incrementato (contatore up)
 *       o decrementato (contatore dow) ovvero incrementato o decrementato in
 *       dipendenza del valore di un'opportuna variabile di comando (contatore
 *       up/down).
 *       
 *       Le specifiche di un contatore debbono quindi includere la base B in
 *       cui il numero verra' espresso, il numero N delle sue cifre e il suo
 *       tipo (numero naturale o numero intero con o senza virgola). In
 *       quantop segue tratteremo solo i contatori up per numero naturali,
 *       essendo la struttura degli altri tipi di contatore facilmente
 *       deducibile da quella dei contatori up per numeri naturali, almeno per
 *       un lettore che abbia una qualche dimestichezza con l'aritmetica.
 *
 *       Nel caso B = 2 la rete combinatoria per l'addizione e' predefinita in
 *       Verilog e associabile all'operatore +, per cui la descrizione di un
 *       contatore up a N cifre in base 2 diventa la seugnete:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

module ContatoreUp_Ncifre_Base2(numero, clock, reset_);
    parameter N = 10;

    input clock, reset_;
    output [N-1:0] numero;

    reg [N-1:0] OUTR;
    assign numero=OUTR;

    always @(reset_ == 0) #1 OUTR<=0;

    always @(posedge clock) if (reset_ == 1) #3 OUTR <= numero + 1;
endmodule

