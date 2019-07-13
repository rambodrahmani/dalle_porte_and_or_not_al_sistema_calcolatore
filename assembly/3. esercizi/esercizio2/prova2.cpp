/**
 * File: prova2.cpp
 *       Developer harness test for esercizio2.s.
 *
 *       Compile using:
 *          g++ -g -m32 -no-pie esercizio1.s prova1.cpp
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/07/19.
 */

#include <iostream>

using namespace std;

struct miastr
{
    int a;
    int vv[5];
};

// implemented in esercizio2.s
extern "C" miastr ff(miastr);

/**
 * Developer harness test.
 *
 * @param   argc    command line arguments counter.
 * @param   argv    command line arguments.
 *
 * @return          execution exit code.
 */
int main(int argc, char * argv[])
{
    miastr stru = {5, {1, 2, 3, 0, 5}}, str1;

    str1 = ff(stru);

    cout << "Stampa della struttura stru:" << endl;
    cout << "Campo a = " << stru.a << endl;
    cout << "Campo vv = ";
    for (int i = 0; i < 5; i++)
    {
        cout << stru.vv[i] << ' ';
    }
    cout << endl;

    cout << "Stampa della struttura str1:" << endl;
    cout << "Campo a = " << str1.a << endl;
    cout << "Campo vv = ";
    for (int i = 0; i < 5; i++)
    {
        cout << str1.vv[i] << ' ';
    }
    cout << endl;

    return 0;
}

