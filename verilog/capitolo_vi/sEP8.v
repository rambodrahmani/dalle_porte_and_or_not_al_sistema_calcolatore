/**
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
              fetch1=1,
              fetch2=2,
              fetchF2_0=3,
              fetchF2_1=4,
              fetchF3_0=5,
              fetchF4_0=6,
              fetchF4_1=7,
              fetchF5_0=8,
              fetchF5_1=9,
              fetchF5_2=10,
              fetchF6_0=11,
              fetchF6_1=12,
              fetchF7_0=13,
              fetchF7_1=14,
              fetchEnd=15,
              fetchEnd1=16,
              nop=17,
              hlt=18,
              ALtoAH=19,
              AHtoAL=20,
              incDP=21,
              ldAL=22,
              ldAH=23,
              storeAL=24,
              storeAH=25,
              ldSP=26,
              ldSP1=27,
              ldimmDP=28,
              ldimmDP1=29,
              lddirDP=30,
              lddirDP1=31,
              lddirDP2=32,
              storeDP=33,
              storeDP1=34,
              in=35,
              in1=36,
              in2=37,
              in3=38,
              out=39,
              out1=40,
              out2=41,
              out3=42,
              out4=43,
              aluAL=44,
              aluAH=45,
              jmp=46,
              pushAL=47,
              pushAH=48,
              pushDP=49,
              popAL=50,
              popAL1=51,
              popAH=52,
              popAH1=53,
              popDP=54,
              popDP1=55,
              call=56,
              call1=57,
              ret=58,
              ret1=59,
              nvi=60,
              readB=61,
              readW=62,
              readM=63,
              readL=64,
              read0=65,
              read1=66,
              read2=67,
              read3=68,
              read4=69,
              writeB=70,
              writeW=71,
              writeM=72,
              writeL=73,
              write0=74,
              write1=75,
              write2=76,
              write3=77,
              write4=78,
              write5=79,
              write6=80,
              write7=81,
              write8=82,
              write9=83,
              write10=84,
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
        valid_fetch = 0;
        casex(opcode[7:5])
            'B000:          // FORMATO F0
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
                    'B00111: valid_fetch = 1;
                    'B01000: valid_fetch = 1;
                    'B01001: valid_fetch = 1;
                    'B01010: valid_fetch = 1;
                    'B01011: valid_fetch = 1;
                    'B01111: valid_fetch = 1;
                    'B10000: valid_fetch = 1;
                    'B10001: valid_fetch = 1;
                endcase
            'B001:          // FORMATO F1
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                endcase
            'B010:          // FORMATO F2
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
                    'B00111: valid_fetch = 1;
                    'B01000: valid_fetch = 1;
                    'B01001: valid_fetch = 1;
                    'B01010: valid_fetch = 1;
                    'B01011: valid_fetch = 1;
                endcase
            'B011:          // FORMATO F3
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                endcase
            'B100:          // FORMATO F4
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
                    'B00111: valid_fetch = 1;
                    'B01000: valid_fetch = 1;
                    'B01001: valid_fetch = 1;
                    'B01010: valid_fetch = 1;
                    'B01011: valid_fetch = 1;
                endcase
            'B101:          // FORMATO F5
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
                    'B00111: valid_fetch = 1;
                    'B01000: valid_fetch = 1;
                    'B01001: valid_fetch = 1;
                    'B01010: valid_fetch = 1;
                    'B01011: valid_fetch = 1;
                endcase
            'B110:          // FORMATO F6
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                endcase
            'B111:          // FORMATO F7
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
                    'B00111: valid_fetch = 1;
                    'B01000: valid_fetch = 1;
                    'B01001: valid_fetch = 1;
                    'B01010: valid_fetch = 1;
                    'B01011: valid_fetch = 1;
                endcase
        endcase
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

    // La rete combinatoria alu_flag() opera in parallelo alla rete precedente
    // e fornisce in uscita il valore dei flag OF, SF, ZF e CF, cosi' come
    // richiesti nelle istruzioni logico/aritmetiche. 
    function [3:0] alu_flag;
        input [7:0] opcode, operando1, operando2;
        // ...
        // ...
    endfunction

    // ALTRI MNEMONICI
    parameter [2:0] F0 = 'B000, F1 = 'B001, F2 = 'B010, F3 = 'B011,
                    F4 = 'B100, F5 = 'B101, F6 = 'B110, F7 = 'B111;

    //--------------------------------------------------------------------------
    //                             INITIAL RESET
    always @(reset_ == 0) #1
        begin
            IP <= 'HFF0000;
            F <= 'H00;
            DIR <= 0;
            MR_ <= 1;
            MW_ <= 1;
            IOR_ <= 1;
            IOW_ <= 1;
            STAR <= fetch0;
        end

    //--------------------------------------------------------------------------
    //                      WHEN THE CLOCK SIGNAL ARRIVES
    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            //------------------------------------------------------------------
            //                  FASE DI CHIAMATA
            fetch0:
            begin
                A23_A0<=IP; IP<=IP+1; MJR<=fetch1; STAR<=readB;
            end

            fetch1:
            begin
                OPCODE<=APP0;
                MJR<=(APP0[7:5]==F0)?fetchEnd:
                     (APP0[7:5]==F1)?fetchEnd:
                     (APP0[7:5]==F2)?fetchF2_0:
                     (APP0[7:5]==F3)?fetchF3_0:
                     (APP0[7:5]==F4)?fetchF4_0:
                     (APP0[7:5]==F5)?fetchF5_0:
                     (APP0[7:5]==F6)?fetchF6_0:
                     /* default */   fetchF7_0;
                STAR<=(valid_fetch(APP0)==1)?fetch2:nvi;
            end

            fetch2:
            begin
                STAR<=MJR;
            end

            fetchF2_0:
            begin
            end

            fetchF2_1:
            begin
            end

            fetchF3_0:
            begin
            end

            fetchF4_0:
            begin
            end

            fetchF4_1:
            begin
            end

            fetchF5_0:
            begin
            end

            fetchF5_1:
            begin
            end

            fetchF5_2:
            begin
            end

            fetchF6_0:
            begin
            end

            fetchF6_1:
            begin
            end

            fetchF7_0:
            begin
            end

            fetchF7_1:
            begin
            end

            //------------------------------------------------------------------
            //              TERMINAZIONE DELLA FASE DI CHIAMTA
            //              E PASSAGGIO ALLA FASE DI ESECUZIONE
            fetchEnd:
            fetchEnd1:

            //------------------------------------------------------------------
            //                      FASE DI ESECUZIONE

            //------------ istruzione NOP
            nop:

            //------------ istruzione HLT
            hlt:
            ALtoAH:
            AHtoAL:
            incDP:
            ldAH:
            storeAL:
            storeAH:
            ldSP:
            ldSP1:
            ldimmDP:
            ldimmDP1:
            lddirDP:
            lddirDP1:
            lddirDP2:
            storeDP:
            storeDP1:
            in:
            in1:
            in2:
            in3:
            out:
            out1:
            out2:
            out3:
            out4:
            aluAL:
            aluAH:
            jmp:
            pushAL:
            pushAH:
            pushDP:
            popAL:
            popAL1:
            popAH:
            popAH1:
            popDP:
            popDP1:
            call:
            call1:
            ret:
            ret1:
            nvi:

            //------------------------------------------------------------------
            //          MICROSOTTOPROGRAMMA PER LETTURE IN MEMORIA
            // Le etichette degli stati interni da immettere nel registro STAR
            // per accedere al microsottoprogramma per la lettura in memoria
            // sono readB (lettura di una locazione), readW (lettura di due
            // locazioni), readM (lettura di tre locazioni), readL (lettura di
            // quattro locazioni).
            // Ciascun microsottoprogramma, quando invocato, deve trovare nel
            // registro A23_A0 l'indirizzo della prima (ed eventualmente
            // unica) locazione a cui accedere.
            //
            // Il microsottoprogramma per la lettura in memoria lascia
            //  a) in APP0 il contenuto della prima (ed eventualmente unica)
            //     locazione a cui accede;
            //  b) in APP1 il contenuto della seconda (ed eventualmente
            //     ultima) locazione a cui accede;
            //  c) in APP2 il contenuto della terza (ed eventualmente ultima)
            //     locazione a cui accede;
            //  d) in APP3 il contenuto della quarta locazione a cui
            //     eventualmente accede.
            readB:
            readW:
            readM:
            readL:
            read0:
            read1:
            read2:
            read3:
            read4:

            //------------------------------------------------------------------
            //          MICROSOTTOPROGRAMMA PER SCRITTURE IN MEMORIA
            // Le etichette degli stati interni da immettere nel registro STAR
            // per accedere al microsottoprogramma per la scrittura in memoria
            // sono writeB (scrittura di una locazione), writeW (scrittura di
            // due locazioni), writeM (scrittura di tre locazioni), writeL
            // (scrittura di quattro locazioni).
            // Ciascun microsottoprogramma, quando invocato, deve trovare nel
            // registro A23_A0 l'indirizzo della prima (ed eventualmente
            // unica) locazione a cui accedere.
            //
            // Il microsottoprogramma per la scrittura in memoria immette
            //  a) il contenuto del registro APP0 nella prima (ed
            //     eventualmente unica) locazione a cui accede;
            //  b) il contenuto del registro APP1 nella seconda (ed
            //     eventualmente ultima) locazione a cui accede;
            //  c) il contenuto del registro APP2 nella terza (ed
            //     eventualmente ultima) locazione a cui accede;
            //  d) il contenuto del registro APP3 nella quarta locazione a cui
            //     eventualmente accede.
            writeB:
            writeW:
            writeM:
            writeL:
            write0:
            write1:
            write2:
            write3:
            write4:
            write5:
            write6:
            write7:
            write8:
            write9:
            write10:
            write11:
        endcase
endmodule

// [0]
// Il registro NUMLOC viene usato nei sottoprogrammi di lettura e scrittura in
// memoria che permettono l'accesso a locazioni multiple cosecutive.

// [1]

