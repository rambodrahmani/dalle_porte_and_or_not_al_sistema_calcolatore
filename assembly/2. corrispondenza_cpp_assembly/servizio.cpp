/**
 * File: servizio.cpp
 *       I/O in Assembly come in C++. Il comando g++ come sappiamo puo'
 *       essere usato per assemblare e collegare con un solo comando
 *       piu' file assembly. E' inoltre possibile utilizzarlo per collegare
 *       librerie scritte in C++.
 *
 *       Il file servizio.s (ottenibile da questo file cpp con il comando
 *       g++ -S servizio.cpp) contiene sottoprogrammi Assembly per leggere e
 *       scrivere caratteri, numeri naturali (in base sedici) e numeri interi 
 *       in base dieci) e numeri reali. Tali sottoprogrammi sono stati ottenuti
 *       utilizzando la libreria di I/O del C++, che va pertanto collegata.
 *       L'utilizzo del file servizio.s e' particolarmente indicato quando si
 *       sviluppa un programma con il comando g++, perche' in questo caso il
 *       collegamento con le librerie C++ viene ottenuto automaticamente.
 *       Notare che tale file non puo' essere utilizzato se nel comando g++
 *       compare l'opzione -nostdlib.
 *
 *       La dichiarazione extern "C" utilizzata lascia inalterato in Assembly
 *       l'identificatore della funzione C++ (il compilatore C++ si comporta,
 *       in questo caso, come il compilatore C). Se si vuole questo, la
 *       dichiarazione e' obbligatoria.
 *
 *       Compilazione ed esecuzione dei test con
 *          g++ -S servizio.cpp && g++ servizio_test.s -o servizio_test
 *          ./servizio_test
 *
 * Author: Rambod Rahmani <rambodrahmani@autistici.org>
 *         Created on 16/06/2019.
 */

#include <iostream>

using namespace std;

/*
 * Anzitutto i seguenti sottoprogrammi orientati al carattere:
 */

/**
 * Legge da tastiera il carattere successivo (anche uno spazio bianco) e pone la
 * sua codifica ASCII in AL.
 */
extern "C" char leggisuccessivo()
{
    char c;
    cin.get(c);
    return c;
}

/**
 * Scrive su terminale il carattere la cui codifica ASCII si trova in DIL.
 */
extern "C" void scrivicarattere(char c)
{
    cout.put(c);
}

/**
 * Scrive su terminale il carattere spazio.
 */
extern "C" void scrivispazio()
{
    cout.put(' ');
}

/**
 * Scrive su terminale un fine linea (caratteri '\n' e '\r').
 */
extern "C" void nuovalinea()
{
    cout.put('\n');
    cout.put('\r');
}

/*
 * I seguenti sottoprogrammi effetuano operazioni orientate ai numeri
 * (formatate), con conversione di base. Le letture (da tastiera) interessano la
 * successiva sequenza di caratteri che comincia con il primo carattere diverso
 * da uno spazio bianco (caratteri spazio, tabulazione, nuova riga o ritorno
 * carrello) e termina con un carattere non congruente con l'entita' da leggere
 * (tipicamente uno spazio bianco).
 * Le scritture (su terminale), avvengono a partire dalla posizione corrente del
 * cursore, e consistono nella sequenza di caratteri che rappresentano l'entita'
 * scritta.
 */

/**
 * Salta eventuali spazi bianchi, legge da tastiera il successivo carattere
 * diverso da spazio bianco e pone la sua codifica ASCII in AL.
 */
extern "C" char leggicarattere()
{
    char c;
    cin >> c;
    return c;
}

/**
 * Salta eventuali spazi bianchi, legge da tastiera una sequenza di caratteri
 * conguente con la rappresentazione in base sedici di un numero naturale
 * (sequenza di cifre esadecimali), la converte in un naturale in base due e lo
 * pone in RAX.
 */
extern "C" unsigned int legginaturale()
{
    unsigned int n;
    cin >> n;
    return n;
}

/**
 * Salta eventuali caratteri bianchi, legge da tastiera una sequenza di
 * caratteri congruente con la rappresentazione in base dieci di un numero
 * intero (eventuale segno e sequenza di cifre decimali), la converte in un
 * intero binario e lo pone in RAX.
 */
extern "C" int leggiintero()
{
    int i;
    cin >> i;
    return i;
}

/**
 *
 */
extern "C" void leggireale()
{
    // work in progress
}

/**
 * Converte il numero naturale espresso in base due contenuto in RDI in una
 * sequenza di caratteri che rappresentano cifre in base sedici, e scrive tale
 * sequenza su terminale.
 */
extern "C" void scrivinaturale(unsigned int n)
{
    fprintf(stdout, "%d", n);
}

/**
 * Converte il numero intero espresso in base due contenuto in RDI in una
 * sequenza di caratteri che rappresentano il numero intero in base dieci, e
 * scrive tale sequenza su terminale.
 */
extern "C" void scriviintero(int i)
{
    fprintf(stdout, "%d", i);
}

/**
 * 
 */
extern "C" void scrivireale(float f)
{
    fprintf(stdout, "%f", f);
}

/**
 * Traduzione in Assembly di un file C++.
 *
 * - Il comando g++, con l'opzione -S, effettua la traduzione in Assembly di un
 *   file con estensione cc o cpp, producendo un nuovo file con lo stesso nome
 *   ed estensione s;
 *
 * - nel caso di questo file, il comando e' cosi' fatto: g++ -S servizio.cpp;
 *
 * - il file servizio.s ottenuto contiene sottoprogrammi in Assembly con lo
 *   stesso identificatore e funzionalmente equivalenti a quelli C++;
 *
 * - il file servizio.s puo' essere incluso nei file Assembly che effettuano
 *   operazioni di I/O.
 */

/**
 * Le funzioni C++ salvano e ripristinano il contenuto di alcuni fra i registri
 * utilizzati (i cosiddetti registri invarianti) e non di tutti quelli che
 * potrebbero utilizzare.
 *
 * Registri invarianti: RSP, RBP, RBX, R12-R15.
 *
 * Pertanto un programma Assembly, se utilizza un sottoprogramma contenuto nel
 * file servizio.s, non deve lasciare informazioni che non devono essere
 * modificate in registri non invarianti.
 */

