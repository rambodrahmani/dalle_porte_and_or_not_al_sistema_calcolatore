/**
 *
 * File: sEP8.v
 *       Esaminiamo adesso in maggior dettaglio il funzionamento del
 *       processore sEP8. Come gia' detto piu' volte, esso preleva dalla
 *       memoria un'istruzione alla volta e quindi la esegue. Per svolgere
 *       questa sua attivita', il processore adopera oltre ai registri
 *       descritti nei paragrafi precedenti (registri visibili al
 *       programmatore) anche un certo numero di registri di appoggio
 *       (registri non visibili al programmatore).
 *       
 *       Piu' in dettaglio, l'evoluzione del processore sEP8 puo' essere
 *       ripartita nelle seguenti tre fasi:
 *       
 *       1) Fase Iniziale. Quando viene messo a 0 il valore della variabile
 *       /reset per il reset iniziale, alcuni registri vengono opportunamente
 *       inizializzati. In particolare:
 *          a) il registro DIR viene azzerato, in modo che la variabile d7_d0
 *          sia in alta impedenza;
 *          b) i registri /MR, /MW, /IOR, /IOW vengono settati per evitare che
 *          la memoria e le interfacce ricevano comandi spuri e quindi
 *          potenzialmente pericolosi;
 *          c) il registro IP viene inizializzato con 'HFF0000 (dove inizia la
 *          ROM nello spazio di memoria) e il registro dei flag F con 'H00,
 *          conformemente alle specifiche date precedentemente;
 *          d) il registro di stato STAR viene inizializzato con la codifica
 *          dello stato interno iniziale della cosiddetta fase di chiamata.
 *          
 *       2) Fase Di Chiamata. In questa fase il processore si procura,
 *       effettuando uno o piu' cicli di lettura in memoria, una nuova
 *       istruzione. Esso utilizza come inidirzzo della prima delle locazioni
 *       cui accedere, il contenuto del registro IP e, dopo ogni ciclo di
 *       lettura, incrementa di 1 il contenuto di detto registro. In tal modo,
 *       alla fine della fase di chiamta, il contenuto del registro IP risulta
 *       incrementato di tante unita' quante sono le locazioni occupate
 *       dall'istruzione letta: risultano cosi' predisposte le condizioni per
 *       il prelievo dell'isutrzione sequenziale successiva. Piu' in
 *       dettaglio, le operazioni che il processore compie nella fase di
 *       chiamata sono le seguenti. Dopo aver effettuato il primo ciclo di
 *       accesso in memoria, verifica se il byte che ha letto concide con il
 *       codice operativo di una delle sue istruzioni. Se la verifica da'
 *       esito negativo il processore si blocca in modo analogo a come fa
 *       quando esegue l'istruzione HLT. Se la verifica da' esito positivo, il
 *       processore immette il byte nel registro OPCODE e passa ad esaminare
 *       il formato dell'istruzione che ha trovato. Se l'istruzione prevede un
 *       operando sorgente a 8 bit, sia esso immediato o allocato in memoria
 *       (formati F2, F4 e F5), allora il processore si procura l'operando
 *       sorgente e lo immette nel registro SOURCE. Se l'istruzione prevede un
 *       operando destinatario allocato in memoria (formati F3 e F6), allora
 *       il processore si procura l'indirizzo dell'operando destinatario e lo
 *       immette nel registro DEST_ADDR. Se l'istruzione prevede un salto o la
 *       chiamata di un sottoprogramma (formato F7), il processore si procura
 *       l'indirizzo di salto e lo immette nel registro DEST_ADDR. Se
 *       l'istruzione e' di formato F0 o di formato F1, il processore, stante
 *       la disomogeneita' e la singolarita' delle istruzioni appartenenti
 *       a tali formati, non compie nella fase di chiamta altre particolari
 *       operazioni. Il processore termina in ogni caso la fase di chiamata
 *       passando nello stato interno iniziale della fase di esecuzione
 *       e dell'istruzione che e' stata letta (e il cui codice operativo e'
 *       conservato nel registro OPCODE).
 *       
 *       3) Fase Di Esecuzione. In questa fase il processore compie le
 *       operazioni specificate dal tipo di istruzione che e' stata letta in
 *       fase di chiamata.
 *       
 *       Il processore e' una rete sequenziale sincronizzata (implementata
 *       generalmente tramite decomposizione in parte operativa e parte
 *       controllo), dotata di 8 porte 3-state che supportano la variabile
 *       bidirezionale d7_d0 e che sono comandate dalla variabile di uscita
 *       del registro DIR. Il contenuto di tale registro e' normalmente 0,
 *       cosicche' la variabile d7_d0 funge normalmente da variabile di
 *       ingresso; durante i cicli di scrittura (nello spazio di memoria o di
 *       I/O) il registro DIR contiene invece 1, cosicche' la variabile d7_d0
 *       e' variabile di uscita e il suo stato coincide con il contenuto del
 *       registro D7_D0. Il registro A23_A0 supporta invece la variabile per
 *       gli indirizzi a23_a0.
 *       
 *       Il processore e' descrivibile in Verilog, a livello di linguaggio di
 *       trasferimento tra registri, come riportato di seguito.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/06/2019.
 *
 */

//------------------------------------------------------------------------------
//  DESCRIZIONE COMPLETA DEL PROCESSORE sEP8
//------------------------------------------------------------------------------
module sEP8(d7_d0, a23_a0, mr_, mw_, ior_, iow_, clock, reset_);
    input           clock, reset_;
    input   [7:0]   d7_d0;
    output  [23:0]  a23_a0;
    output          mr_, mw_;
    output          ior_, iow_;

    // REGISTRI OPERATIVI DI SUPPORTO ALLE VARIABILI DI USCITA E ALLE
    // VARIABILI BIDIREZIONALI E CONNESSIONE DELLE VARIABILI AI REGISTRI
    reg         DIR;
    reg [7:0]   D7_D0;
    reg [23:0]  A23_A0;
    reg         MR_, MW_, IOR_, IOW_;
    assign      mr_ = MR_;
    assign      mw_ = MW_;
    assign      ior_ = IOR_;
    assign      iow_ = IOW_;
    assign      a23_a0 = A23_A0;
    assign      d7_d0 = (DIR == 1)?D7_D0:'HZZ;

    // REGISTRI OPERATIVI INTERNI
    reg [2:0]   NUMLOC;     // [0]
    reg [7:0]   AL, AH, F, OPCODE, SOURCE, APP3, APP2, APP1, APP0;
    reg [23:0]  DP, IP, SP, DEST_ADDR;

    // REGISTRO DI STATO, REGISTRO MJR E CODIFICA DEGLI STATI INTERNI
    reg [6:0]   STAR, MJR;
    parameter fetch0=0,
                ...
              write11=85;

    // RETI COMBINATORIE NON STANDARD
    // Il processore contiene al suo interno cinque reti combinatorie non
    // standard, e cioe' le cinque reti valid_fetch(),
    // first_execution_state(), jmp_condition(), alu_result() e alu_flag(), di
    // cui viene data di seguito una breve descrizione.
    // La rete combinatoria valid_fetch() riceve in ingresso il nyte che viene
    // messo nel registro OPCODE; se tale byte coincide con il codice
    // operativo di una istruzione valida, allora la rete fornisce in uscita
    // 1 altrimenti 0.
    function valid_fetch;
        input [7:0] opcode;
        // ...
        // ...
    endfunction

    // La rete combinatoria first_execution_state() riceve in ingresso il byte
    // contenuto nel registro OPCODE e fornisce in uscita la codifica dello
    // stato interno corrispondente al primo degli statement che descrivono la
    // fase di esecuzione di quella istruzione.
    function first_execution_state;
        input [7:0] opcode;
    endfunction

    // La rete combinatoria jmp_condition() riceve in ingresso il contenuto
    // del registro OPCODE e il contenuto del registro dei flag F e fornisce
    // in uscita 1 se:
    //  1) il registro OPCODE contiene il primo byte di un'istruzione di salto
    //     incondizionato;
    //  2) il regostro OPCODE contiene il primo byte di un'istruzione di salto
    //     condizionato e, contestualmente, la condizione di salto codificata in
    //     detto byte e' verificata dal contenuto del registro F.
    function jmp_condition;
        input [7:0] opcode;
        input [7:0] flag;
        // ...
        // ...
    endfunction

    // La rete combinatoria alu_result() compie le operazioni previste nelle
    // istruzioni logico/aritmetiche. Piu' precisamente essa riceve in
    // ingresso il contenuto del registro OPCODE, l'operando sorgente
    // e l'operando destinatario e fornisce in uscita un byte che rappresenta
    // il risultato dell'operazione specificata dal registro OPCODE
    // e compiuta, in generale, si entrambi gli operandi (qualora il registro
    // OPCODE contenga il codice operativo dell'istruzione NOT o delle
    // istruzioni di Shift, l'operando sorgente viene ignorato e la rete
    // compie le operazioni sul solo operando destinatario).
    function [7:0] alu_result;
        input [7:0] opcode, operando1, operando2;
        // ...
        // ...
    endfunction

    // 
    function [3:0] alu_flag;
        input [7:0] opcode, operando1, operando2;
        // ...
        // ...
    endfunction
endmodule

// [0]
// Il registro NUMLOC viene usato nei sottoprogrammi di lettura e scrittura in
// memoria che permettono l'accesso a locazioni multiple cosecutive.

// [1]
