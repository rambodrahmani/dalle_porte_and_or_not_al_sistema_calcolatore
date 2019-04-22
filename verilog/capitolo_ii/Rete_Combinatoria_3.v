/**
 *
 * File:    Rete_Combinatoria_3.v
 *          In alcuni casi la tabella di verita' di una rete combinatoria puo'
 *          essere non-completamente specificata, cioe' puo' accadere che in
 *          corrispondenza di un qualche stato di ingresso non siano
 *          specificati (in quanto indifferenti per l'utilizzatore della rete)
 *          i valori di una o piu' variabili di uscita.
 *
 *          Nella seguente tabella di verita' non-completamente specificata
 *          relativa ad una rete combinatoria con tre variabili di ingresso
 *          e con due variabili di uscita. In questa tabella, il simbolo
 *          - indica che il valore della corrispondente variabile di uscita
 *          (z1 nel caso attuale) e' non-specificato, e quindi non interessa
 *          se essso sia 0 oppure 1.
 *          
 *          |------------------------|
 *          |    INPUT     |  OUTPUT |
 *          |------------------------|
 *          | x2 | x1 | x0 | z1 | z0 |
 *          |----|----|----|----|----|
 *          | 0  | 0  | 0  | 0  | 0  |
 *          | 0  | 0  | 1  | 0  | 1  |
 *          | 0  | 1  | 1  | 1  | 0  |
 *          | 0  | 1  | 0  | -  | 0  |
 *          | 1  | 0  | 0  | 0  | 1  |
 *          | 1  | 0  | 1  | 0  | 1  |
 *          | 1  | 1  | 1  | 1  | 0  |
 *          | 1  | 1  | 0  | -  | 0  |
 *          |------------------------|
 *
 *          Ovviamente, se la tabella di verita' e' non-completamente
 *          specificata, anche la corrispondente legge F e' non-completamente
 *          specificata. Nella descrizione in linguaggio Verilog di tale
 *          legge, il non-specificato va indicato con il simbolo X (o meglio
 *          'BX).
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 *
 */

module Rete_Combinatoria_3(x2, x1, x0, z1, z0);
    input x2, x1, x0;
    output z1, z0;

    assign {z1, z0} = F(x2, x1, x0);

    function [1:0] F;
        input x2, x1, x0;

        casex({x2, x1, x0})
            'B001   : F='B01;
            'B011   : F='B10;
            'B010   : F='BX0;
            'B111   : F='B11;
            'B110   : F='BX1;
            default : F='B00;
        endcase
    endfunction
endmodule

