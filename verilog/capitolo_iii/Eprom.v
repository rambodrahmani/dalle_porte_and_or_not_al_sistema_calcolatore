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

module Eprom(d7_d0, a15_a0, s_, mr_);
    input [15:0] a15_a0;
    input s_, mr_;

    output [7:0] d7_d0;

    wire b;
    assign b = ({s_, mr_} == 'B00)?1:0;

    assign d7_d0 = (b == 1) ? F(a15_a0):'HZZ;

        function [7:0] F;       // function F returns an 8-bit value
            input [15:0] a15_a0;
            casex(a15_a0)       // here we hard code the EPROM functiontalities
                'H0000 : F = 'B00000000;
                'H0001 : F = 'B00010000;
                'H0010 : F = 'B00100000;
                'H0011 : F = 'B00110000;
                'H0100 : F = 'B01000000;
                'H0101 : F = 'B01010000;
                'H0110 : F = 'B01100000;
                'H0111 : F = 'B01110000;
                'H1000 : F = 'B10000000;
                'H1001 : F = 'B10010000;
                'H1010 : F = 'B10100000;
                'H1011 : F = 'B10110000;
                'H1100 : F = 'B11000000;
                'H1101 : F = 'B11010000;
                'H1110 : F = 'B11100000;
                'H1111 : F = 'B11110000;
            endcase
        endfunction
endmodule

