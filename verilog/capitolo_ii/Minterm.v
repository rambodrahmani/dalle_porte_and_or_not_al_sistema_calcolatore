/**
 * File:    Minterm.v
 *          Un mintermine e' una funzione booleana che assume il valore 1 (ossia
 *          vero, asserito) in corrispondenza di un'unica configurazione di
 *          variabili d'ingresso (booleane) indipendenti. Le reti combinatorie
 *          che implementano i mintermini sono costruibili con porte NOT
 *          e AND.
 *          
 *          Di seguito l'implementazione dei quattro mintermini di una rete
 *          logica con due ingressi.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 */

module Minterm(x1, x0, z3, z2, z1, z0);
    input x1, x0;
    output z3, z2, z1, z0;

    assign z3 = x1 & x0;
    assign z2 = x1 & ~x0;
    assign z1 = ~x1 & x0;
    assign z0 = ~x1 & ~x0;
endmodule

