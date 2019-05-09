/**
 *
 *  File:   codifica3b.cpp
 *          Terza nuova versione del programma codifica.
 *
 *          Compilato usando: g++ codifica3a.cpp codifica3b.cpp -o codifica3
 *
 *          Esempio di esecuzione:
 *
 *          [rambodrahmani@rr-workstation assembly]$ ./codifica3
 *          rambod
 *          r 01110010
 *          a 01100001
 *          m 01101101
 *          b 01100010
 *          o 01101111
 *          d 01100100
 *
 *  Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 09/05/2019.
 *
 */

char alfa;

char *beta;

void esamina()
{
    for(int i = 0; i < 8; i++)
    {
        if ((alfa & 0x80) == 0)
        {
            *(beta + i) = '0';
        }
        else
        {
            *(beta + i) = '1';
        }

        alfa = alfa << 1;
    }
}

