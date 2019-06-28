#*******************************************************************************
# File: servizio_test.s
#       File di test delle funzioni del file servizio.s.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 16/06/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.DATA
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    # TEST leggisuccessivo()
    CALL    leggisuccessivo

    # TEST scrivicarattere()
    # Scrive il carattere precedentemente letto.
    MOV     %AL, %DIL
    CALL    scrivicarattere

    # TEST scrivispazio
    # Scrive uno spazio dopo il carattere precedentemente scritto e poi scrive
    # il carattere 'a' per rimarcare lo spazio bianco presente.
    CALL    scrivispazio
    MOV     $'a', %DIL
    CALL    scrivicarattere

    # TEST nuovalinea()
    # Va a capo dopo l'ultima scrittura sul terminale, scrive il carattere 'b' e
    # stampa nuovamente il carattere nuova linea.
    CALL    nuovalinea
    MOV     $'b', %DIL
    CALL    scrivicarattere
    CALL    nuovalinea

    # TEST leggicarattere()
    # Salta eventuali spazi bianchi e legge il primo carattere utile.
    CALL    leggicarattere
    MOV     %AL, %DIL
    CALL    scrivicarattere
    CALL    nuovalinea

    # TEST legginaturale() scrivinaturale()
    # Legge e stampa un numero naturale.
    CALL    legginaturale
    MOV     %RAX, %RDI
    CALL    scrivinaturale
    CALL    nuovalinea

    # TEST leggiintero() scriviintero()
    # Legge e stampa un numero intero
    CALL    leggiintero
    MOV     %RAX, %RDI
    CALL    scriviintero
    CALL    nuovalinea

    RET

