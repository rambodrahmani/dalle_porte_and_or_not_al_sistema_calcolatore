/**
 *
 * File: Eprom.v
 *       Circuiti di largo utilizzo sono le cosiddette ROM (Read Only Memory),
 *       PROM (Programmable Read Only Memory), EPROM (Erasable Programmable
 *       ROM), EEPROM (Electrically Erasable Programmable ROM) che hanno un
 *       insieme di variabili di ingresso e di uscita molto simili a quelle
 *       delle RAM statiche. Sebbene siano delle reti logiche combinatorie, in
 *       quanto il loro stato di uscita dipende esclusivamente dallo stato di
 *       ingresso presente, le variabili di uscita sono comunque supportate da
 *       porte 3-state. Questi tipi di circuiti vengono infatti utilizzati,
 *       insieme alle RAM, per implementare lo spazio di memoria dei
 *       calcolatori, venendone a rappresentare la parte non volatile.
 *       Usando una termiologia simile a quella che si usa per le RAM, si dice
 *       che le ROM, PROM, EPROM sono costituite da locazioni indirizzabili,
 *       ognuna delle quali contiene un dato indelebile durante la normale
 *       fase operativa e accessibile in sola lettura. I generatori di
 *       costante GdC presentano in uscita un valore non modificabile durante
 *       il normale funzionamento; la tecnologia con cui sono realizzati
 *       determina la natura del circuito, cioe' se i bit contenuti nelle
 *       locazioni possono essere modificati agendovi con particolari
 *       apparecchiature (PROM, EPROM, EEPROM) o sono statibiliti all'atto
 *       della construzione e quindi immodificabili per sempre (ROM).
 *       
 *       A livello di linguaggio Verilog, si puo' dare per le memorie read
 *       only una descrizione che riguarda esclusivamente il loro
 *       funzionamento operativo, come esemplificato in quanto segue,
 *       realtivamente a una memoria da 64Kx8.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 23/05/2019.
 *
 */

module Eprom(d3_d0, a22_a0, s_, mr_, mw_);
endmodule

