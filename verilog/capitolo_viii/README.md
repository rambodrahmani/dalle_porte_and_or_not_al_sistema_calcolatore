# Capitolo VIII - Un Semplice Meccanismo Di Protezione

E' sotto gli occhi di tutti come sia in atto una guerra tra i cosiddetti hacker
e coloro che scrivono e mantengono il software di sistema. Questi ultimi possono
trovare un aiuto in alcuni meccanismi hardware di protezione di cui i processori
sono normalmente dotati. Tali meccanismi, unitamente a un'accurata scrittura del
software stesso, alzano il livello di sicurezza, anche se la guerra di cui sopra
non sara' mai definitivamente vinta da nessuno dei due contendenti.

In quanto segue, introdurremo un sistema di protezione hardware molto semplice,
che s'ispira liberamente al meccanismo di protezione presente nella storica
famiglia di processori Zilog Z8000. Il processore e' dotato di una architettura
a 16 bit. Alcune versioni adottano un registro a 7 bit per gestire la
segmentazine della memoria che estende lo spazio di indirizzamento a 8 MB. Il
chip contiene 16 registri a 16 bit ma sono presenti alcune istruzioni che li
impiegano a 8, 16, 32 e 64 bit. Il set di registri e' completamente ortogonale
(cio' significa che ogni registro puo' essere usato nella stessa maniera e con
le stesse istruzioni degli altri). I registri 14 e 15 sono generalmente
utilizzati per gestire lo stack: il primo identifica il segmento dello stack, il
secondo come puntatore. Il chip opera sia in modalita' utente che in modalita'
kernel e, come lo Z80, anche lo Z8000 include internamente la circuiteria per
l'aggiornamento della DRAM. Nonostante queste interessanti caratteristiche
rispetto ai processori del tempo, lo Z8000 non risultava particolarmente veloce
ed aveva alcuni problemi, finendo lentamente con l'essere soppiantato dai
processori della famiglia x86.

Questo meccanismo di protezione e' basato su due modi di funzionamento del
processore, noti come modo sistema e modo utente. Quando il processore opera in
modo sistema, puo' eseguire una qualunque delle istruzioni del suo set e puo'
accedere a qualunque locazione di memoria. Quando invece il processore opera in
modo utente, non puo' eseguire alcune istruzioni e non puo' accedere all'intera
memoria; il tentativo di compiere azioni non permesse si traduce automaticamente
nella richiesta di apposite interruzioni interne. Il meccanismo di protezione
prevede inoltre la possibilita' di gestire due pile separate, di cui una
accessibile esclusivamente in modo sistema. La terminologia introdotta indica
chiaramente, fin da ora, che il meccanismo di protezione ha un senso solo se il
softwre di sistema viene eseguito con il processore operante in modo sistema e
se i programmi degli utenti vengono eseguiti con il processore operante in modo
utente.

Le istruzioni eseguibili esclusivamente in modo sistema, note come istruzioni
privilegiate, sono poche. Quando il processore opera in modo utente e preleva
dalla memoria una di esse, un'apposita circuiteria richiede automaticamente
un'interruzione interna (interruzione per tentata esecuzione di istruzione
privilegiata), che noi supporremo essere di tipo 5.

Fra le istruzioni esaminate finora, sono istruzioni privilegiate: i)
l'istruzione HLT, la cui esecuzione blocca il processore; ii) le istruzioni IN e
OUT, la cui esecuzione puo' manomettere le interfacce; iii) l'istruzione LIDTP
la cui esecuzione agisce su un registro il cui contenuto e' estremamente
delicato; iv) le istruzioni CLI e STI, la cui esecuzione interagisce con il
mascheramento/smascheramento delle richieste di interruzione esterne; v)
l'istruzione IRET, per motivi che vedremo in seguito. Per completare il
meccanismo di protezione andranno poi introdotte due nuove istruzioni
privilegiate.

Non e' invece privilegiata l'istruzione  INT, che anzi trova nella presenza del
maccanismo di protezione la sua vera funzione. L'esecuzione dell'istruzione INT,
opportunamente rivisitata, permettera' infatti al processore di passare dal modo
utente al modo sistema in modo che siano utilizzabili, in ogni contesto, i
sottoprogrammi di servizio appartenenti al software di sistema. Si considerino
ad esempio le procedure per l'ingresso e l'uscita dati a controllo di programma
introdotti nel capitolo VI. Poiche' esse contengono istruzioni privilegiate, non
possono essere eseguite in modo utente. Vanno quindi rivisitate, organizzate
come sottoprogrami di servizioni di interruzione messe in esecuzione utilizzando
apposite istruzioni INT.

Anche l'istruzione IRET, con cui terminano i sottoprogrammi di servizio delle
interruzioni, andra' opportunamente rivisitata. La sua esecuzione dovra',
infatti, far tornare il processore a operare nel modo in cui operava prima
dell'accettazione della richiesta di interruzione stessa.

## La memoria di sistema
La porzione di memoria a cui il processore non puo'
accedere mentre opera in modo utente, e detta memoria di sistema e rappresenta
un'area protetta a disposizione del software di sistema.

Noi ammetteremo che la memoria di sistema sia costituita dalle 2M locazioni il
cui indirizzo inizia con 000 e che, per non complicare troppo la descrizione in
Verilog del processore, siano inibiti, quando esso opera in modo utente,
esclusivamente agli accessi in scrittura. Piu' in dettaglio noi ammetteremo che
quando il processore opera in modo utente e tenta di accedere in scrittura alla
memoria di sistema, un'apposita circuiteria richieda automaticamente
un'interruzione (interruzione per violazione della memoria protetta) e che tale
interruzione sia del tipo 4.

## La pila di sistema e la pila utente

Come ulteriore elemento di separazione tra i modi sistema e utente, doteremo il
processore di un supporto hardware per differenziare la pila utilizzabile in
modo sistema (pila di sistema) da quella utilizzabile in modo utente (pila
utente). Tale supporto consiste: i) nel dotare il processore id un nuovo
registro a 24 bit, chiamiamolo PMSP (Previous Mode Stack Pointer), da affianco
al registro SP; ii) nel prevedere una nuova istruzione privilegiata EXCHSP
(EXCHange Stack Pointers) che permettera' di effettuare uno scambio di contenuto
tra il registro SP e il registro PMSP e quindi, fra l'altro, di inizializzare il
registro PMSP; iii) nel prevedere comunque, a ogni passaggio fra moto sistema e
modo utente e viceversa, uno scambio automatico di contenuto tra il registro SP
e il registro PMSP. Sara' poi compito del software di sistema allocare la pila
di sistema nella memoria (protetta) di sistema. Quindi, long story short,
all'avvio vengono allocate due pile (una nella memoria protetta, una nella
memoria utente). PMSP e SP contengono ad ogni istante l'indirizzo alla prima
locazione della pila di sistema e alla prima locazione della pila di sistema.
Scambiando il contenuto di questi due registri ogni volta che vi e' un passaggio
tra queste due modalita', ho la possibilita' di avere due pile distinte.

# Regole per un passaggio sicuro da modo sistema a modo utente e viceversa

Il modo di funionamneto del processore e' stabilito dal contenuto di un nuovo
elemento del registro del flag F, detto flag U/S (User/System Flag). Noi
converremo che il processore operi in modo sistema quando il contenuto di tale
flag e' 0 e in modo utente quando il contenuto di tale flag e' 1. Le regole per
un passaggio sicuro da modo sistema a modo utente e viceversa sono le seguenti:
i) il processore si porta in modo sistema al reset iniziale e questo implica che
esso inizia ad eseguire il programma bootstrap in modo sistema; ii) il
processore si porta da modo sistema a modo utente eseguendo una nuova e apposita
istruzione privilegiata, che chiameremo STUM (Set Use Mode); iii) una volta in
modo utente il processore puo' portarsi in modo sistema esclusivamente
accettando una richiesta di interruzione (esterna, software o interna), ma
all'atto dell'esecuzione dell'istruzione IRET ritorna nello stato in cui era
prima dell'accettazione della stessa richiesta di interruzione.

--

Originariamente visto qui: [Dalle porte AND OR NOT al sistema
calcolatore](http://www.edizioniets.com/scheda.asp?n=9788846743114).

