/**
 *
 * File:    Sistema.vl
 *          Consideriamo un sistema dove un modulo Trasmettitore T invia
 *          informazioni a un modulo Ricevitore R, variando la tensione su un
 *          filo di collegamento w. Supponiamo inoltre che accada quanto
 *          segue: se la tensione che il Trasmettitore applica al filo di
 *          collegamento e' nella fascia 0 - 0,8 V, l'operatore interno al
 *          Ricevitore giudica la lampada spenta; se la tensione e' invece
 *          nella fascia 2 - 5 V, l'operatore giudica la lampada accesa; se
 *          invece la tensione e' nella fascia 0,8 - 2 V, si crea una
 *          situazione di ambiguita' e l'operatore puo' giudicare la lampada
 *          a volte accesa e a volte spenta. In quest'ottica possiamo anche
 *          dire che il Trasmettitore e il Ricevitore sono dispositivi che
 *          gestiscono informazioni codificate sotto forma di opportune
 *          configurazioni di bit e che rientrano nella famiglia delle reti
 *          logiche. Rimanendo ancora in quest'ottica, possiamo inoltre dire
 *          che la variabile w e' una variabile di uscita della rete logica
 *          Trasmettitore, e variabile di ingresso della rete logica
 *          Ricevitore e variabile di collegamento delle due reti. Sempre in
 *          quest'ottica, potremo dire che l'intero Sistema e' una rete logica
 *          costituita da piu' reti logiche interconnesse, ovvero che e' un
 *          sistema digitale.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 16/06/2019.
 */
module Sistema;
    wire w;
    Trasmettitore   T(w);
    Ricevitore      R(x);
endmodule

module Trasmettitore(z);
    output z;
    // internal description
endmodule

module Ricevitore(x);
    input x;
    // internal description
endmodule

