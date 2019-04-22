/**
 *
 * File:    Rete_Combinatoria_2.v
 *          Qualora lo si ritenga vantaggioso ai fini della leggibilita', si
 *          puo' evitare di inserire la descrizione delle singole leggi Fm
 *          nello statement assign, ma trattarle globalmente come un'unica
 *          legge F riferibile in tale statement, previo incapsulamente in un
 *          opportuno costrutto function...endfunction.
 *
 * Author:  Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/04/2019.
 *
 */

module Rete_Combinatoria_2(x2, x1, x0, z1, z0);
    input x2, x1, x0;
    output z1, z0;

    assign {z1, z0} = F(x2, x1, x0);

	/**
	 * Con riferimento alla tabella di verita' introdotto per
	 * Rete_Combinatoria.v, la descrizione della legge F che piu' si avvicina ad
	 * essa e' data dalla seguente implementazione.
	 */
	function [1:0] F;
	    input x2, x1, x0;
	
	    // 1
	    casex({x2, x1, x0})
	        'B000 : F='B00;
	        'B001 : F='B01;
	        'B011 : F='B10;
	        'B010 : F='B10;
	        'B100 : F='B11;
	        'B101 : F='B11;
	        'B111 : F='B00;
	        'B110 : F='B00;
	    endcase
	endfunction

	/**
	 * Anche ora e' possibile effettua un compattazione della descrizione,
	 * introducend questa volta esplicitamente, la parola chiave default
	 * e riscrivendo il costrutto function...endfunction nella forma seguente:
	 */
	function [1:0] F2;
	    input x2, x1, x0;
	
	    casex({x2, x1, x0})
	        'B001   : F2='B01;
	        'B011   : F2='B10;
	        'B010   : F2='B10;
	        'B100   : F2='B11;
	        'B101   : F2='B11;
	        default : F2='B00;
	    endcase
	endfunction

	/**
	 * Volendo compattare ulteriormente, si puo' ricorrere al concetto "quale
	 * che sia il valore di una variabile di ingresso" inserendo esplicitamente
	 * il simbolo ? al posto del valore della variabile di ingresso e
	 * riscrivendo il precedente costrutto function...endfunction nella forma
	 * che segue (il simbolo ? sta al posto della variabile x0):
	 */
	function [1:0] F3;
	    input x2, x1, x0;
	
	    casex({x2, x1, x0})
	        'B001   : F3='B01;
	        'B01?   : F3='B10;
	        'B10?   : F3='B11;
	        default : F3='B00;
	    endcase
	endfunction
endmodule

// 1
/*
 * The Verilog case statement is a convenient structure to code various logic
 * like decoders, encoders, onehot state machines. Verilog defines three
 * versions of the case statement: case, casez, casex. Not only is it easy to
 * confuse them, but there are subtleties between them that can trip up even
 * experienced coders.
 *
 * The plain case statement is simple but rigid—everything must be explicitly
 * coded. In some situations, you may want to specify a case item that can
 * match multiple case expressions. This is where “wildcard” case expressions
 * casez and casex come in. casez allows “Z” and “?” to be treated as don’t
 * care values in either the case expression and/or the case item when doing
 * case comparison. For example, a case item 2’b1? (or 2’b1Z) in a casez
 * statement can match case expression of 2’b10, 2’b11, 2’b1X, 2’b1Z. It is
 * generally recommended to use “?” characters instead of “Z” characters in the
 * case item to indicate don’t care bits.
 * 
 * While wildcard case comparison can be useful, it also has its dangers.
 * Imagine a potentially dangerous casez statement where the case expression is
 * a vector and one bit resolves to a “Z”, perhaps due to a mistakenly
 * unconnected input. That expression will match a case item with any value for
 * the “Z” bit! To put in more concrete terms, if the LSB of irq in the above
 * code snippet is unconnected such that the case expression evaluates to
 * 3’b00Z, the third case item will still match and int0 will be set to 1,
 * potentially masking a bug!
 *
 * Now that we understand the usage and dangers of casez, it is straight-forward
 * to extend the discussion to casex. casex allows “Z”, “?”, and “X” to be
 * treated as don’t care values in either the case expression and/or the case
 * item when doing case comparison. That means, everything we discussed for
 * casez also applies for casex, plus “X” is now also a wildcard.
 */

