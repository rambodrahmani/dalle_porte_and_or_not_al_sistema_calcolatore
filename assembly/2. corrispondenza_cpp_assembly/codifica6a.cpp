/**
 *
 * File: caso_illustrativo_1.cpp
 *       Caso Illustrativo 1 - File C++.
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 22/05/19.
 *
 */

#include <iostream>

using namespace std;

/**
 * Variabili globali.
 */
int n = 5;
int m = 10;

extern "C" int fai(int h, int& k)
{
    int a;

    // ...

    h = h + 3;

    a = h;

    k = k + 4;

    // ...

    return a;
}

/**
 * Entry point.
 *
 * @param   argc    command line arguments counter.
 * @param   argv    command line arguments.
 *
 * @return          execution exit code.
 */
int main(int argc, char * argv[])
{
    int t;

    // ...

    t = fai(n, m);

    // ...
}

