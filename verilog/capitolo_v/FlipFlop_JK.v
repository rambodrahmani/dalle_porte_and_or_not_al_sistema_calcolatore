/**
 * File: Formatore_di_Impulsi.v
 *       Come secondo esempio di rete sequenziale sincronizzata, descriviamo
 *       un consumatore che riceve da un produttore, tramite la variabile
 *       numero, un flusso di byte (8 bit), elabora i byte ricevuti ed emette,
 *       tramite la variabile di uscita out, degli impulsi di durata
 *       correlata ai risultati delle elaborazioni. Per regolamentare il
 *       flusso di byte da elaborare, il consumatore e il produttore
 *       sostengono anche un opportuno colloquio (handshake) tramite la coppia
 *       di variabili /dav (data valid) (N.B: attiva bassa) e rfd (ready for
 *       data).
 *
 *       Piu' nel dettaglio valgono le seguenti specifiche:
 *       1. Specifiche sullo handshake /dav, rfa fra produttore e consumatore:
 *          Partendo da una condizione iniziale in cui /dav e' a 1 (a indicare
 *          che nessun nuovo byte e' fornito dal produttore come stato della
 *          variabile numero) e rfd e' a 1 (a indicare che il consumatore e'
 *          disponibile a prelevare ed elaborare un nuobo byte), il produttore
 *          come la prima mossa presentando un nuovo byte come stato della
 *          variabile numero e ponendo poi, a notifica di cio', /dav a 0.
 *          A questo punto il consumatore preleva il byte, pone rfd a 0 (a
 *          indicare che non e' ulteriormente disponibile a prelevare altri
 *          byte) e inizia a utilizzare il byte prelevato. Il produttore puo'
 *          allora riportare /dav a 1 e attendere che il consumatore, utilizzato
 *          il byte, riporti rfd a 1 (ripristino delle condizioni iniziali).
 *       
 *       2. Specifiche sull'uso, da parte del consumatore, del byte prelevato:
 *          Il consumatore utilizza il byte prelevato interpretandolo come un
 *          numero naturale n in base due e portando a 1 la variabile di
 *          uscita out, di un registro operativo OUT a un bit per supportare
 *          la variabile di uscita out, di un registro operativo RFD a un bit
 *          per supportare la variabile di uscita rfd e di un registro
 *          operativo COUNT a otto bit per memorizzare il byte fornito dal
 *          produttore e poi per contare il tempo in cui la variabile out deve
 *          stare a 1.
 *          
 *          Il consumatore puo' quindi essere descritto a livello di linguaggio
 *          di trasferimento tra registri, come riporrtato di seguito:
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 23/05/2019.
 */

module Formatore_di_Impulsi(dav_, rfd, numero, out, clock, reset_);
    input clock, reset_;
    input dav_;
    input [7:0] numero;

    output rfd;
    output out;

    reg RFD;
    assign rfd = RFD;

    reg OUT;
    assign out = OUT;

    reg [7:0] COUNT;
    reg [1:0] STAR;

    parameter s0 = 'B00, s1 = 'B01, s2 = 'B10;

    always @(reset_ == 0) #1
        begin
            RFD <= 1;
            OUT <= 0;
            STAR <= s0;
        end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            s0: begin
                    RFD <= 1;
                    OUT <= 0;
                    COUNT <= numero;
                    STAR <= (dav_ == 1)?s0:s1;
                end

            s1: begin
                    RFD <= 0;
                    OUT <= 1;
                    COUNT <= COUNT - 1;
                    STAR <= (COUNT == 1)?s2:s1;
                end

            s2: begin
                    RFD <= 0;
                    OUT <= 0;
                    STAR <= (dav_ == 1)?s0:s2;
                end
        endcase
endmodule

/*
 * Nello statement di etichetta s0 sono descritti l'attesa della notifica
 * della presenza di un byte utile come stato della variabile numero ed il
 * prelievo e la memorizzazione nel registro COUNT di tale byte; nello
 * statement di etichetta s1 sono descritti la risposta al produttore che il
 * byte utile e' stato prelevato, il settaggio della variabile di uscita out
 * e il conteggio del tempo in cui essa deve rimanere a 1; nello statement di
 * etichetta s2 sono descritti la messa a 0 del valore della variabile di
 * uscita out e il ritrno nelle condizioni iniziali (previa verifica
 * e eventuale attesa che il produttore abbia chiuso il colloquio).
 */

