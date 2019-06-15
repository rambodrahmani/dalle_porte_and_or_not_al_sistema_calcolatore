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

    //--------------------------------------------------------------------------
    //                    RETI COMBINATORIE NON STANDARD
    // Il processore contiene al suo interno cinque reti combinatorie non
    // standard, e cioe' le cinque reti valid_fetch(),
    // first_execution_state(), jmp_condition(), alu_result() e alu_flag(), di
    // cui viene data di seguito una breve descrizione.

    //--------------------------------------------------------------------------
    //                            VALID_FETCH
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

    //--------------------------------------------------------------------------
    //                          FIRST_EXECUTION_STATE
    // La rete combinatoria first_execution_state() riceve in ingresso il byte
    // contenuto nel registro OPCODE e fornisce in uscita la codifica dello
    // stato interno corrispondente al primo degli statement che descrivono la
    // fase di esecuzione di quella istruzione.
    function first_execution_state;
        input [7:0] opcode;
        casex(opcode)
            // Formato F0
            'B00000000: first_execution_state = hlt;        // HLT
            'B00000001: first_execution_state = nop;        // NOP
            'B00000010: first_execution_state = ALtoAH;     // MOV  AL, AH
            'B00000011: first_execution_state = AHtoAL;     // MOV  AH, AL
            'B00000100: first_execution_state = incDP;      // INC  DP
            'B00000101: first_execution_state = aluAL;      // SHL  AL
            'B00000110: first_execution_state = aluAL;      // SHR  AL
            'B00000111: first_execution_state = aluAL;      // NOT  AL
            'B00001000: first_execution_state = aluAH;      // SHL  AH
            'B00001001: first_execution_state = aluAH;      // SHR  AH
            'B00001010: first_execution_state = aluAH;      // NOT  AH
			'B00001011: first_execution_state = pushAL;     // PUSH AL
            'B00001100: first_execution_state = popAL;      // POP  AL
            'B00001101: first_execution_state = pushAH;     // PUSH AH
            'B00001110: first_execution_state = popAH;      // POP  AH
            'B00001111: first_execution_state = pushDP;     // PUSH DP
            'B00010000: first_execution_state = popDP;      // POP  DP
            'B00010001: first_execution_state = ret;        // RET

            // Formato F1
            'B00100000: first_execution_state = in;         // IN  offset, AL
            'B00100001: first_execution_state = out;        // OUT AL, offset
            'B00100010: first_execution_state = ldimmDP;    // MOV $operando, DP
            'B00100011: first_execution_state = ldSP;       // MOV $operando, SP
            'B00100100: first_execution_state = lddirDP;    // MOV indirizzo, DP
            'B00100101: first_execution_state = storeDP;    // MOV DP, indirizzo

            // Formato F2
            'B01000000: first_execution_state = ldAL;       // MOV (DP), AL
            'B01000001: first_execution_state = aluAL;      // CMP (DP), AL
            'B01000010: first_execution_state = aluAL;      // ADD (DP), AL
            'B01000011: first_execution_state = aluAL;      // SUB (DP), AL
            'B01000100: first_execution_state = aluAL;      // AND (DP), AL
            'B01000101: first_execution_state = aluAL;      // OR  (DP), AL
            'B01000110: first_execution_state = ldAH;       // MOV (DP), AH
            'B01000111: first_execution_state = aluAH;      // CMP (DP), AH
            'B01001000: first_execution_state = aluAH;      // ADD (DP), AH
            'B01001001: first_execution_state = aluAH;      // SUB (DP), AH
            'B01001010: first_execution_state = aluAH;      // AND (DP), AH
            'B01001011: first_execution_state = aluAH;      // OR  (DP), AH

            // Formato F3
            'B01100000: first_execution_state = storeAL;    // MOV AL, (DP)
            'B01100001: first_execution_state = storeAH;    // MOV AH, (DP)

            // Formato F4
            'B10000000: first_execution_state = ldAL;       // MOV $operando, AL
            'B10000001: first_execution_state = aluAH;      // CMP $operando, AL
            'B10000010: first_execution_state = aluAL;      // ADD $operando, AL
            'B10000011: first_execution_state = aluAL;      // SUB $operando, AL
            'B10000100: first_execution_state = aluAL;      // AND $operando, AL
            'B10000101: first_execution_state = aluAL;      // OR  $operando, AL
            'B10000110: first_execution_state = ldAH;       // MOV $operando, AH
            'B10000111: first_execution_state = aluAH;      // CMP $operando, AH
            'B10001000: first_execution_state = aluAH;      // ADD $operando, AH
            'B10001001: first_execution_state = aluAH;      // SUB $operando, AH
            'B10001010: first_execution_state = aluAH;      // AND $operando, AH
            'B10001011: first_execution_state = aluAH;      // OR  $operando, AH

            // Formato F5
			'B10100000: first_execution_state = dlAL;       // MOV indirizzo, AL
            'B10100001: first_execution_state = aluAL;      // CMP indirizzo, AL
            'B10100010: first_execution_state = aluAL;      // ADD indirizzo, AL
            'B10100011: first_execution_state = aluAL;      // SUB indirizzo, AL
            'B10100100: first_execution_state = aluAL;      // AND indirizzo, AL
            'B10100101: first_execution_state = aluAL;      // OR  indirizzo, AL
            'B10100110: first_execution_state = ldAH;       // MOV indirizzo, AH
            'B10100111: first_execution_state = aluAH;      // CMP indirizzo, AH
            'B10101000: first_execution_state = aluAH;      // ADD indirizzo, AH
            'B10101001: first_execution_state = aluAH;      // SUB indirizzo, AH
            'B10101010: first_execution_state = aluAH;      // AND indirizzo, AH
            'B10101011: first_execution_state = aluAH;      // OR  indirizzo, AH

            // Formato F6
            'B11000000: first_execution_state = storeAL;    // MOV AL, indirizzo
            'B11000001: first_execution_state = storeAH;    // MOV AH, indirizzo

            // Formato F7
            'B11100000: first_execution_state = jmp;        // JMP  indirizzo
            'B11100001: first_execution_state = jmp;        // JE   indirizzo
            'B11100010: first_execution_state = jmp;        // JNE  indirizzo
            'B11100011: first_execution_state = jmp;        // JA   indirizzo
            'B11100100: first_execution_state = jmp;        // JAE  indirizzo
            'B11100101: first_execution_state = jmp;        // JB   indirizzo
            'B11100110: first_execution_state = jmp;        // JBE  indirizzo
            'B11100111: first_execution_state = jmp;        // JG   indirizzo
            'B11101000: first_execution_state = jmp;        // JGE  indirizzo
            'B11101001: first_execution_state = jmp;        // JL   indirizzo
            'B11101010: first_execution_state = jmp;        // JLE  indirizzo
            'B11101011: first_execution_state = jmp;        // JZ   indirizzo
            'B11101100: first_execution_state = jmp;        // JNZ  indirizzo
            'B11101101: first_execution_state = jmp;        // JC   indirizzo
            'B11101110: first_execution_state = jmp;        // JNC  indirizzo
            'B11101111: first_execution_state = jmp;        // JO   indirizzo
            'B11110000: first_execution_state = jmp;        // JNO  indirizzo
            'B11110001: first_execution_state = jmp;        // JS   indirizzo
            'B11110010: first_execution_state = jmp;        // JNS  indirizzo
            'B11110011: first_execution_state = call;       // CALL indirizzo
        endcase
    endfunction

    //--------------------------------------------------------------------------
    //                              JMP_CONDITION
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

    //--------------------------------------------------------------------------
    //                              ALU_RESULT
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

    //--------------------------------------------------------------------------
    //                              ALU_FLAG
    // La rete combinatoria alu_flag() opera in parallelo alla rete precedente
    // e fornisce in uscita il valore dei flag OF, SF, ZF e CF, cosi' come
    // richiesti nelle istruzioni logico/aritmetiche. 
    function [3:0] alu_flag;
        input [7:0] opcode, operando1, operando2;
        // ...
        // ...
    endfunction

    // FORMATI LINGUAGGIO MNEMONICO
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
    //          ALL'ARRIVO DEL SEGNALE DI SINCRONIZZAZIONE DEL CLOCK
    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            //------------------------------------------------------------------
            //                  FASE DI CHIAMATA
            //
            // lettura di un byte all'indirizzo puntato da IP
            fetch0:
            begin
                A23_A0 <= IP;
                IP <= IP + 1;
                MJR <= fetch1;
                STAR <= readB;
            end

            // inserimento in OPCODE del valore letto e verifica dell codice
            // operativo dell'istruzione letta
            fetch1:
            begin
                OPCODE <= APP0;

                MJR <= (APP0[7:5] == F0)? fetchEnd:
                       (APP0[7:5] == F1)? fetchEnd:
                       (APP0[7:5] == F2)? fetchF2_0:
                       (APP0[7:5] == F3)? fetchF3_0:
                       (APP0[7:5] == F4)? fetchF4_0:
                       (APP0[7:5] == F5)? fetchF5_0:
                       (APP0[7:5] == F6)? fetchF6_0:
                       /* default */      fetchF7_0;

                STAR <= (valid_fetch(APP0) == 1)? fetch2:nvi;
            end

            // se l'OPCODE e' validom prosegui con il fetch per quel tipo di
            // formato
            fetch2:
            begin
                STAR <= MJR;
            end

            // Formato F2: Indirizzo dell'operando Sorgente da 1 byte in DP,
            // operando destinatario AL o AH.
            //
            // lettura del byte indirizzato da DP
            fetchF2_0:
            begin
                A23_A0 <= DP;
                MJR <= fetchF2_1;
                STAR <= readB;
            end

            // inserimento del byte letto in SOURCE
            fetchF2_1:
            begin
                SOURCE <= APP0;
                STAR <= fetchEnd;
            end

            // Formato F3: Operando sorgente in AL o AH, indirizzo dell'operando
            // destinatario da 1 byte in DP.
            //
            // inserimento dell'indirizzo dell'operando destinatario in
            // DEST_ADDR
            fetchF3_0:
            begin
                DEST_ADDR <= DP;
                STAR <= fetchEnd;
            end

            // Formato F4: Operando sorgente immediato da 1 byte, operando
            // destinatario in AL o AH.
            //
            // lettura di un byte a partire dall'indirizzo puntato da IP
            fetchF4_0:
            begin
                A23_A0 <= IP;
                IP <= IP + 1;
                MJR <= fetchF4_1;
                STAR <= readB;
            end

            // inserimento del byte letto in SOURCE
            fetchF4_1:
            begin
                SOURCE <= APP0;
                STAR <= fetchEnd;
            end

            // Formato F5: Operando sorgente in memoria, operando destinatario
            // in AL o AH.
            //
            // lettura di 3 locazioni di memoria contigue ciascuna contenente
            // un byte componente l'indirizzo dell'operando sorgente
            fetchF5_0:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= fetchF5_1;
                STAR <= readM;
            end

            // lettura di un byte all'indirizzo composto usando i 3 byte letti
            fetchF5_1:
            begin
                A23_A0 <= {APP2, APP1, APP0};
                MJR <= fetchF5_2;
                STAR <= readB;
            end

            // copia in SOURCE del byte letto
            fetchF5_2:
            begin
                SOURCE <= APP0;
                STAR <= fetchEnd;
            end

            // Formato F6: Operando sorgente in AL o AH, operando destinatario
            // in memoria.
            //
            // lettura di 3 locazioni di memoria contigue ciascuna contenente
            // un byte componente l'indirizzo destinatario
            fetchF6_0:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= fetchF6_1;
                STAR <= readM;
            end

            // copia in DEST_ADDR dell'indirizzo da 24 bit ottenuto dai 3 byte
            // letti precedentemente
            fetchF6_1:
            begin
                DEST_ADDR <= {APP2, APP1, APP0};
                STAR <= fetchEnd;
            end

            // Formato F7: Operando destinatario in memoria.
            //
            // lettura di 3 locazioni di memoria contigue ciascuna contenente
            // un byte componente l'indirizzo destinatario del salto
            fetchF7_0:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= fetchF7_1;
                STAR <= readM;
            end

            // copia in DEST_ADDR dell'indirizzo di salto
            fetchF7_1:
            begin
                DEST_ADDR <= {APP2, APP1, APP0};
                STAR <= fetchEnd;
            end

            //------------------------------------------------------------------
            //              TERMINAZIONE DELLA FASE DI CHIAMTA
            //              E PASSAGGIO ALLA FASE DI ESECUZIONE
            fetchEnd:
            begin
                MJR <= first_execution_state(OPCODE);
                STAR <= fetchEnd1;
            end

            fetchEnd1:
            begin
                STAR <= MJR;
            end

            //------------------------------------------------------------------
            //                      FASE DI ESECUZIONE
            
            //------------------------------------------------------------------
            // istruzione HLT: in the x86 computer architecture, HLT (halt) is
            // an assembly language instruction which halts the central
            // processing unit (CPU) until the next external interrupt is fired.
            // Interrupts are signals sent by hardware devices to the CPU
            // alerting it that an event occurred to which it should react. For
            // example, hardware timers send interrupts to the CPU at regular
            // intervals.
            // The HLT instruction is executed by the operating system when
            // there is no immediate work to be done, and the system enters its
            // idle state.
            hlt:
            begin
                STAR <= hlt;
            end

            //------------------------------------------------------------------
            // istruzione NOP: in computer science, a NOP, no-op, or NOOP
            // (pronounced "no op"; short for no operation) is an assembly
            // language instruction, programming language statement, or computer
            // protocol command that does nothing. 
            nop:
            begin
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione MOV AL, AH
            ALtoAH:
            begin
                AH <= AL;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione MOV AH, AL
            AHtoAL:
            begin
                AL <= AH;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione INC DP
            incDP:
            begin
                DP <= DP + 1;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni MOV (DP), AL
            //            MOV $operando, AL
            //            MOV indirizzo, AL
            ldAL:
            begin
                AL <= SOURCE;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni MOV (DP), AH
            //            MOV $operando, AH
            //            MOV indirizzo, AH
            ldAH:
            begin
                AH <= SOURCE;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni MOV AL, (DP)
            //            MOV AL, indirizzo
            storeAL:
            begin
                A23_A0 <= DEST_ADDR;
                APP0 <= AL;
                MJR <= fetch0;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzioni MOV AH, (DP)
            //            MOV AH, indirizzo
            storeAH:
            begin
                A23_A0 <= DEST_ADDR;
                APP0 <= AH;
                MJR <= fetch0;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzione MOV $operando, SP
            // lettura operando dall'IP
            ldSP:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= ldSP1;
                STAR <= readM;
            end

            // copia dell'operando letto in SP
            ldSP1:
            begin
                SP <= {APP2, APP1, APP0};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione MOV $operando, DP
            // lettura oeprando dall'IP
            ldimmDP:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= ldimmDP1;
                STAR <= readM;
            end

            // copia dell'operando letto in DP
            ldimmDP1:
            begin
                DP <= {APP2, APP1, APP0};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione MOV indirizzo, DP
            //
            // lettura di 3 locazioni di memoria contigue ciascuno contenente
            // uno dei byte componenti l'indirizzo dell'operando sorgente
            lddirDP:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= lddirDP1;
                STAR <= readM;
            end

            // lettura del valore presente all'indirizzo ottenuto dai 3 byte
            // letti
            lddirDP1:
            begin
                A23_A0 <= {APP2, APP1, APP0};
                MJR <= lddirDP2;
                STAR <= readM;
            end

            // copia del valore letto in DP
            lddirDP2:
            begin
                DP <= {APP2, APP1, APP0};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione MOV DP, indirizzo
            //
            // lettura di 3 locazioni di memoria contigue ciascuno contenente
            // uno dei byte componenti l'indirizzo dell'operando destinario
            storeDP:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= storeDP1;
                STAR <= readM;
            end

            // scrittura del contenuto di DP all'indirizzo composto dai 3 byte
            // letti
            storeDP1:
            begin
                A23_A0 <= {APP2, APP1, APP0};
                {APP2, APP1, APP0} <= DP;
                MJR <= fetch0;
                STAR <= writeM;
            end
            
            //------------------------------------------------------------------
            // Quattro statement, del tipo di quelli che seguono, descrivono
            // un ciclo di lettura nello spazio di I/O: essi sono molti simili
            // a quelli che descrivono un ciclo di lettura in memoria, con la
            // differenza che
            //  a) e' previsto l'uso del registro /IOR invece del registro
            //     /MR;
            //  b) l'indirizzo a 24 bit e' ottenuto estendendo l'offset;
            //  c) l'indirizzo e' predisposto (per tener conto della complessa
            //     struttura delle interfacce) con un anticipo pari a un periodo
            //     di clock, rispetto all'istante in cui il valore di /ior
            //     viene messo a 0.
            //
            //------------------------------------------------------------------
            // istruzione IN offset, AL
            //
            // lettura di 2 locazioni di memoria contigue contenenti ciascuno
            // uno dei byte dell'offset
            in:
            begin
                A23_A0 <= IP;
                IP <= IP + 2;
                MJR <= in1;
                STAR <= readW;
            end

            // preparazione alla lettura all'offset nello spazio di I/O
            in1:
            begin
                A23_A0 <= {'H00, APP1, APP0};
                STAR <= in2;
            end

            // lettura nello spazio di I/O
            in2:
            begin
                IOR_ <= 0;
                STAR <= in3;
            end

            // copia in AL del valore letto nello spazio di I/O
            in3:
            begin
                AL <= d7_d0;
                IOR_ <= 1;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // Quattro statement, del tipo di quelli che seguono, descrivono
            // un ciclo di scrittura nello spazio di I/O: il valore della
            // variabile /mw va a 0 quando gli indirizzi e i dati sono ormai
            // stabili da un tempo pari a un periodo di clock e rimane a 0 per
            // un ulteriore periodo di clock; la variabile d7_d0 e' variabile
            // di uscita per un tempo piu' ampio di quello in cui il valore di
            // /mw e' 0.
            //
            //------------------------------------------------------------------
            // istruzione OUT AL, offset
            //
            // lettura in memoria di 2 locazioni contigue contenenti ciascuno
            // uno dei byte che compongono l'offset relativo allo spazio di
            // I/O
            out:
            begin
                A23_A0 <= IP;
                IP <= IP + 2;
                MJR <= out1;
                STAR <= readW;
            end

            // preparazione per la scrittura all'offset letto nello spazio I/O
            out1:
            begin
                A23_A0 <= {'H00, APP1, APP0};
                D7_D0 <= AL;
                DIR <= 1;
                STAR <= out2;
            end

            // inizio scrittura nello spazio di I/O
            out2:
            begin
                IOW_ <= 0;
                STAR <= out3;
            end

            // fine scrittura
            out3:
            begin
                IOW_ <= 1;
                STAR <= out4;
            end

            // alta impedenza in uscita a d7_d0
            out4:
            begin
                DIR <= 0;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni ADD (DP), AL
            //            ADD $operando, AL
            //            ADD indirizzo, AL
			//			  SUB (DP), AL
            //            SUB $operando, AL
            //            SUB indirizzo, AL
			//			  ADD (DP), AL
            //            ADD $operando, AL
            //            ADD indirizzo, AL
			//			  ADD (DP), AL
            //            ADD $operando, AL
            //            ADD indirizzo, AL
			//			  ADD (DP), AL
            //            ADD $operando, AL
            //            ADD indirizzo, AL
	        //	          NOT AL
            //	          SHL AL
            //	          SHR AL
            aluAL:
            begin
                AL <= alu_result(OPCODE, SOURCE, AL);
                F <= {F[7:4], alu_flag(OPCODE, SOURCE, AL)};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni ADD (DP), AH
            //            ADD $operando, AH
            //            ADD indirizzo, AH
			//			  SUB (DP), AH
            //            SUB $operando, AH
            //            SUB indirizzo, AH
			//			  ADD (DP), AH
            //            ADD $operando, AH
            //            ADD indirizzo, AH
			//			  ADD (DP), AH
            //            ADD $operando, AH
            //            ADD indirizzo, AH
			//			  ADD (DP), AH
            //            ADD $operando, AH
            //            ADD indirizzo, AH
	        //	          NOT AH
            //	          SHL AH
            //	          SHR AH
            aluAH:
            begin
                AH <= alu_result(OPCODE, SOURCE, AH);
                F <= {F[7:4], alu_flag(OPCODE, SOURCE, AH)};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzioni JMP indirizzo
            //            JE  indirizzo
            //            JNE indirizzo
            //            JA  indirizzo
            //            JAE indirizzo
            //            JB  indirizzo
            //            JBE indirizzo
            //            JG  indirizzo
            //            JGE indirizzo
            //            JL  indirizzo
            //            JLE indirizzo
            //            JZ  indirizzo
            //            JNZ indirizzo
            //            JC  indirizzo
            //            JNC indirizzo
            //            JO  indirizzo
            //            JNO indirizzo
            //            JS  indirizzo
            //            JNS indirizzo
            jmp:
            begin
                IP <= (jmp_condition(OPCODE, F) == 1)? DEST_ADDR : IP;
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            //                SUPPORTO ALLA GESTIONE DELLA PILA
            // Per vari motivi (chiamata e ritorno da sottoprogramma,
            // salvataggio e ripristino dei contenuti di registri, ecc...) e'
            // utile disporre di una pila (o stack), cioe' di un deposito in
            // cui immettere e prelevare dati in accordo alla disciplina LIF
            // (Last In First Out): il dato che vi e' stato immessi per ultimo
            // e' quello che viene prelevato per primo. La pila viene
            // realizzata utilizzando piu' locazioni contigue di memoria
            // e ogni dato occupa una o piu' locazioni; nei casi che
            // esamineremo un dato e' costituito da 1, 2, 3 o 4 byte e quindi
            // occupa da una a quattro locazioni. I dati vengono immessi uno
            // sopra l'altro e il primo dato viene immesso nel fondo della
            // pila, cioe' nella locazione o nelle locazioni a maggior
            // indirizzo fra quelle costituenti la pila stessa (quindi per
            // ogni immissione in pila decremento l'indirzzo e ad ogni
            // prelievo incrimento l'indirizzo). La funzione del registro SP
            // (Stack Pointer) e' quella di contenere, a ogni istante,
            // l'indirizzo top della porzione piena della pila, cioe'
            // l'indirizzo della locazione a partire dalla quale e' stato
            // immesso l'ultimo dato, fra quelli ancora presenti nella pila;
            // il contenuto di tale registro e' quindi automaticamente
            // aggiornato dal processore ogni volta che esso immette o preleva
            // dati dalla pila.

            //------------------------------------------------------------------
            // istruzione PUSH AL
            pushAL:
            begin
                A23_A0 <= SP - 1;
                SP <= SP - 1;
                APP0 <= AL;
                MJR <= fetch0;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzione PUSH AH
            pushAH:
            begin
                A23_A0 <= SP - 1;
                SP <= SP - 1;
                APP0 <= AH;
                MJR <= fetch0;
                STAR <= writeB;
            end

            //
            pushDP:
            begin
            end


            //
            popAL:
            begin
            end

            //
            popAL1:
            begin
            end

            //
            popAH:
            begin
            end

            //
            popAH1:
            begin
            end

            //
            popDP:
            begin
            end

            //
            popDP1:
            begin
            end

            //
            call:
            begin
            end

            //
            call1:
            begin
            end

            //
            ret:
            begin
            end

            //
            ret1:
            begin
            end

            //------------------------------------------------------------------
            // ISTRUZIONE NON VALIDA: HALT
            nvi:
            begin
                STAR <= nvi;
            end

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
            begin
                MR_ <= 0;
                DIR <= 0;
                NUMLOC <= 1;
                STAR <= read0;
            end

            readW:
            begin
                MR_ <= 0;
                DIR <= 0;
                NUMLOC <= 2;
                STAR <= read0;
            end

            readM:
            begin
                MR_ <= 0;
                DIR <= 0;
                NUMLOC <= 3;
                STAR <= read0;
            end

            readL:
            begin
                MR_ <= 0;
                DIR <= 0;
                NUMLOC <= 4;
                STAR <= read0;
            end

            read0:
            begin
                APP0 <= d7_d0;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= (NUMLOC == 1)? read4:read1;
            end

            read1:
            begin
                APP1 <= d7_d0;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= (NUMLOC == 1)? read4:read2;
            end

            read2:
            begin
                APP2 <= d7_d0;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= (NUMLOC == 1)? read4:read3;
            end

            read3:
            begin
                APP3 <= d7_d0;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= read4;
            end

            read4:
            begin
                MR_ <= 1;
                STAR <= MJR;
            end

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
            begin
                D7_D0 <= APP0;
                DIR <= 1;
                NUMLOC <= 1;
                STAR <= write0;
            end

            writeW:
            begin
                D7_D0 <= APP0;
                DIR <= 1;
                NUMLOC <= 2;
                STAR <= write0;
            end

            writeM:
            begin
                D7_D0 <= APP0;
                DIR <= 1;
                NUMLOC <= 3;
                STAR <= write0;
            end

            writeL:
            begin
                D7_D0 <= APP0;
                DIR <= 1;
                NUMLOC <= 4;
                STAR <= write0;
            end

            write0:
            begin
                MW_ <= 0;
                STAR <= write1;
            end

            write1:
            begin
                MW_ <= 1;
                STAR <= (NUMLOC == 1)? write11:write2;
            end

            write2:
            begin
                D7_D0 <= APP1;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= write3;
            end

            write3:
            begin
                MW_ <= 0;
                STAR <= write4;
            end

            write4:
            begin
                MW_ <= 1;
                STAR <= (NUMLOC == 1)? write11:write5;
            end

            write5:
            begin
				D7_D0 <= APP2;
                A23_A0 <= A23_A0 + 1;
                NUMLOC <= NUMLOC - 1;
                STAR <= write6;
            end

            write6:
            begin
				MW_ <= 0;
                STAR <= write7;
            end

            write7:
            begin
				MW_ <= 1;
                STAR <= (NUMLOC == 1)? write11:write8;
            end

            write8:
            begin
				D7_D0 <= APP3;
                A23_A0 <= A23_A0 + 1;
                STAR <= write9;
            end

            write9:
            begin
                MW_ <= 0;
                STAR <= write10;
            end

            write10:
            begin
                MW_ <= 1;
                STAR <= write11;
            end

            write11:
            begin
                DIR <= 0;
                STAR <= MJR;
            end
        endcase
endmodule

// [0]
// Il registro NUMLOC viene usato nei sottoprogrammi di lettura e scrittura in
// memoria che permettono l'accesso a locazioni multiple cosecutive.

// [1]

