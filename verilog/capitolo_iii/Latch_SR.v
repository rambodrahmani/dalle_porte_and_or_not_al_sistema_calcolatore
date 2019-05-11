/**
 *
 * File:    Latch_SR.v
 *          In elettronica digitale, il latch (letteralmente "serratura",
 *          "chiavistello") e' un circuito elettronico bistabile, caratterizzato
 *          quindi da almeno due stati stabili, in grado di memorizzare un bit
 *          di informazione nei sistemi a logica sequenziale asincrona. Il latch
 *          modifica lo stato logico dell'uscita al variare del segnale di
 *          ingresso, mentre il flip-flop, basato sulla struttura del latch,
 *          cambia lo stato logico dell'uscita solamente quando il segnale di
 *          clock e' nel semiperiodo attivo. Il latch costituisce l'elemento
 *          base di tutti i circuiti sequenziali ma trova anche delle
 *          applicazioni come elemento singolo, ad esempio per eliminare i
 *          rimbalzi dei componenti elettromeccanici come pulsanti, interruttori
 *          e commutatori.
 *          
 *          Il piu' semplice (che permette di forzare uno stato dall'esterno) e'
 *          il latch SR, dove S ed R stanno per Set (imposta) e Reset
 *          (reimposta). Questo tipo di latch e' composto da due porteNAND (NOT
 *          AND) o da due porte NOR (NOT OR) con collegamenti incrociati,
 *          ottenendo rispettivamente la versione attiva bassa e la versione
 *          attiva alta. Il bit immagazzinato e' portato all'uscita q e il suo
 *          complemento all'uscita qN. Nella versione attiva bassa, normalmente
 *          in modalità di immagazzinamento, gli input s e r vengono tenuti a
 *          livello logico alto cosi' che il feedback mantenga gli output q e qN
 *          in uno stato costante. Quando viene abbassato il livello logico
 *          sull'input s (set) l'output q passa ad alto e resta alto anche
 *          quando s torna alto.
 *          Al contrario, quando r (reset) viene abbassato, l'output q diventa
 *          basso e resta basso anche quando r torna alto.Se entrambi s e r
 *          vengono abbassati in concomitanza, l'output del latch e'
 *          indeterminato, quindi questa condizione deve essere evitata. In
 *          maniera duale, nella versione attiva alta, lo stato di memoria si
 *          ottiene quando entrambi gli ingressi sono bassi. La funzione di 
 *          reset avviene quando e' alto l'ingresso r e la funzione set quando
 *          e' alto l'ingresso s.
 *          La condizione da evitare perche' lo stato dell'uscita resti
 *          indeterminato e' quella dei due ingressi entrambi alti.
 *          Tabella della verita' del Latch SR attivo basso:
 *
 *          ------------------------------
 *          S | R | Funzione
 *          ------------------------------
 *          0   0 | Non e' ammesso
 *          0   1 | Set: q = 1 , qN = 0
 *          1   0 | Reset: q = 0 , qN = 1
 *          1   1 | Latch (Memorizzazione)
 *          ------------------------------
 *
 *          Tabella della verita' del Latch SR attivo alto:
 *
 *          ------------------------------
 *          S | R | Funzione
 *          ------------------------------
 *          0   0 | Latch (Memorizzazione)
 *          0   1 | Set: q = 0 , qN = 1
 *          1   0 | Reset: q = 1 , qN = 0
 *          1   1 | Non e' ammesso
 *          ------------------------------
 *          
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 11/05/2019.
 *
 */

module Latch_SR(q, qN, s, r);
    input s, r;
    output q, qN;

    assign #1 q = ~(r|qN);
    assign #1 qN = ~(s|q);
endmodule

