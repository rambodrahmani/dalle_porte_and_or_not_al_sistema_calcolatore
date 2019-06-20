/**
 * File: sEP8.v
 *       
 *       ***********************************************************************
 *       *      DESCRIZIONE COMPLETA DEL PROCESSORE sEP8, POTENZIATO           *
 *       *         PER SUPPORTARE IL MECCANISMO DELLE INTERRUZIONI             *
 *       ***********************************************************************
 *
 *       Le istruzioni connesse al meccanismo di interruzione sono globalmente
 *       5, e in accordo alla terminologia INTEL, le denomineremo
 *       rispettivamente
 *          LIDTP: durante l'esecuzione di tale operazione, il processore
 *          inizializza il contenuto del registro IDTP (Interrupt Descriptor
 *          Table Pointer), immettendovi l'indirizzo specificato come operando
 *          immediato (a 24 bit) dell'istruzione stessa.
 *          
 *          INT: durante l'esecuzione di tale istruzione, il processore
 *          maschera le richieste di interruzioni esterne ed effettua la
 *          chiamata di un sottoprogramma di servizio. Piu' precisamente il
 *          processore compie le seguenti azioni: i) salva nella pila il
 *          contenuto del registro dei flag F e l'indirizzo dell'istruzione di
 *          rientro (contenuto nel registro IP); ii) azzera il contenuto del
 *          registro dei flag F, mascherando cosi' le richieste di
 *          interruzioni esterne; iii) interpreta l'operando immediato
 *          dell'istruzione come il tipo dell'interruzione e si procura nella
 *          Interrupt Descriptor Table l'indirizzo della prima istruzione del
 *          sottoprogramma di servizio; iv) immette tale indirizzo nel
 *          registro IP.
 *          
 *          IRET: durante l'esecuzione di tale istruzione, il processore
 *          effettua il ritorno da un sottoprogramma di servizio di una
 *          interruzione. Piu' precisamente, il processore rimuove dalla pila
 *          4 byte e con essi rinnova il contenuto dei due registri IP e F.
 *          
 *          CLI: (Clear Interrupt Flag) durante l'esecuzione di tale
 *          istruzione, il processore mette a 0 il contenuto del flag IF,
 *          lasciando inalterato il contenuto di tutti gli altri flag.
 *
 *          STI: (Set Interrupt Flag) durante l'esecuzione di tale istruzione,
 *          il processore mette a 1 il contenuto del flag IF, lasciando
 *          inalterato il contenuto di tutti gli altri flag.
 *          
 *       Come gia' detto piu' volte, tra le azioni compiute dal processore
 *       nel gestire una richiesta di interruzione, c'e' anche
 *       l'azzeramento del contenuto del registro dei flag F. Questo fatto
 *       implica che, quando un sottoprogramma di servizio di una
 *       interruzione viene messo in esecuzione, il contenuto del registro
 *       IF e' 0 e quindi il processore non e' abilitato ad accettare nuove
 *       richieste di interruzione esterne (mascherabili). In altre parole,
 *       e' precluso un annidamento di sottoprogrammi di servizio di
 *       interruzioni esternem a meno che i sottoprogrammi syessi non
 *       contengano esplicitamente l'istruzione STI.
 *          
 *       Cio' premesso, le ulteriori modifiche da apportare alla
 *       descrizione del processore sEP8 per renderlo capace di gestire
 *       anche le richieste di itnerruzioni esterne mascherabili, sono le
 *       seguenti:
 *          1) Introduzione della variabile di ingresso intr, della variabile
 *          di uscita inta e di un registro INTA (a sostegno di inta),
 *          azzerato al reset iniziale.
 *          2) Potenziamento del registro dei flag F, introduzione delle due
 *          istruzioni CLI e STI e revisione degli statement di etichetta
 *          aluAL e aluAH tenendo conto che ora e' significativo anche F[4].
 *          3) Introduzione di nuovi stati interi, fra cui uno stato interno
 *          test_intr in cui il processore va a verificare l'eventuale
 *          presenza di interruzioni esterne non mascherate e quindi passa
 *          a selezionare, come stato interno successivo, lo stato fetch0 se
 *          il test da' esito negativo, oppure se il test da' esito positivo,
 *          un nuvoo stato interno pre_tipo0.
 *          4) Raggiungimento dello stato interno test_intr tramite
 *          sostituzione dei microsalti STAR <= fetch0 con il microsalto STAR
 *          <= test_intr e delle microperazioni MJR <= fetch0 con la
 *          microoperazione MJR <= test_intr.
 *          5) Inizio, a partire dallo stato interno pre_tipo0, dell'handshake
 *          con la sorgente equivalente di interruzioni esterne per la
 *          ricezione, tramite la variabile d7_d0 del bus, del tipo
 *          dell'interruzione.
 *
 *       Ricompattando la descrizione del processore sEP8 fatta nel capitolo
 *       VI, con le modifiche e integrazioni apportate nei paragrafi
 *       precedenti, risulta che la descrizione completa del processore,
 *       potenziato per supportare il meccanismo delle interruzioni, e' la
 *       seguente:
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 15/06/2019.
 */

//------------------------------------------------------------------------------
//  DESCRIZIONE COMPLETA DEL PROCESSORE sEP8
//------------------------------------------------------------------------------
module sEP8(d7_d0, a23_a0, mr_, mw_, ior_, iow_, inta, intr, clock, reset_);
    input           clock, reset_;
    input           intr;
    input   [7:0]   d7_d0;
    output  [23:0]  a23_a0;
    output          mr_, mw_;
    output          ior_, iow_;
    output          inta;

    // REGISTRI OPERATIVI DI SUPPORTO ALLE VARIABILI DI USCITA E ALLE
    // VARIABILI BIDIREZIONALI E CONNESSIONE DELLE VARIABILI AI REGISTRI
    reg         DIR;
    reg [7:0]   D7_D0;
    reg [23:0]  A23_A0;
    reg         MR_, MW_, IOR_, IOW_;
    reg         INTA;
    assign      mr_ = MR_;
    assign      mw_ = MW_;
    assign      ior_ = IOR_;
    assign      iow_ = IOW_;
    assign      inta = INTA;
    assign      a23_a0 = A23_A0;
    assign      d7_d0 = (DIR == 1)?D7_D0:'HZZ;

    // REGISTRI OPERATIVI INTERNI
    reg [2:0]   NUMLOC;
    reg [7:0]   AL, AH, F, OPCODE, SOURCE, APP3, APP2, APP1, APP0;
    reg [23:0]  DP, IP, SP, DEST_ADDR, IDTP;

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
              ldIDTP=35,
              ldIDTP1=36,
              in=37,
              in1=38,
              in2=39,
              in3=40,
              out=41,
              out1=42,
              out2=43,
              out3=44,
              out4=45,
              aluAL=46,
              aluAH=47,
              jmp=48,
              pushAL=49,
              pushAH=50,
              pushDP=51,
              popAL=52,
              popAL1=53,
              popAH=54,
              popAH1=55,
              popDP=56,
              popDP1=57,
              call=58,
              call1=59,
              ret=60,
              ret1=61,
              int=62,
              int1=63,
              int2=64,
              iret=65,
              iret1=66,
              cli=67,
              sti=68,
              test_intr=69,
              pre_tipo0=70,
              pre_tipo1=71,
              nvi=72,
              readB=73,
              readW=74,
              readM=75,
              readL=76,
              read0=77,
              read1=78,
              read2=79,
              read3=80,
              read4=81,
              writeB=82,
              writeW=83,
              writeM=84,
              writeL=85,
              write0=86,
              write1=87,
              write2=88,
              write3=89,
              write4=90,
              write5=91,
              write6=92,
              write7=93,
              write8=94,
              write9=95,
              write10=96,
              write11=97;

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
                    'B10010: valid_fetch = 1;
                    'B10011: valid_fetch = 1;
                    'B10100: valid_fetch = 1;
                endcase
            'B001:          // FORMATO F1
                casex(opcode[4:0])
                    'B00000: valid_fetch = 1;
                    'B00001: valid_fetch = 1;
                    'B00010: valid_fetch = 1;
                    'B00011: valid_fetch = 1;
                    'B00100: valid_fetch = 1;
                    'B00101: valid_fetch = 1;
                    'B00110: valid_fetch = 1;
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
                    'B01100: valid_fetch = 1;

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
    function [6:0] first_execution_state;
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
            'B00010010: first_execution_state = iret;       // IRET
            'B00010011: first_execution_state = cli;        // CLI
            'B00010100: first_execution_state = sti;

            // Formato F1
            'B00100000: first_execution_state = in;         // IN  offset, AL
            'B00100001: first_execution_state = out;        // OUT AL, offset
            'B00100010: first_execution_state = ldimmDP;    // MOV $operando, DP
            'B00100011: first_execution_state = ldSP;       // MOV $operando, SP
            'B00100100: first_execution_state = lddirDP;    // MOV indirizzo, DP
            'B00100101: first_execution_state = storeDP;    // MOV DP, indirizzo
            'B00100110: first_execution_state = lidtp;      // LIDTP $operando

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
            'B10001100: first_execution_state = int;        // INT $operando

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
            INTA <= 0;
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

            // se l'OPCODE e' valido prosegui con il fetch per quel tipo di
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
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione MOV AL, AH
            ALtoAH:
            begin
                AH <= AL;
                STAR <= test_int;
            end

            //------------------------------------------------------------------
            // istruzione MOV AH, AL
            AHtoAL:
            begin
                AL <= AH;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione INC DP
            incDP:
            begin
                DP <= DP + 1;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzioni MOV (DP), AL
            //            MOV $operando, AL
            //            MOV indirizzo, AL
            ldAL:
            begin
                AL <= SOURCE;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzioni MOV (DP), AH
            //            MOV $operando, AH
            //            MOV indirizzo, AH
            ldAH:
            begin
                AH <= SOURCE;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzioni MOV AL, (DP)
            //            MOV AL, indirizzo
            storeAL:
            begin
                A23_A0 <= DEST_ADDR;
                APP0 <= AL;
                MJR <= test_intr;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzioni MOV AH, (DP)
            //            MOV AH, indirizzo
            storeAH:
            begin
                A23_A0 <= DEST_ADDR;
                APP0 <= AH;
                MJR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                MJR <= test_intr;
                STAR <= writeM;
            end

            //------------------------------------------------------------------
            // istruzione LIDTP $operando
            ldIDTP:
            begin
                A23_A0 <= IP;
                IP <= IP + 3;
                MJR <= ldIDTP1;
                STAR <= readM;
            end

            ldIDTP1:
            begin
                IDTP <= {APP2, APP1, APP0};
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                STAR <= test_intr;
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
                MJR <= test_intr;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzione PUSH AH
            pushAH:
            begin
                A23_A0 <= SP - 1;
                SP <= SP - 1;
                APP0 <= AH;
                MJR <= test_intr;
                STAR <= writeB;
            end

            //------------------------------------------------------------------
            // istruzione PUSH DP
            pushDP:
            begin
                A23_A0 <= SP - 3;
                SP <= SP - 3;
                {APP2, APP1, APP0} <= DP;
                MJR <= test_intr;
                STAR <= writeM;
            end


            //------------------------------------------------------------------
            // istruzione POP AL
            //
            // lettura del valore indirizzato dal registro SP
            popAL:
            begin
                A23_A0 <= SP;
                SP <= SP + 1;
                MJR <= popAL1;
                STAR <= readB;
            end

            // copia del valore letto in AL
            popAL1:
            begin
                AL <= APP0;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione POP AH
            //
            // lettura del valore indirizzato dal registro SP
            popAH:
            begin
                A23_A0 <= SP;
                SP <= SP + 1;
                MJR <= popAH1;
                STAR <= readB;
            end

            // copia del valore letto in AH
            popAH1:
            begin
                AH <= APP0;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione POP DP
            //
            // lettura di 3 locazioni di memoria a partire dall'indirizzo nel
            // registro SP
            popDP:
            begin
                A23_A0 <= SP;
                SP <= SP + 3;
                MJR <= popDP1;
                STAR <= readM;
            end

            // copia del valore letto dalle 3 locazioni di memoria in DP
            popDP1:
            begin
                DP <= {APP2, APP1, APP0};
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione CALL indirizzo
            //
            // salvataggio nella pila del contenuto del registro IP
            call:
            begin
                A23_A0 <= SP - 3;
                SP <= SP - 3;
                {APP2, APP1, APP0} <= IP;
                MJR <= call1;
                STAR <= writeM;
            end

            // copia nel registro IP dell'indirizzo contenuto in DEST_ADDR
            call1:
            begin
                IP <= DEST_ADDR;
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // istruzione RET
            //
            // lettura dalla pila del contenuto salvato precedentemente del
            // registro IP
            ret:
            begin
                A23_A0 <= SP;
                SP <= SP + 3;
                MJR <= ret1;
                STAR <= readM;
            end

            // scrittura in IP del valore prelevato dalla pila
            ret1:
            begin
                IP <= {APP2, APP1, APP0};
                STAR <= test_intr;
            end

            //------------------------------------------------------------------
            // INT $operando
            //
            // salvataggio nella pila del registro IP e del registro dei flag
            // F e azzeramento del registro F.
            int:
            begin
                A23_A0 <= SP - 4;
                SP <= SP - 4;
                {APP3, APP2, APP1, APP0} <= {F, IP};
                F <= 'H00;
                MJR <= int1;
                STAR <= writeL;
            end

            // lettura dall'IDT dell'indirizzo per il sottoprogramma richiesto
            int1:
            begin
                A23_A0 <= IDTP + {SOURCE, 3'B000};
                MJR <= int2;
                STAR <= readM;
            end

            // immissione nell'IP dell'indirizzo del sottoprogramma
            int2:
            begin
                IP <= {APP2, APP1, APP0};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione IRET
            //
            // lettura dalla pila dei contenuti salvati dei registri IP ed F
            iret:
            begin
                A23_A0 <= SP;
                SP <= SP + 4;
                MJR <= iret1;
                STAR <= readL;
            end

            // ripristino del contenuto dei registri F e IP
            iret1:
            begin
                {F, IP} <= {APP3, APP2, APP1, APP0};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione CLI
            //
            // resetta l'elemento 4 del registro F
            cli:
            begin
                F <= {F[7:5], 1'B0, F[3:0]};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // istruzione STI
            //
            // setta l'elemento 4 del registro F
            sti:
            begin
                F <= {F[7:5], 1'B1, F[3:0]};
                STAR <= fetch0;
            end

            //------------------------------------------------------------------
            // VERIFICA DELLA PRESENZA DI INTERRUZIONI ESTERNE
            // NON MASCHERATE ED EVENTUALE PRELIEVO DEL TIPO
            test_intr:
            begin
                DIR <= 0;
                STAR <= ((intr & F[4]) == 0)? fetch0:pre_tipo0;
            end

            pre_tipo0:
            begin
                INTA <= 1;
                STAR <= (intr == 1)? pre_tipo0:pre_tipo1;
            end

            pre_tipo1:
            begin
                SOURCE <= d7_d0;
                INTA <= 0;
                STAR <= int;
            end

            //------------------------------------------------------------------
            // ECCEZIONE PER CODICE OPERATIVO NON VALIDO
            nvi:
            begin
                SOURCE <= 'H06;
                STAR <= int;
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

