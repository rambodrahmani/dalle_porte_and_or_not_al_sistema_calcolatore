/**
 * File: codifica6b.cpp
 *       Reads the input chars from the keyboard and prints out the
 *       corresponding ASCII char binary code for each input.
 *
 *       Compile using:
 *          g++ codifica6a.cpp codifica6b.cpp -o codifica6
 *
 *       or using:
 *          g++ codifica7a.s codifica6b.cpp -o codifica9
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 11/07/19.
 */

/**
 * Shifts and checks the most significant bit of the given char and writes '0'
 * or '1' in the given array to obtain its ASCII binary code.
 *
 * @param   aa      the given char
 * @para    bb[]    the array to use to store the ASCII binary code
 */
extern "C" void esamina(char aa, char bb[])
{
    // array index
    int i;

    // loop through the bb[] array
    for (i = 0; i < 8; i++)
    {
        // check if the most significant bit of aa is 0
        if ((aa & 0x80) == 0)
        {
            // place the char '0' in bb[] at position i
            bb[i] = '0';
        }
        // or 1
        else
        {
            // pace the char '1' in bb[] at position i
            bb[i] = '1';
        }

        // shift left of 1
        aa = aa << 1;
    }
}

