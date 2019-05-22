/**
 *
 *  File:   parametri_array.cpp
 *
 *  Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/05/19.
 *
 */

#include <iostream>

using namespace std;

/**
 * If the sum of the elements of a is lesser than the sum of the elements of b,
 * it returns b, otherwise it reutrns an array where each element is given by
 * the sum of the corresponding element of a and b.
 */
extern "C" int* due(int a[], int b[], int n)
{
    // array index
    int i;

    // integers
    int s1 = 0;
    int s2 = 0;

    // sum the elements of a into s1
    for (i = 0; i < n; i++)
    {
        s1 = s1 + a[i];
    }

    // sum the elements of b into s2
    for (i = 0; i < n; i++)
    {
        s2 = s2 + b[i];
    }

    // sum the corresponding elements of a and b
    for (i = 0; i < n; i++)
    {
        a[i] = a[i] + b[i];
    }

    // if the sum of the elements of a is lesser than the sum of the elements of
    // b, then a = b, otherwise each element of a is equal to the sum of the
    // corresponding elements of the given arrays
    if (s1 < s2)
    {
        a = b;
    }

    return a;
}

/**
 * Declares two integer arrays, then calls due and finally prints the content of
 * the two arrays.
 */
extern "C" void uno()
{
    // array size
    int n = 5;

    // array index
    int i;

    // pointer to interger array
    int* cr;

    // integer array of size 5
    int ar[n] = {2, 2, 1, 2, 1};

    // integer array of size 5
    int br[n] = {1, 9, 5, 0, 0};

    // call due and store the result in cr
    cr = due(ar, br, n);

    // print integer array ar
    for (i = 0; i < n; i++)
    {
        cout << ar[i] << ' ';
    }
    cout << endl;

    // print integer array br
    for (i = 0; i < n; i++)
    {
        cout << cr[i] << ' ';
    }
    cout << endl;
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
    uno();  // call uno
}

