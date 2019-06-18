/**
 * File: Controllore_Interruzioni.v
 *       Come gia' accennato, in un qualunque calcolatore sono presenti piu'
 *       sorgenti di interruzione esterne, per cui l'unica sorgente
 *       equivalente che il processore e' in grado di gestire e' ottenuta
 *       interponendo, fra le sorgenti e il processore, un'unita' di raccordo
 *       nota come controllore delle interruzioni.
 *
 *       Il compito del controllore consiste nell'associare un tipo ad ogni
 *       sorgente di interruzioni, nell raccogliere le richieste che
 *       provengono dalle varie sorgenti, nel sequenzializzare le richieste su
 *       base prioritaria e nel presentarle una alla volta al processore, 
 *       unitamente al loro tipo.
 *
 *       Le sorgenti di interruzioni si limitano a inviare le richieste al
 *       controllore senza ricevere indietro alcun segnale di risposta che
 *       indichi loro se una richiesta e' stata accettata e quindi se un'altra
 *       richiesta puo' essere inviata. A questa mancanza di handshake
 *       hardware, si supplisce con un handshake hardware/software, che deve
 *       essere consistente con le seguenti definizioni e procedure.
 *       
 *       Noi definiamo sorgente di interruzioni esterne una qualunque unita'
 *       che sia dotata di una variabile di uscita ir e di un registro OK
 *       e che operi in accordo alle seguenti specifiche. Partendo da una
 *       condizione iniziale in cui ir e' a 0, la sorgente mette ir a 1 quando
 *       nella sorgente stessa nasce l'esigenza di inviare al processore una
 *       richiesta di interruzione. Il registro OK e' atto a dar corpo a una
 *       porta dello spazio di I/O e, un accesso del processore (che avviene
 *       durante l'esecuzione di una istruzione IN o OUT) a tale registro OK
 *       ha l'effetto di informare la sorgente che la richiesta di
 *       interruzione e' stata accolta e che la variabile ir va riportata a 0.
 *       Pertanto l'istruzione IN o OUT, eseguendo la quale il processore
 *       accede al registro OK, deve essere inserita nel sottoprogramma di
 *       servizio dell'interruzione stessa.
 *       
 *       Il controllore delle interruzioni che noi esamineremo si ispira,
 *       anche se solo in minima parte, ai controllori INTEL 8259 e 82093.
 *       Esso e' in grado di gestire 16 sorgenti di interruzioni, dalle quali
 *       riceve le richieste tramite le variabili di ingresso ir0, ir1, ...,
 *       ir15. L'Handshake con il processore avviene tramite le due variabili
 *       intr e inta ampiamente descritte in precedeneza; il tipo viene
 *       inviato tramite la variabile a 8 bit d7_d0, collegata al bus dati.
 *       
 *       Il controllo contiene 16 registri da 8 bit detti Type Registers
 *       nominati TR0, TR1, ..., TR15, mediante i quali da' corpo a 16 porte
 *       dello spazio di I/O, accessibili in sola scrittura. Il controllore
 *       possiede quindi anche le variabili /s e /iow e a3_a0. Questi registri
 *       sono utilizzati utilizzati dal controllore per associare un tipo
 *       a ciascuna delle sorgenti di interruzione. La legge di associazione
 *       e' la seguente: alla sorgente connessa al controllore tramite la
 *       k'esima delle variabili ir0, ir1, ..., ir15, il controllore assegna
 *       come tipo il contenuto del registro TR[k].
 *       
 *       Le richieste di interruzione che giungono al controllore, vengono
 *       continuamente memorizzare in un registro interno IPR (Interrupt
 *       Pending Request) inaccessibile al processore. In presenza di una
 *       o piu' richieste di interruzione memorizzate nel registro IPR, il
 *       controllore invia, settando intr, una richiesta di interruzione al
 *       processore e attendo che il processore comunichi, settando inta, di
 *       aver a sua volta accettato tale richiesta. A questo punto il
 *       controllore seleziona (in accordo a suoi criteri interi) una delle
 *       richieste di interruzione memorizzate nel registro IPR ed emette,
 *       tramite la variabile d7_d0 il tipo ad essa associato. Dopo di cio'
 *       resetta intr, rimuove dal registr IPR la richiesta di interruzione
 *       selezionata e attende che il processore comunichi, resettando a sua
 *       volta inta, di aver prelevato il tipo.
 *       
 *       Un insieme di latch aventi l'ingresso s connesso alle variabili di
 *       ingresso ir0, ..., ir15, emula il registro IPR. In tal modo, ogni
 *       volta che la k-esima sorgente invia una richiesta di interruzione (un
 *       impulso P+), il k-esimo latch SR si setta memorizzando cosi' la
 *       richiesta stessa.
 *       
 *       Il registro INDEX e' utilizzato invece per memorizzare il numero
 *       d'ordine della variabile di ingresso tramite cui e' pervenuta la
 *       richiesta a piu' alta priorita' fra quelle memorizzare nel registro
 *       IPR. In accordo a una tradizione consolidata, il controllore assegna
 *       la massima priorita' alla richiesta che sia pervenuta tramite la
 *       variabile ir0 e priorita' via via decrescenti alle altre richieste,
 *       con priorita' minima assegnata alla richiesta che sia pervenuta
 *       tramite la varaibile ir15. Questa strategia e' implementata tramite
 *       la rete combinatoria priority(...).
 *       
 *       La rimozione dal registro IPR della richiesta di interruzione
 *       selezionata, avviene tramite il registro a 16 bit REMOVE_REQ nel
 *       quale viene messo a 1, grazie alla codifica operata dalla rete
 *       combinatoria decode(...), l'elemento la cui variabile di uscita
 *       costituisce la variabile di ingresso per il reset del latch SR che ha
 *       memorizzato detta richiesta. Il tipo viene emesso dal controllore,
 *       tramite la varaibile d7_d0, per tutto il tempo in cui il processore
 *       tiene settata la variabile inta.
 *       
 *       La sottorete sequenziale sincronizzata interna al controllore puo'
 *       essere descritta, a livello di linguaggio di trasferimento tra
 *       registri, come segue:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 18/06/2019.
 */

module Controllore_Interruzioni(intr, inta, ipr15_ipr0, index, remove_req,
                                clock, reset);
    input   clock, reset_;
    input           inta;
    output          intr;
    input   [15:0]  ipr15_ipr0;
    output  [3:0]   index;
    output  [15:0]  remove_req;
    
    reg             INTR;
    assign intr = INTR;
    
    reg     [3:0]   INDEX;
    assign index = INDEX;

    reg     [15:0]  REMOVE_REQ;
    assign remove_req = REMOVE_REQ;
    
    reg     [1:0]   STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, WS = 3;

    always @(reset_ == 0) #1 begin
        INTR <= 0;
        REMOVE_REQ <= 'HFFFF;
        STAR <= WS;
    end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            WS: begin           // Stato di wait per un reset sicuro di IPR
                STAR <= S0;
            end
            S0: begin
                REMOVE_REQ <= 'H0000;
                INTR <= (ipr15_ipr0 == 'H0000)? 0:1;  // Controlla la presenza
                                                      // di richieste di interruzione
                                                      // da parte delle sorgenti
                INDEX <= priority(ipr15_ipr0);
                STAR <= (inta == 0)? S0:S1;
            end
            S1: begin
                INTR <= 0;
                REMOVE_REQ <= decode(INDEX);
                STAR <= S2;
            end
            S2: begin
                REMOVE_REQ <= 'H0000;
                STAR <= (inta == 1)? S2:S0;
            end
        endcase
    
    function [3:0] priority;
        input [15:0] ipr15_ipr0;
        casex(ipr15_ipr0)
            'B???????????????1 : priority = 'B0000;
            'B??????????????10 : priority = 'B0001;
            'B?????????????100 : priority = 'B0010;
            'B????????????1000 : priority = 'B0011;
            'B???????????10000 : priority = 'B0100;
            'B??????????100000 : priority = 'B0101;
            'B?????????1000000 : priority = 'B0110;
            'B????????10000000 : priority = 'B0111;
            'B???????100000000 : priority = 'B1000;
            'B??????1000000000 : priority = 'B1001;
            'B?????10000000000 : priority = 'B1010;
            'B????100000000000 : priority = 'B1011;
            'B???1000000000000 : priority = 'B1100;
            'B??10000000000000 : priority = 'B1101;
            'B?100000000000000 : priority = 'B1110;
            'B1000000000000000 : priority = 'B1111;
            'B0000000000000000 : priority = 'BXXXX;
        endcase
    endfunction

    function [15:0] decode;
        input [3:0] index;
        casex(index)
            'B0000 : decode = 'B0000000000000001;
            'B0001 : decode = 'B0000000000000010;
            'B0010 : decode = 'B0000000000000100;
            'B0011 : decode = 'B0000000000001000;
            'B0100 : decode = 'B0000000000010000;
            'B0101 : decode = 'B0000000000100000;
            'B0110 : decode = 'B0000000001000000;
            'B0111 : decode = 'B0000000010000000;
            'B1000 : decode = 'B0000000100000000;
            'B1001 : decode = 'B0000001000000000;
            'B1010 : decode = 'B0000010000000000;
            'B1011 : decode = 'B0000100000000000;
            'B1100 : decode = 'B0001000000000000;
            'B1101 : decode = 'B0010000000000000;
            'B1110 : decode = 'B0100000000000000;
            'B1111 : decode = 'B1000000000000000;
        endcase
    endfunction
endmodule

