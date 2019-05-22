/**
 *
 *  File:   codifica3b.cpp
 *          Terza nuova versione del programma codifica.
 *
 *          In Assembly, oppositamente a quanto si fa in C++, l'identificatore
 *          .global e' obbligatorio mentre quello .extern e' opzionale. In un
 *          file C++, gli identificatori delle variabili definite al di fuori
 *          delle funzioni e gli identificatori delle funzioni sono
 *          implicitamente globali (la dichiarazione .global puo' quindi essere
 *          omessa). In un file C++ si posso riferire identificatori definiti
 *          in altri file, purche' siano esplicitamente dichiarati esterni e
 *          siano globali nei file dove sono definiti. Per le funzioni la parola
 *          chiave extern puo' essere omessa, ma resta obbligatoria la
 *          dichiarazione e siano globali nei file dove sono definiti.
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
 *          - Sviluppo della versione C++ numero 3:
 *              g++ codifica3a.cpp codifica3b.cpp -o codifica3
 *              ./codifica3
 *
 *          - Sviluppo della versione mista numero 4:
 *              g++ codifica4a.cpp codifica4.s -o codifica4
 *              ./codifica4
 *
 *          - Sviluppo della versione mista numero 5:
 *              g++ codifica5a.s codifica5b.cpp -o codifica5
 *              ./codifica5
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

