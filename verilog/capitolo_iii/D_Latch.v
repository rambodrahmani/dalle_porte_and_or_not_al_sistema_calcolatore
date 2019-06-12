/**
 * File: D_Latch.v
 *       Il D latch altro non e' che un latch SR preceduto da una rete
 *       combinatoria che permette di comandarlo tramite una variabile
 *       d (data) e una variabile c (control) , traducendo i comandi impartiti
 *       tramite tali variabili nei comandi da impartire al latch SR interno.
 *       
 *       Piu' formalmente, il comportamento del D latch e' il seguente: per
 *       tutto il tempo in cui c e' a 1, il D latch e' in una fase di
 *       inseguimento (cioe' di trasparenza) durante la quale continuamente
 *       memorizza e presenta in uscita il valore della variabile di ingresso
 *       d; quando la variabile c e' a 0, il D latch e' in una fase di
 *       conservazione, in cui mantiene costante il valore della variabile di
 *       uscita q (valore che e' pari all'ultimo valore di d memorizzato).
 *
 *       Per assicurare una corretta memorizzazione dell'ultimo valore di
 *       d presente in ingresso prima che il D latch passi dalla fase di
 *       inseguimento alla fase di conservazione, occorre che tale valore
 *       rimanga costante per qualche tempo prima (Tsetup) e per qualche tempo
 *       dopo (Thold) rispetto alla transizione da 1 a 0 del valore della
 *       variabile c.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 22/05/2019.
 */

module D_Latch(q, qN, s, r, preset_, preclear_, d, c);
    input preset_, preclear_;
    input d, c;
    output s, r;
    output q, qN;

    // d latch additional circuitry
    assign #1 s = d & c;
    assign #1 r = ~d & c;

    // default SR Latch with reset implementation
    assign #2 q = ~((preset_ & r) | qN | ~preclear_);
    assign #2 qN = ~(~preset_ | (s & preclear_) | q);
endmodule

