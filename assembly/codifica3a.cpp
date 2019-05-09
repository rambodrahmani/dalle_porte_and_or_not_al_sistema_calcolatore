/**
 *
 *  File:   codifica3a.cpp
 *          Terza nuova versione del programma codifica. Equivalente C++ della
 *          versione Assembly contenuta in codifica2a.s.
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

#include "servi.cpp"

extern char alfa;
extern char *beta;

extern void esamina();

char kappa[8];

int main()
{
    char al;

    for (;;)
    {
        al = leggisucc();

        if (al == '\n')
        {
            break;
        }

        scrivichar(al);

        alfa = al;

        beta = &kappa[0];

        esamina();

        for(int i = 0; i < 8; i++)
        {
            scrivisucc(kappa[i]);
        }

        nuovalinea();
    }

    return 0;
}

