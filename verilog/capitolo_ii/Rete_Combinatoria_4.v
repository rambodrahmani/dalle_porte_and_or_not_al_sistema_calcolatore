/**
 * File:    Rete_Combinatoria_4.v
 *          L'ottimizzazione delle strutture circuitali, ivi inclusa la
 *          sintesi a costo minimo delle reti combinatorie, e' ormai affidata
 *          ad opportuni pacchetti software e quindi uno studio dettagliato di
 *          tali problematiche e' di interesse per quel ristretto gruppo di
 *          progettisti di tali pacchetti. Nonostante cio', ci sono sempre
 *          buoni motivi per studiare almeno le metodologie di base per la
 *          sintesi dei circuiti a due livelli di logica a costo minimo.
 *          
 *          Anzitutto il circuito a due livelli di logica da' sicurezza
 *          psicologica, in quanto puo' essere ottenuto in modo sistematico
 *          e servire quindi come pietra di paragone per realizzazioni
 *          diverse.
 *          
 *          In questo paragrafo sono pertanto accennate alcune metodologie di
 *          sintesi a costo minimo con riferimento al modello implementativo
 *          a due livelli di logica SdP.
 *          
 *          Come esempio consideriamo la seguente rete combinatoria, che ha
 *          quattro variabili di ingresso e una variabile di uscita.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 23/04/2019.
 */

module Rete_Combinatoria_4(x3, x2, x1, x0, z);
    input x3, x2, x1, x0;
    output z;
    
    assign z = F(x3, x2, x1, x0);

    function F;
        input x3, x2, x1, x0;

        casex({x3, x2, x1, x0})
            'B?011  : F=0;
            'B11?0  : F=0;
            default : F=1;
        endcase
    endfunction
endmodule

