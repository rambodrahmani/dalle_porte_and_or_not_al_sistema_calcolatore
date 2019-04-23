/**
 *
 * File:    Rete_Combinatoria_5.v
 *          Esempio di rete combinatoria con quattro variabili di ingresso x3,
 *          x2, x1, x0 e una variabile di uscita z, usata per dimostrare
 *          l'utilizzo delle mappe di Kanaugh.
 *          
 *          La mappa di Karnaugh e' un metodo di rappresentazione esatta di
 *          sintesi di reti combinatorie a uno o piu' livelli. Una tale mappa
 *          costituisce una rappresentazione visiva di una funzione booleana in
 *          grado di mettere in evidenza le coppie di mintermini o di maxtermini
 *          a distanza di Hamming unitaria (ovvero di termini che differiscono
 *          per una sola variabile binaria (o booleana)). Poiche' derivano da
 *          una meno intuitiva visione delle funzioni booleane in spazi {0,  }^n
 *          con n numero delle variabili della funzione, le mappe di Karnaugh
 *          risultano applicabili efficacemente solo a funzioni con al piu'
 *          5 - 6 variabili. 
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 23/04/2019.
 *
 */

module Rete_Combinatoria_5(x3, x2, x1, x0, z);
    input x3, x2, x1, x0;
    output z;
    
    assign z = F(x3, x2, x1, x0);

    function F;
        input x3, x2, x1, x0;

        casex({x3, x2, x1, x0})
            'B00??  : F=0;
            'B1?00  : F=0;
            'B1001  : F=0;
            default : F=1;
        endcase
    endfunction
endmodule

