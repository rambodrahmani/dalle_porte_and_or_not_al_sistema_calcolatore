/**
 *
 * File: Clock.v
 *       This module provides a clock signal which can be used by external
 *       modules to synchronize.
 *       
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 08/06/2019.
 *
 */

module Clock(clock);
    output clock;

    reg CLOCK;

    initial
        begin
            CLOCK = 0;
        end

    always #4 CLOCK = ~CLOCK;

    assign clock = CLOCK;
endmodule

