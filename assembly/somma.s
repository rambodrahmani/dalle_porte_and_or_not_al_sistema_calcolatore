##
#
#   File: esempio_programma.s
#         Prepariamo un semplice esempio di programma da far eseguire al nostro
#         elaboratore. Dato che ci interessa principalmente sapere cosa succede
#         durante l'esecuzione all'interno dell'elaboratore, usiamo il
#         linguaggio Assembly, che e' il piu' vicino al linguaggio macchina:
#         ogni istruzione Assembly si traduce in una istruzione di linguaggio
#         macchina. Sempre per lo stesso motivo, ci conviene pensare che tutta
#         la procedura di preparazione del programma in linguaggio macchina
#         (scrittura del file sorgente, assemblamento, collegamento) sia svolta
#         all'esterno del calcolare, su un altro calcolare o in qualunque altro
#         modo, anche se in pratica usiamo lo stesso calcolatore per fare tutto.
#         L'esecuzione del nsotro programma comincia dal momento in cui esso e'
#         stato caricato in memoria; a quel punto esiste solo il linguaggio
#         macchina e tutta la procedura precedente non conta piu'.
#
#         La procedura inizia preparando un file di testo che contiene il
#         programma in linguaggio Assembly. Si consideri l'esempio a seguire nel
#         presente file.
#
#   Author: Rambod Rahmani <rambodrahmani@autistici.org>
#           Created on 17/05/2019.
#
##

.DATA
    num1:   .QUAD   0x1122334455667788

    num2:   .QUAD   0x9900aabbccddeeff

    risu:   .QUAD   -1

    # il programma vuole calcolare la somma dei due numeri memorizzati agli
    # indirizzi num1 e num2 e scrivere il risultato all'indirizzo risu.

.TEXT

.GLOBAL _start, start
start:
_start:
    MOVABSQ  $num1,  %RAX   # carica l'indirizzo del primo numero in RAX
    MOVQ     (%RAX), %RCX   # carica il primo numero nel registro RCX
    MOVABSQ  $num2,  %RAX
    MOVQ     (%RAX), %RBX   # carica il secondo numero nel registro RBX
    ADDQ     %RBX,   %RCX   # somma i due numeri scrivendo il risultato in RCX
    MOVABSQ  $risu,  %RAX
    MOVQ     %RCX,   (%RAX) # copia il risultato della somma in risu

    # le righe 52-54 servono a dire al sistema operativo che il programma e'
    # terminato

    MOVQ     $13,    %RBX
    MOV      $1,     %RAX
    int      $0x80

# Possiamo esaminare il prodotto dell'assemblatore o del collegatore con il
# comando objdump. Per esempio, possiamo chiedere di vedere il codice macchina
# prodotto dall'assemblatore nella sezione TEXT:
#
#    [rambodrahmani@rr-workstation assembly]$ objdump -d somma.o
#    
#    somma.o:     file format elf64-x86-64
#    
#    
#    Disassembly of section .text:
#    
#    0000000000000000 <_start>:
#       0:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
#       7:	00 00 00 
#       a:	48 8b 08             	mov    (%rax),%rcx
#       d:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
#      14:	00 00 00 
#      17:	48 8b 18             	mov    (%rax),%rbx
#      1a:	48 01 d9             	add    %rbx,%rcx
#      1d:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
#      24:	00 00 00 
#      27:	48 89 08             	mov    %rcx,(%rax)
#      2a:	48 c7 c3 0d 00 00 00 	mov    $0xd,%rbx
#      31:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
#      38:	cd 80                	int    $0x80
#
# Si noti che questa interpretazione, che e' l'operazione inversa rispetto a
# quanto fa l'assemblatore, e' fatta da objdump senza guardare il file sorgente.
# Si noti come num1, num2 e risu sono state sostituite con zero. Questo perche'
# neanche l'assemblatore sa quanto valgono, in quanto e' solo il collegatore che
# decide dove le varie sezioni dovranno essere caricate.
#
# Per vedere il risultato prodotto dal collegatore (sempre nella sezione .TEXT)
# scriviamo
#
#    [rambodrahmani@rr-workstation assembly]$ objdump -d somma
#    
#    somma:     file format elf64-x86-64
#    
#    
#    Disassembly of section .text:
#    
#    0000000000401000 <_start>:
#      401000:	48 b8 00 20 40 00 00 	movabs $0x402000,%rax
#      401007:	00 00 00 
#      40100a:	48 8b 08             	mov    (%rax),%rcx
#      40100d:	48 b8 08 20 40 00 00 	movabs $0x402008,%rax
#      401014:	00 00 00 
#      401017:	48 8b 18             	mov    (%rax),%rbx
#      40101a:	48 01 d9             	add    %rbx,%rcx
#      40101d:	48 b8 10 20 40 00 00 	movabs $0x402010,%rax
#      401024:	00 00 00 
#      401027:	48 89 08             	mov    %rcx,(%rax)
#      40102a:	48 c7 c3 0d 00 00 00 	mov    $0xd,%rbx
#      401031:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
#      401038:	cd 80                	int    $0x80
#
