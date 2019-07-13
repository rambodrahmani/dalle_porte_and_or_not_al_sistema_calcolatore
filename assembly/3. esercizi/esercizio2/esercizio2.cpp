/**
 * File: esercizio2.cpp
 *       CPP code to be translated into Assembly code.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/07/19.
 */

struct miastr
{
    int a;
    int vv[5];
};

extern "C" miastr ff(miastr stru)
{
    int i;
    miastr lav;

    lav.a = 0;

    for (i = 0; i < 5; i++)
    {
        lav.a += stru.vv[i];
    }

    i = 0;

    while (stru.vv[i] > 0 && i < 5)
    {
        lav.vv[i] = stru.a;
        i++;
    }

    for (; i < 5; i++)
    {
        lav.vv[i] = 0;
    }

    return lav;
}

