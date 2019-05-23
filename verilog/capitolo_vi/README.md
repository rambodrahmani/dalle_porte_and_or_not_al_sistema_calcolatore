# Capitolo VI - Struttura Di Un Semplice Calcolatore

I calcolatori sono macchine complesse che compiono eleborazioni su dati e la cui
struttura fisica (hardware) e' costituita da diversi moduli, ognuno dei quali e'
in grado di eseguire un insieme specifico di funzioni. Per poter comprendere
fino in fondo la potenzialita' di un qualunque calcolatore, e' tuttavia di
fondamentale importanza studiarne almeno uno, percorrendo un cammino che inizi
dalle sue specifiche funzionali e che termini con la progettazione (almeno a
livello di linguaggio Verilog) di tutti i moduli. In quest'ottica faremo
riferimento a un calcolatore semplice, dotato di un processore e di interfacce
che abbiano una valenza didattica.

Il processore che introdurremo e che chiameremo sEP8 (8 bit simple Educational
Processor), e' in grado di indirizzare una memoria da 16MByte e di elaborare
essenzialmente dati a 8 bit (byte); nell'eseguire le istruzioni aritmetiche,
esso lavora in base 2, interpretando i dati come numeri naturali oppure come
numeri interi in complemento a due. Le interfacce che analizzeremo sono le
interfacce parallele (rientrano in questa classe le "vecchie" interfacce per le
stampanti), le interfacce seriali start/stop (rientranoin questa classe le
"vecchie" interfacce per il mouse, per la tastiera e per il modem) e le
interfacce per la conversione digitale/analogico e analogico/digitale.
Introdurremo poi (una versione semplificata del) la memoria video, mentre non
entreremo nei dettagli della struttura dell'adattatore grafico, che e' uno dei
circuiti piu' complessi di un calcolatore. Per le stesse motivazioni, cioe' per
voler trattare solo interfacce che abbiano una valenza didattica e che possano
essere analizzate fino all'ultimo porta elementare, non prenderemo in
considerazione le interfacce per le memoria di massa, le interfacce per le
connessioni alle reti locale e le interfacce per i dispositivi che rispettano lo
standard USB.

--

Originariamente visto qui: [Dalle porte AND OR NOT al sistema
calcolatore](http://www.edizioniets.com/scheda.asp?n=9788846743114).

