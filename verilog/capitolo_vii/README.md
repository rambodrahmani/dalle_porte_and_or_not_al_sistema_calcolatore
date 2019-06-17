# Capitolo VII - Il Meccanismo Dell'Interruzione

Come si e' gia' osservato nel Capitolo VI, la tecnica di ingresso/uscita dati
a controllo di programma implica che il processore esegua, per ogni da
trasferire, un pacchetto di istruzioni in cui impegna ("spreca") del tempo
nell'attesa che l'interfaccia (vincolata dal lento dispositivo esterno) sia
pronta al trasferimento. Una delle tecniche a cui si ricorre per evitare
questo spreco di tempo e' nota come ingresso/uscita dati a interruzione di
programma. Essa si basa sull'osservazione che segue. Invece di costringere il
processore a sprecare il suo tempo nel testare e nell'attendere che
l'interfaccia sia pronta al trasferimento di un dato, conviene impegnare il
processore in operazioni piu' utili e potenziare l'interfaccia e il processore
stesso in modo che: i) l'interfaccia sia in grado di segnalare al processore
quando essa e' pronta al trasferimento di un dat; ii) il processore reagisca a
questa segnalazione interrompendo, momentaneamente, l'esecuzione del programma
in corso e passando ad eseguire un sottoprogramma di servizio, predisposto per
fargli compiere l'effettiva operazione di ingresso/uscita del dato.

Oltre a segnalazioni provenienti dalle interfacce, anche il verificarsi di
particolari condizioni all'interno del processore (in genere condizioni
anomale) oppure l'esecuzione di un'opportuna istruzione che l'utente inserisce
nel proprio programma, sono eventi che normalmente producono una temporanea
interruzione del programma in corso. In generale si puo' dire che
un'interruzione e' una sospensione del programma in esecuzione e la chiamata
automatica di un apposito sottoprogramma di servizio predisposto per
soddisfare le esigenze che hanno provocato la richiesta di interruzione e per
tornare poi al programma sospeso. Generalmente il software di base fornito
dall'hardware di un calcolatore include un certo numero di sottorprogrammi di
servizio. Il caricamento in memoria di questi sottoprogrammi avviene durante
l'esecuzione del programma di gestione del calcolatore (noi possiamo pensare
che questo compito sia svolto dal processore durante l'esecuzione del
programma bootstrap).

In base alle modalita' con cui vengono richieste, le interruzioni sono
usualmente suddivise in tre classi:
    1. interruzioni esterne: vengono richieste dalle interfacce facendo giungere
    al processore opportuni segnali tramite apposiute variabili di collegamento;
    2. interruzioni software: vengono richieste come espletamento della fase di
    esecuzione di una specifica istruzione (nota come INT $operando);
    3. interruzioni interne (o eccezioni): vengono richieste da circuiterie
    interne al processore, quando si verificano in esso condizioni anomale che
    impediscono il completamento dell'istruzione in corso.

Tutte le richieste di interruzioni si traducono sempre in un'effettiva
interruzione, ad esclusione delle richieste esterne. Tali richieste sono
invece mascherabili in quantop vengono prese in considerazione se e solo se un
opportuno elemento del registro dei flag F contiene 1. E' inoltre importante
puntualizzare che il processore esamina le richieste di interruzione esterne
dopo aver terminato la fase di esecuzione di una istruzione e prima di
iniziare la fase di chiamata dell'istruzione successiva; pertanto
un'istruzione in esecuzione non puo' essere interrotta a meta' in seguito
all'arrivo di una richiesta di interruzione esterna.

--

Originariamente visto qui: [Dalle porte AND OR NOT al sistema
calcolatore](http://www.edizioniets.com/scheda.asp?n=9788846743114).

