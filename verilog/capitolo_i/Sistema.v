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

/*
 * Il sistema digitale, cioe' la rete globale di nome Sistema, e' descritto
 * dal primo dei tre costrutti module...endmodule. Il fatto che il nome di
 * questa rete globale non sia seguito da un elenco di nomi di variabili
 * indica che essa non ha variabili di ingresso o di uscita. I tre statementi
 * interni al costrutto module...endmodule ci dicono che la rete Sistema
 * contiene al suo interno tre oggetti.
 */
module Sistema;
    // uno degli ogetti e' una variabile binaria di tipo wire (cioe' associata
    // a un filo) e di nome locale w
    wire w;

    // oggetto di tipo Trasmettitore e di nome locale T
    Trasmettitore   T(w);

    // oggetto di tipo Ricevitore e di nome locale R
    Ricevitore      R(x);
endmodule

/**
 * A valle del costrutto module...endmodule che descrive la rete Sistema sono
 * riportati i due costruitti module...endmodule che descrivono le due reti
 * usate come sottoreti. Il primo di questi due costrutti descrive la rete di
 * tipo Trasmettitore; il fatto che il nome Trasmettitore sia seguito dalla
 * specificazione (z) indica che le reti di tale tipo hanno una variabile per
 * le connessioni esterne e che questa variabile e' denotata formalmente z.
 */
module Trasmettitore(z);
    // questo statement ci dice poi che la variabile z e' una variabile di
    // uscita associata a un filo
    output z;

    // descrizione della struttura interna
endmodule

/**
 * Il terzo dei costruitti module...endmodule descrive la rete di tipo
 * Ricevitore; il fatto che il nome Ricevitore sia seguito dalla
 * specificazione (x) indica che le reti di tale tipo hanno una variabile per
 * le connessioni esterne e che questa variabile e' formalmente denotata x.
 */
module Ricevitore(x);
    // questo statement ci dice poi che questa variabile e' una variabile di
    // ingresso associata a un filo
    input x;

    // descrizione della struttura interna
endmodule

