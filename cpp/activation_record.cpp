/**
 *  File: activation_record.cpp
 *        Listed below is a small example program. The purpose of this program
 *        is to demonstrate how activation records work; the program is
 *        not intended to serve as a good example of style or program
 *        organization.
 *
 *        There are comments in the program marking point 1, point 2, etc. For
 *        example, the program is at point 1 just beforethe statement i = -8;
 *        is executed. The program passes through these points in order.
 *        Diagrams showing what the stack looks like at each of these are
 *        shown further down in this document. If you are using a Web browser
 *        to read this document, you can use hypertext links to jump back and
 *        forth between the listing and the diagrams.
 *
 *        Originally seen at:
 *        https://people.ucalgary.ca/~norman/encm501winter2016/assignments/enc
 *        m339f15lab1/Activation%20Records%20and%20the%20Stack.pdf
 *
 *  Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/05/19.
 */

#include <iostream>

using namespace std;

void print_facts(int num1, int num2);
int max_of_two(int j, int k);
double avg_of_two(int c, int d);

int main(void)
{
    int i;int j;
    /* point  1 */
    i = -8;
    j = 7;
    /* point  2 */
    print_facts(i, j);
    /* point 10 */
    return 0;
}

void print_facts(int num1, int num2)
{
    int larger;
    double the_avg;
    /* point  3 */
    larger = max_of_two(num1, num2);
    /* point  6 */
    the_avg = avg_of_two(num1, num2);
    /* point  9 */
    printf("For the two integers %d and %d,\n", num1, num2);
    printf("the larger is %d and the average is %g.\n",larger, the_avg);
}

int max_of_two(int j, int k)
{
    /* point  4 */
    if (j < k)j = k;
    /* point  5 */
    return j;
}

double avg_of_two(int c, int d)
{
    double sum;
    /* point  7 */
    sum = c + d;
    /* point  8 */
    return (c + d) / 2.0;
}

