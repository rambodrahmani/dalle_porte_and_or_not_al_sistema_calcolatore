/**
 * File: esercizio1.cpp
 *       CPP code to be translated into Assembly code.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/07/19.
 */

struct sc
{
    int a[8];
    int b[8];
};

extern "C" void fz(sc* p, sc s)
{
    int i;

    for (i = 0; i < 5; i++)
    {
        if (p->a[i] == s.a[i])
        {
            p->b[i] = s.b[i];
        }
    }

    for (i = 5; i < 8; i++)
    {
        p->b[i] *= 2;
    }
}

