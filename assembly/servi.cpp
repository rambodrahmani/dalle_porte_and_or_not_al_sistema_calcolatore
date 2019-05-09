/**
 *
 *  File:   servi.cpp
 *          I/O in Assembly come in C++. Il comando g++ come sappiamo puo'
 *          essere usato per assemblare e collegare con un solo comando
 *          piu' file assembly. E' inoltre possibile utilizzarlo per collegare
 *          librerie scritte in C++.
 *
 *          La presente libreria permette di effettuare operazioni di I/O in
 *          Assembly come se fossimo in C++ (maggiormente orientato al carattere
 *          o formattato).
 *
 *          La dichiarazione extern "C" utilizzata lascia inalterato in Assembly
 *          l'identificatore della funzione C++ (il compilatore C++ si comporta,
 *          in questo caso, come il compilatore C). Se si vuole questo, la
 *          dichiarazione e' obbligatoria.
 *
 *  Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *          Created on 08/05/2019.
 *
 */

#include <iostream>

using namespace std;

/**
 * Legge da tastiera il carattere successivo (anche uno spazio bianco) e pone la
 * sua codifica ASCII in AL.
 */
extern "C" char leggisucc()
{
    char c;
    cin.get(c);
    return c;
}

/**
 * Salta eventuali spazi bianchi, legge da tastiera il successivo carattere
 * diverso da spazio bianco e pone la sua codifica ASCII in AL.
 */
extern "C" char leggichar()
{
    char c;
    cin >> c;
    return c;
}

/**
 * Salta eventuali spazi biachi, legge da tastiera una sequenza di caratteri
 * congruente con la rappresentazione in base dieci di un intero, la converte in
 * un intero base due che pone in EAX.
 */
extern "C" int leggiint()
{
    int i;
    cin >> i;
    return i;
}

/**
 * Salta eventuali spazi bianchi, legge da tastiera un sequenza di caratteri
 * congruente con la rappresentazione in base 16 di un naturale e la converte in
 * un naturale in base due che pone in EAX.
 */
extern "C" unsigned leggiex()
{
    unsigned u;
    cin >> hex >> u >> dec;
    return u;
}

/**
 * Scrive su video il carattere la cui codifica ASCII si trova in DIL.
 */
extern "C" void scrivisucc(char c)
{
    cout.put(c);
}

/**
 * Scrive su video il carattere contenuto in DIL seguito dal carattere spazio.
 */
extern "C" void scrivichar(char c)
{
    cout << c << ' ';
}

/**
 * Converte l'intero espresso in base due contenuto in EDI in una sequenza di
 * caratteri che rappresentano cifre in base dieci, e scrive tale sequenza su
 * video.
 */
extern "C" void scriviint(int i)
{
    cout << i << ' ';
}

/**
 * Converte il naturale espresso in base due contenuto in EDI in una sequenza di
 * cartteri che rappresentano cifre in base sedici, e scrive tale sequenza su
 * video.
 */
extern "C" void scriviex(unsigned int u)
{
    cout << hex << u << dec << ' ';
}

/**
 *
 */
extern "C" void nuovalinea()
{
    cout << endl;
}

/**
 * Traduzione in Assembly di un file C++.
 *
 * - Il comando g++, con l'opzione -S, effettua la traduzione in Assembly di un
 *   file con estensione cc o cPP, producendo un nuovo file con lo stesso nome
 *   ed estensione s;
 *
 * - nel caso di questo file, il comando e' cosi' fatto: g++ -S servi.cpp;
 *
 * - il file servi.s ottenuto contiene sottoprogrammi in Assembly con lo stesso
 *   identificatore e funzionalmente equivalenti a quelli C++;
 *
 * - il file servi.s puo' essere incluso nei file Assembly che effettuano
 *   operazioni di I/O;
 */

/**
 * Le funzioni C++ salvano e ripristinano il contenuto di alcuni fra i registri
 * utilizzati (i cosiddetti registri invarianti) e non di tutti quelli che
 * potrebbero utilizzare.
 *
 * Registri invarianti: RSP, RBP, RBX, R12-R15.
 *
 * Pertanto un programma Assembly, se utilizza un sottoprogramma contenuto nel
 * file servi.s, non deve lasciare informazioni che non devono essere modificate
 * in registri non invarianti.
 */

