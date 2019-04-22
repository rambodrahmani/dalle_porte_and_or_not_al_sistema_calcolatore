# Capitolo II - Reti Combinatorie

Con il termine di rete logica combinatoria (in inglese, combinational logic
network) si definisce un circuito elettronico digitale realizzato mediante
dispositivi elettronici in grado di svolgere funzioni di porte logiche (AND, OR,
NOT, NAND, NOR, XOR) e caratterizzato dal fatto che i valori di uscita in ogni
istante dipendono unicamente dai valori applicati in tale istante agli ingressi
(ovvero, tali reti non hanno storia del funzionamento passato). Una rete
combinatoria è quindi una rete logica con n ingressi e m uscite dove le uscite
sono funzione degli ingressi, ma non del tempo: cambiano gli ingressi ed
immediatamente cambiano le uscite. Si noti che tale definizione si applica
correttamente solo a reti ideali, poiché implica che non ci siano ritardi fra
una modifica di un valore di ingresso e la corrispondente modifica dei valori di
uscita. A causa dei ritardi differenti nell' "attraversamento" di porte logiche
da parte dei segnali, si possono infatti verificare malfunzionamenti dei valori
delle uscite al variare degli ingressi. Questi malfunzionamenti prendono il nome
di alee. Da un punto di vista realizzativo, il metodo descrittivo più utilizzato
per l'analisi di una rete combinatoria è lo schema logico ovvero il grafo che
rappresenta gli operatori logici utilizzati (cioè le porte logiche) e le loro
interconnessioni reciproche. Dallo schema logico è possibile dedurre il
comportamento funzionale della rete logica: si tratta di applicare una qualsiasi
configurazione di ingresso e ricostruire mediante uso delle definizioni degli
operatori logici il valore corrispondente dell'uscita. Il comportamento di una
rete logica è definito mediante una espressione logica o funzione booleana, cioè
una formula che esprime il valore delle uscite in funzione delle variabili di
ingresso e degli operatori logici che si applicano a tali variabili.

Un metodo diverso di descrizione delle funzioni combinatorie è la tabella delle
verità, cioè elencazione di tutte le possibili configurazioni dei valori di
ingresso (w,x,y,z), associate ai corrispondenti valori assunti dalle uscite (f).

--

Originariamente visto qui: [Dalle porte AND OR NOT al sistema
calcolatore](http://www.edizioniets.com/scheda.asp?n=9788846743114).

