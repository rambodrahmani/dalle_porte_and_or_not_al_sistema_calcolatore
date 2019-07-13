/**
 * File: main.cpp
 *       Developer harness test for esercizio2.cpp.
 *
 *       Compile using:
 *          g++ main.cpp -o main
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/07/19.
 */

#include <iostream>
#include "esercizio2.cpp"

using namespace std;

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

