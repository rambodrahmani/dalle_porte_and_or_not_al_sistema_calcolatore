/**
 * File: Ram.v
 *       Una memoria RAM (Random Access Memory) static puo' essere vista come
 *       una matrice di D latch contornata da reti logiche combinatorie che
 *       permettono l'accesso contemporaneo a tutti i D latch costituenti una
 *       riga della matrice stessa; l'accesso a una riga puo' consisteere
 *       nella modifica (ciclo di scrittura) o nel prelievo (ciclo di lettura)
 *       dei bit memorizzati nei D latch. Poiche' una memoria RAM static e'
 *       basata sui D latch, deve essere garantito che, quando essi sono in
 *       trasparenza (cioe' durante i cicli di scrittura) il valore delle loro
 *       variabili di ingresso non sia influenzato dal valore delle loro
 *       variabili di uscita. Questa garanzia e' ottenuta dotando la memoria
 *       di un'opportuna barriera di porte 3-state, atte a isolare le
 *       variabili di uscita dei D latch durante i cicli di scrittura.
 *       L'utilizzatore di una memoria RAM statica deve quindi sapere che non
 *       puo' leggervi mentre vi scrivere e viceversa.
 *
 *       Ogni insieme di D latch costituenti una riga della matrice e' detto
 *       locazione ed e' individuato da un numero naturale detto a sua volta
 *       indirizzo della locazione. I bit memorizzati nei D latch costituenti
 *       una locazione sono detti contenuto della locazione e il loro numero
 *       e' detto capacita' della locdazione stessa; ogni operazione di
 *       scrittura, cioe' ogni modifica apportata al contenuto di una
 *       locazione, e' detta anche memorizzazione di una nuova configurazione
 *       di bit nella locazione.
 *       
 *       Le memorie sono provviste di un opportuno numero di variabili di
 *       ingresso bidirezionali; la funzione delle variabili di ingresso
 *       e bidirezionali e' dettagliata di seguito (ed e' generalizzbile al
 *       caso di memorie di ogni dimensione);
 *          1. variabile di ingresso per la selezione s_ (select), variabile
 *             di ingresso per il comando di scrittura mw_ (memory write)
 *             e variabile di ingresso per il comando di lettura mr_ (memory
 *             read): lo stato di queste variabili, tutte attive basse,
 *             specifica, in accordo alla tabellla che segue, le azioni che la
 *             memoria e' chiamata a compiere:
 *             
 *                  s_  mr_  mw_
 *                  1   -    -   : nessuna azione;
 *                  0   1    1   : nessuna azione;
 *                  0   0    1   : azioni consistenti con un ciclo di lettura;
 *                  0   1    0   : azioni consistenti con un ciclo di scrittura;
 *                  0   0    0   : azioni non definite.
 *          
 *          2. variabile di ingresso a 23 bit per gli indirizzi a22_a0
 *             (address): lo stato di questa variabile e' interpretato,
 *             durante il ciclo di lettura o di scrittura, come l'indirizzo
 *             della locazione di memoria coinvolta nel ciclo stesso;
 *
 *          3. variabile bidirezionale a 4 bit per i dati d3_d0 (data): questa
 *          variabile funge, durante i cicli di scrittura, da variabile di
 *          ingresso e il suo stato e' cosniderato dalla memoria come la nuova
 *          combinazione di bit da memorizzare nella locazione indirizzata;
 *          durante i cicli di lettura essa funge invece da variabile di
 *          uscita e il suo stato coincide con il contenuto della locazione
 *          indirizzata; in tutti gli altri casi e' tenuta in alta impedenza.
 *          
 *          Una possibile descrizione in linguaggio Verilog di una memoria RAM
 *          da 8Mx4bit (8 M locazioni con capacita' di 4 bit ciascuna) e' la
 *          seguente:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 22/05/2019.
 */

module Ram(d3_d0, a22_a0, s_, mr_, mw_);
    input [22:0] a22_a0;
    input s_, mr_, mw_;

    inout [3:0] d3_d0;
    reg [3:0] LOCATION[0:8388607];  // [0]

    // ricordiamo che s_, mr_, mw_ sono tutte e tre attive basse

    wire b;
    assign b = ({s_, mr_, mw_} == 'B001)?1:0;   // ciclo di lettura b = 1

    wire c;
    assign c = ({s_, mr_, mw_} == 'B010)?1:0;   // ciclo di scrittura c = 1

    // ciclo di lettura
    assign d3_d0 = (b == 1)? LOCATION[a22_a0]:'HZ;

    // ciclo di scrittura   [1]
    always @(c or d3_d0)
        LOCATION[a22_a0] <= (c == 1) ? d3_d0 : LOCATION[a22_a0];
endmodule

// [0]
// La notazione LOCATION[0:8388607] descrive un array di 8M = 8388607
// elementi, corredato dei multiplexer e dei demultiplexer per accedere
// a ognuno di essi; il j-esimo elemento dell'array ha nome LOCATION[j], dove
// j puo' essere una qualunque espressione. Il fatto che la dichiarazione
// dell'array inizi con reg [3:0] descrive il fatto che ogni elementi e' di
// tipo reg e ha 4 bit.

// [1]
// Il modo in cui nello statement always e' descritto l'accesso agli elementi
// dell'array implica che ogni elemento e' costituito da D latch ai quali non
// viene imposto di memorizzare particolari bit al reset iniziale. Ogni
// elemento dell'array e' pertanto atto a rappresentare una delle locazioni
// della RAM. Globalmente l'array, le variabili b e c e gli statement assign
// e always formalizzano in maniera precisa la struttura della RAM 8Mx4 bit.

