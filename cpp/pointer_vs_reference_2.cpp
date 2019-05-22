/**
 *
 *  File:   pointer_vs_reference_2.cpp
 *          Passing by pointer Vs Passing by Reference in C++.
 *
 *          In C++, we can pass parameters to a function either by pointers or
 *          by reference. In both the cases, we get the same result. So the
 *          following questions are inevitable; when is one preferred over the
 *          other? What are the reasons we use one over the other?
 *
 *          Passing by Reference: C++ program to swap two numbers using pass by
 *                                reference.
 *
 *  Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 22/05/19.
 *
 */

#include <iostream>

using namespace std;

void swap(int* x, int* y)
{
    // copy the value pointer by x in z
    int z = *x;

    // copy the value pointed by y in x
    *x = *y;

    // copy the value of z in y
    *y = z;
}

void swap(int& x, int& y)
{
    // copy the value referenced by x in z
    int z = x;

    // copy the value referenced by y in the variable referenced by y
    x = y;

    // copy the value of z in the variable referenced by y
    y = z;
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
    // declare two interger variables
    int a = 45, b = 35;

    // print the value of a and b
    cout << "Before Swap\n";
    cout << "a = " << a << " b = " << b << "\n";

    // swap the values of a and b
    swap(a, b);

    // print the new values of a and b
    cout << "After Swap with pass by pointer\n";
    cout << "a = " << a << " b = " << b << "\n";
}

/*
 * Difference in Reference variable and pointer variable.
 *
 * References are generally implemented using pointers. A reference is same
 * object, just with a different name and reference must refer to an object.
 * Since references can’t be NULL, they are safer to use.
 *
 * 1. A pointer can be re-assigned while reference cannot, and must be assigned
 *    at initialization only.
 * 2. A pointer can be assigned NULL directly, whereas reference cannot.
 * 3. Pointers can iterate over an array, we can use ++ to go to the next item
 *    that a pointer is pointing to.
 * 4. A pointer is a variable that holds a memory address. A reference has the
 *    same memory address as the item it references.
 * 5. A pointer to a class/struct uses ‘->'(arrow operator) to access it’s
 *    members whereas a reference uses a ‘.'(dot operator).
 * 6. A pointer needs to be dereferenced with * to access the memory location it
 *    points to, whereas a reference can be used directly.
 */

/*
 * Usage in parameter passing:
 * References are usually preferred over pointers whenever we don’t need
 * “reseating”.
 *
 * Overall, Use references when you can, and pointers when you have to. But if
 * we want to write C code that compiles with both C and a C++ compiler, you’ll
 * have to restrict yourself to using pointers.
 *
 * This article is contributed by Rohit Kasle.
 * https://www.geeksforgeeks.org/passing-by-pointer-vs-passing-by-reference-in-c
 */

