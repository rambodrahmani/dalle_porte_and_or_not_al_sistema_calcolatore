/**
 * File: codifica6a.cpp
 *       Reads the input chars from the keyboard and prints out the
 *       corresponding ASCII char binary code for each input.
 *
 *       Compile using:
 *          g++ codifica6a.cpp codifica6b.cpp -o codifica6
 *
 *       or using:
 *          g++ codifica6a.cpp codifica7b.s -o codifica8
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 11/07/19.
 */

#include <iostream>

using namespace std;

extern "C" void esamina(char aa, char bb[]);

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
    // each char is coded in ASCII using 8 bits
    char kappa[8];

    // input char
    char cc;

    // array loop index
    int i;

    // infinite loop
    for (;;)
    {
        // read an input character and store it in cc
        cin.get(cc);

        // check if the new line character was read
        if (cc == '\n')
        {
            // exit loop in that case
            break;
        }

        // print the character followd by a blank space
        cout << cc << " ";

        // call esamina
        esamina(cc, kappa);

        // loop through the kappa[] array
        for (i = 0; i < 8; i++)
        {
            // print element i in the kappa array
            cout << kappa[i];
        }

        // print a new line
        cout << endl;
    }

    // return with no errors
    return 0;
}

