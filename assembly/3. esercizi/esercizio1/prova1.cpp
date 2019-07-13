/**
 * File: prova1.cpp
 *       Developer harness test for esercizio1.s.
 *
 *       Compile using:
 *          g++ esercizio1.s prova1.cpp -o prova1
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 12/07/19.
 */

#include <iostream>

using namespace std;

struct sc
{
    int a[8];
    int b[8];
};

// implemented in esercizio1.s
extern "C" void fz(sc* p, sc s);

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
    sc stt1 =
    {
        {0, 2, 4, 4, 5, 6, 7, 8},
        {11, 12, 13, 14, 15, 16, 17, 18}
    };

    sc stt2 =
    {
        {1, 2, 3, 4, 5, 6, 8, 8},
        {10, 20, 30, 40, 50, 60, 70, 80}
    };

    sc* pu = &stt2;

    cout << "Stampa della struttura stt1 prima della chiamata di fz:" << endl;
    cout << "Campo a = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt1.a[i] << ' ';
    }
    cout << endl;
    cout << "Campo b = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt1.b[i] << ' ';
    }
    cout << endl;

    cout << "Stampa della struttura stt2 prima della chiamta di fz:" << endl;
    cout << "Campo a = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt2.a[i] << ' ';
    }
    cout << endl;
    cout << "Campo b = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt2.b[i] << ' ';
    }
    cout << endl;

    // chiamata della funzione fz
    fz(pu, stt1);

    cout << "Stampa della struttura stt2 dopo la chiamta di fz:" << endl;
    cout << "Campo a = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt2.a[i] << ' ';
    }
    cout << endl;
    cout << "Campo b = ";
    for (int i = 0; i < 8; i++)
    {
        cout << stt2.b[i] << ' ';
    }
    cout << endl;

    return 0;
}

