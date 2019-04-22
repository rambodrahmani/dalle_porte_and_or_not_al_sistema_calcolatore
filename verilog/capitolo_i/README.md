# Capitolo I: Reti Logiche, Linguaggio Verilog E Algebra Booleana

In elettronica una rete logica è un insieme di dispositivi interconnessi che
realizza un'elaborazione ovvero una certa funzione logica. Possono essere di
natura elettronica, nell'accezione più comune, ma potenzialmente anche di altra
natura, se in grado di trasmettere e elaborare un segnale, come nella fotonica,
eccetera. Esistono essenzialmente due tipi principali di reti logiche: le reti
unilaterali e le reti bilaterali.

Le reti unilaterali sono reti in cui lo stato delle uscite, cioè se l'uscita
assume valore alto o basso, dipende esclusivamente da valori di grandezze
elettriche calcolate in un determinato punto del circuito: in queste reti il
flusso dell'elaborazione procede fisicamente in un'unica direzione e ne sono
esempi elementari le porte logiche; per chiarire meglio, consideriamo una porta
AND a due ingressi: lo stato dell'uscita della porta AND dipende dai valori di
corrente applicati ai due pin di entrata e il flusso dell'elaborazione procede
dai pin di entrata al pin di uscita.

Le reti bilaterali sono reti in cui la funzione di uscita è valutata tra due
punti, cioè l'uscita è determinata dal fatto che ci sia o meno un contatto tra
due punti: se ad esempio nel punto A arriva corrente ma non c'è contatto con B
allora l'uscita sarà bassa, se c'è contatto l'uscita sarà alta; inoltre non è
detto che la corrente possa scorrere solo da A verso B, ma anche da B verso A,
a differenza delle reti unilaterali.

Gli esempi fatti sui due tipi di reti sono banali, ma più in generale si possono
avere reti logiche unilaterali quali i circuiti combinatori o i circuiti
sequenziali che sono circuiti fatti di porte logiche (reti unilaterali
elementari) e poi abbiamo i circuiti fatti da elementi quali resistori,
condensatori o induttori collegati in serie e/o parallelo per formare circuiti
più complessi.

Il nome rete logica è di norma associato solo a reti che eseguono
un'elaborazione elettronica quali i circuiti combinatori e sequenziale in quanto
elaborano dei dati secondo logica, cioè secondo la logica prevista dal progetto
della rete; si tende invece a distinguere da queste reti i circuiti elettrici
che hanno altre funzioni.

--

Originariamente visto qui: [Dalle porte AND OR NOT al sistema
calcolatore](http://www.edizioniets.com/scheda.asp?n=9788846743114).

