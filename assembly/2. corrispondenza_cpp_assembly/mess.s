#*******************************************************************************
# File: mess.s
#       Come primo esempio, riportiamo il programma seguente, che invia su
#       terminale un messaggio. Nella sezione dati e' definita la variabile di
#       tipo stringa mess: questa viene considerata come una variabile
#       vettoriale, con componenti di tipo byte. La lunghezza del messaggio e'
#       data dalla differenza fra gli indirizzi f_mess (indirizzo della
#       locazione successiva a quella contenente l'ultimo carattere del
#       messaggio) e mess (indirizzo della locazione contenente il primo
#       carattere del messaggio). Nella sezione testo e' anzitutto prevista
#       l'inclusione del file ser.s. In questa sezione e' contenuto il programma
#       principale. Il registro EBX funge da registro puntatore: esso viene
#       inizializzato con l'indirizzo della variabile mess, e viene incrementato
#       a ogni ciclo. Il carattere selezionato viene quindi inviato su
#       terminale. Il registro CL e' usato come contatore dei passi da
#       effettuare. Alla fine del messaggio, viene effettuato un salto al gruppo
#       di istruzioni uscita.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/06/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.DATA
    mess:   .ASCII  "Invio di un messaggio"
    f_mess:
#-------------------------------------------------------------------------------
.TEXT
.INCLUDE "ser.s"
.GLOBAL _start
#-------------------------------------------------------------------------------
_start:
    MOVABSQ $mess, %RBX             # copia in RBX l'indirizzo contenuto in mess
    MOVB    $(f_mess - mess), %CL   # copia in CL la lungezza della stringa mess

ripeti:
    MOVB    (%RBX), %AL     # copia in AL il carattere ASCII puntato da RBX
    CALL    video           # stampa il carattere ASCII contenuto di AL
    ADDQ    $1, %RBX        # incrementa di 1 l'indirizzo contenuto in RBX
    SUBB    $1, %CL         # decrementa di 1 il contatore CL
    JNZ     ripeti          # se ho ancora caratteri da stampanre, ripeti

    MOVB    $'\n', %AL      # copia in AL il carattere ASCII '\n'
    CALL    video           # stampa il carattere ASCII contenuto in AL
    JMP     uscita          # salta a uscita

