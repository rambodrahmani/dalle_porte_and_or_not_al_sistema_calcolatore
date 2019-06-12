/**
 * File: D_flip-flop_7474.v
 *       Il piu' diffuso D flip-flop non trasparente e' uno storico circuito,
 *       che fu classificato a suo tempo come D flip-flop 7474 e che rientra
 *       nella categoria dei D flip-flop positive-edge-triggered. Trattasi di
 *       una rete sequenziale asincrona che, al pari degli altri D flip-flop,
 *       ha due variabili di ingresso d e p e una variabile di uscita q e che
 *       deriva la sua non trasparenza dal rispetto delle seguenti specifiche:
 *       Quando la variabile p trasnisce da 0 a 1 il flip-flop entra in una
 *       brevissima fase in cui campiona il valore della variabile d da cui
 *       esce automaticamente e indipendentemente dal fatto che la variabile
 *       p continui a rimanere a 1 o torni a 0. Il flip-flop mantiene
 *       inalterato il valore della variabile di uscita 1 sia quando p vale
 *       0 sia quando, pure essendo p trasnsitata a 1, e' in corso la fase di
 *       campionamento. Terminata la fase di campionamento, il flip-flop
 *       adegua il valore della variabile di uscita q a quel valore della
 *       variabile di ingresso d che e' stato campionato, dopo di che entra in
 *       una fase di completa inattivita', in cui mantiene constante il valore
 *       della variabile di uscita q e da cui esce soltanto alla successiva
 *       transizione da 0 a 1 di p.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/06/2019.
 */

`include "Clock.v"
`include "Latch_SR.v"

module D_flip_flop_7474(q, qN, d, p);
    input d, p;
    output q, qN;

    wire c;
    Clock clock(c);

    assign p = c;

    wire r0, s0, y0, yN0;
    Latch_SR Latch_SR_0(y0, yN0, s0, r0);

    wire r1, s1, y1, yN1;
    Latch_SR Latch_SR_1(y1, yN1, s1, r1);

    assign #2 r0 = ~p;
    assign #2 s0 = ~(~p | d | y1);

    assign #4 r1 = ~p;
    assign #4 r1 = ~(~p | ~d | y0);

    wire y2, yN2;
    Latch_SR Latch_SR(y2, yN2, y1, y0);

    assign #6 q = y2;
    assign #6 qN = yN2;
endmodule

