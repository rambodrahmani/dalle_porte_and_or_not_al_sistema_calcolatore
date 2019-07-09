/**
 * File: Memoria_Video.v
 *       Non entreremo nei dettagli strutturali dell'adattatore grafico (che
 *       rimane comuqnue uno dei circuiti piu' complessi all'interno di un
 *       calcolatore). Per quanto concerne la memoria video, si puo' pensare
 *       ad essa in modo estremamente semplificato, come a una memoria in cui
 *          1. non esiste una variabile bidirezionale per i dati, ma la
 *             variabile per l'ingresso dei dati da scrivere (d7_d0) e'
 *             distinta dalla variabile q7_q0 per l'uscita dei dati letti
 *             (dall'adattatore grafico);
 *          2. entrano due variabili per gli indirizzi di cui una (continuiamo
 *             a chiamarla a15_a0) va alle circuiterie che convogliano
 *             i segnali per la scrittura mentre l'altra (chiamiamola
 *             a15_a0_ag) va alle circuiterie che selezionano e portano in
 *             uscita i dati durante i cicli di lettura.
 *       In tal modo la memoria e' disponibile per un ciclo di scrittura
 *       (portato avanti da parte del processore) e per un ciclo di lettura
 *       (portato avanti dall'adattatore grafico), anche contemporanei.
 *
 *       Le descrizione Verilog di una memoria video così strutturata (1) e' la
 *       seguente:
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 09/07/2019.
 */

module Memoria_Video(d7_d0, a15_a0, s_, mw_, q7_q0, a15_a0_ag);
    input   [7:0]   d7_d0;      // from the BUS
    input   [15:0]  a15_a0;     // from the BUS
    input           mw_;        // from the BUS
    input           s_;         // form the Mask
    input   [15:0]  a15_a0_ag;  // from the graphic adapter
    output  [7:0]   q7_q0;      // to the graphic adapter

    // 64 Kbyte of video memory
    reg [7:0]   D_LATCH[0:65535];

    wire beta;
    assign beta = ({s_, mw_} == 'B00)?1:0;

    // the graphic adapter reads continuously from the video memory
    assign q7_q0 = D_LATCH[a15_a0_ag];

    // processor writing to the video memory
    always @(beta or d7_d0) if (beta == 1) D_LATCH[a15_a0] = d7_d0;
endmodule

/* 1
 * 
 * La scheda video e' un modulo fisico che raccorda il bus del calcolatore al
 * monitor, permettendone una gestione (relativamente) semplice. Le moderne
 * schede video sono dotate di memorie video dell'ordine dei megabyte e di
 * adattatori grafici costituiti da processori specializzati, spesso potenti
 * quanto il processore principale del calcolatore vero e proprio (se non
 * oltre). Per poter capire le specifiche funzionali di una scheda video,
 * occorre tuttavia premettere alcune nozioni di base sulle modalita' in cui
 * vengono costruite le immagini sullo schermo di un monitor.
 * 
 * Lo schermo di un monitor e' una matrice di areole (pixel fisici
 * o brevemente pixel), costituite a loro volta da tre sub-areole (dot), che,
 * sottoposte a un opportuno stimolo, si colorano rispettivamente di rosso, di
 * verde e di blu (standard RGB - Red, Green, Blue), con gradazioni che
 * dipendono dall'intensita' dello stimolo. Stanti la ridotta dimensione dei
 * tre dot e le limitate capacita' dell'occhio umano, i tre dot di un pixel
 * vengono recepiti dall'occhio umano come un pixel uniformemente colorato, il
 * colore venendo a dipendere dalla gradazione dei colori dei tre dot
 * e quindi, in ultima analisi, dell'intensita' dello stimolo  cui ciascuno di
 * essi e' sottoposto.
 * 
 * Gli standard tipici attuali (che hanno varie sigle) prevedono numeri di
 * pixel pari a 1024*768, 1280*1024, 1600*1200 o superiori; tutti questi
 * standard derivano dal vecchio standard VGA a 640*480 pixel, che a sua volta
 * deriva dallo standard MCGA a 320*200 pixel. La qualita' dell'immagine sullo
 * schermo non dipende esclusivamente dal numero dei pixel, ma anche dal
 * numero dei colori fra i quali si puo' scegliere il colore con cui
 * colorarlo; questo numero e' ormai dell'ordine di molte centinaia di
 * migliaia e puo' arrivare ai milioni, mentre era 256 nello standard MCGA.
 * 
 * Le succitate caratteristiche dello schermo sono sfrittate nel seguente
 * modo. All'interno del monitor, una complessa circuiteria genera tre segnali
 * stimolatori contigui e di intesita' variabile, capaci di agire con
 * esattezza sui tre dot di un qualunque pixel dello schermo; l'insieme dei
 * tre segnali costituisce pertanto un pennello elettronico capace di agire
 * e quindi di colorare un qualunque pixel dello schermo. Il pennello
 * elettronico e' tenuto in continuo movimento ed e' guidato a compiere piu'
 * volte al secondo un percorso che inizia dall'angolo sinistro in alto dello
 * schermo e termina nell'angolo desotr in basse e si sviluppa per righe
 * orizzontali tracciate da sinistra verso detra, con rapidi riposizionamenti
 * dalla fine di una riga all'inizio della riga successiva (per evitare ovvi
 * effetti distruittivi, l'intesita' dei tre fasci di elettroni viene
 * annullata durante i movimenti di riposizionamento nel pennello
 * elettronico).
 * 
 * L'ultima riga in basso ha come consecutiva la prima riga in alto, in
 * accordo a una strategia di scansone non interlacciata. Ne risulta che sullo
 * schermo compare un'immagine che l'occhio umano recepisce come uniforme
 * e stabile, almeno se la dimensione dei pixel e' sufficientemente piccola
 * e se il numero di volte l'intero schermo e' completamente ridipinto in un
 * secondo (frequenza verticale) e' sufficientemente elevato; nei monitor
 * a cristalli liquidi si hanno otimi risultati con pixel di dimensioni
 * dell'ordine di 0.25 - 0.28 mm e con frequenza di rinfresco di 60 Hz.
 * 
 * Parametri correlati alle dimensioni dello schermo, alla dimensione del
 * pixel e alla frequenza verticale, sono il massimo numero di volte che
 * l'intensita' di ciascun fascio di elettroni del pennello puo' essere
 * cambiata in un secondo (in pratica il massimo numero di pixel contigui che
 * possono essere colorati in modo distinto in un secondo) e il numero di
 * righe orizzontali che possono essere dipinte in un secondo. Il primo di
 * questi due parametri e' detto dot rate o banda video, il secondo frequenza
 * orizzontale; nei monitor attuali si hanno bande video fino a 200 MHz
 * e frequenze orizzontali fino a 90 KHz (ovviamente deve essere di gran lunga
 * maggiore della frequenza verticale).
 * 
 * Globalmente il monitor deve ricevere dalla scheda video (almeno) tre
 * segnali con cui modulare a sua volta le intensita' dei tre segnali
 * stimolatori costituenti il pennello elettronico e due segnali di
 * sincornismo, uno per scandire gli istanti in cui il pennello elettronico
 * deve essere riposizionato nell'angolo superiore sinistro dello schermo
 * (sincronismo verticale) e uno per scnadire gli istanti in cui il pennello
 * elettronico, nel suo viaggiare verso l'angolo inferiore destro dello
 * schermo, deve essere riposizionato all'inizio di una nuova riga
 * (sincronismo orizzontale).
 * 
 * La scheda video nasconde, una volta inizializzata, tutte le caratteristiche
 * del monitor e ne virtualizza lo shcermo. L'immagine che viene dipinta sullo
 * schemro e' infatti impostabile definendo il colore di ciascun pixel e tale
 * impostazione viene fatta dal processore scrivendo un'ooportuna
 * configurazione di bit nella porizione della memoria video associata a quel
 * pixel.
 * 
 * In quanto segue faremo riferimento a una scheda video semplificata per uno
 * standard a 320*200 pixel, in cui il colore di un pixel possa essere scelto
 * in un insieme di 256 colori e in cui tale insieme possa essere a sua volta
 * construito scegliendo in un insieme piu' grande (tavolozza) di 256K colori.
 * 
 * La scheda video e' costuita da una memoria video di 64 Kbyte e da un
 * adattatore grafico per monitor analogici CRT o digitali CRT compatibili
 * (cioe' connessioni VGA e DVI-A). Esso e' dotato (fra l'altro) di una
 * memoria da 256*18 bit (detta look-up table) e di tre convertitori
 * digitali/analogici (uno per ciascuno dei tre colori fondamentali).
 * 
 * Ciascuna delle prime 64000 locazioni della memoria video e' associata a un
 * pixel (si noti infatti che 320*200 = 64000), mentre le ultime 1536
 * locazioni non sono utilizzate; la legge di associazione prevede che il
 * pixel di coordinate x, y (con 0 <= x < 320 e 0 <= y < 200) sia associata
 * alla locazione di indirizzo locale (cioe' di offset) pari a x*(320 * y).
 * L'adattatore grafico legge, ad intervalli di tempo regolari, le varie
 * locazioni della memoria video e, quando ha letto il contenuto della
 * locazione associata a un certo pixel, compie le seguente azioni:
 *  1. utilizza la combinazione degli 8 bit letti come un indirizzo per
 *     accedere in lettura a una delle 256 locazioni della look-up table
 *     e ricavarne una combinazione di 18 bit;
 *  2. considera questa combinazione di 18 bit come la codifica del colore che
 *     dovra' caratterizzare il pixel e quindi la trasmette ai suoi tre
 *     convertitori digitali-analogici. I tre convertitori generano i tre
 *     segnali analogici corrispondenti ai tre colori fondamentali e li
 *     trasmettono al monitor tramite i cavi di collegamento come rosso, verde
 *     e blu (ogni convertitore opera su 6 bit, potendo cosi' generare 64
 *     livelli di colore)
 * Il tutto avviene in accordo a una rigida temporizzazione, della quale il
 * monitor viene reso edotto tramite i segnali dell'adattatore grafico. In
 * alcuni standard, quali ad esempio lo standard RGB composito, i segnali di
 * sincronismo sono combinati con il segnale che da' il livello al verde).
 * 
 * L'adattatore grafico rappresenta anche un'interfaccia che da corpo, tramite
 * due dei suoi registri (noti come PELA e PELD) a due porte dello spazio di
 * I/O; il processore accede a tali porte durante l'esecuzione di u programma
 * che fa largo uso delle istruzioni OUT AL, PELA e OUT AL, PELD e immette in
 * tal modo nella look-up table la codifica a 18 bit dei 256 colori che
 * saranno utilizzati nel dipingere l'immagine sullo schermo: diminuendo il
 * range di colori utilizzati in totale si ottiene una maggiore precisione per
 * il singolo colore (la necessita' di cambiare il contenuto della look-up
 * table non e' frequente).
 * 
 * La memoria video, come gia' detto, da' invece corpo alle locazioni di
 * indirizzo da 'H0A0000 a 'H0AFFFF; tali locazioni sono accessibili al
 * processore per oprazioni di scrittura, tramite l'esecuzione delle normali
 * istruzioni MOV AL, un_indirizzo.
 */

