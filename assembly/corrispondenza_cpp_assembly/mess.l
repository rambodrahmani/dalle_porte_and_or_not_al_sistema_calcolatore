GAS LISTING mess.s 			page 1


   1              	#*******************************************************************************
   2              	# File: mess.s
   3              	#       Come primo esempio, riportiamo il programma seguente, che invia su
   4              	#       terminale un messaggio. Nella sezione dati e' definita la variabile di
   5              	#       tipo stringa mess: questa viene considerata come una variabile
   6              	#       vettoriale, con componenti di tipo byte. La lunghezza del messaggio e'
   7              	#       data dalla differenza fra gli indirizzi f_mess (indirizzo della
   8              	#       locazione successiva a quella contenente l'ultimo carattere del
   9              	#       messaggio) e mess (indirizzo della locazione contenente il primo
  10              	#       carattere del messaggio). Nella sezione testo e' anzitutto prevista
  11              	#       l'inclusione del file ser.s. In questa sezione e' contenuto il programma
  12              	#       principale. Il registro EBX funge da registro puntatore: esso viene
  13              	#       inizializzato con l'indirizzo della variabile mess, e viene incrementato
  14              	#       a ogni ciclo. Il carattere selezionato viene quindi inviato su
  15              	#       terminale. Il registro CL e' usato come contatore dei passi da
  16              	#       effettuare. Alla fine del messaggio, viene effettuato un salto al gruppo
  17              	#       di istruzioni uscita.
  18              	#
  19              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  20              	#         Created on 12/06/2019
  21              	#-------------------------------------------------------------------------------
  22              	.DATA
  23 0000 496E7669 	    mess:   .ASCII  "Invio di un messaggio"
  23      6F206469 
  23      20756E20 
  23      6D657373 
  23      61676769 
  24              	    f_mess:
  25              	#-------------------------------------------------------------------------------
  26              	.TEXT
  27              	.INCLUDE "ser.s"
   1              	##
   2              	#
   3              	# File: ser.s
   4              	#       Fornisce funzioni di utilita'. Da includere nei file assembly che
   5              	#       effettuano operazioni di I/O.
   6              	#       Contiene tre sottoprogrammi: tastiera, video, uscita.
   7              	#
   8              	#       Tastiera, video e uscita utilizzano il servizio UNIX 0x80 che gestisce
   9              	#       l'I/O in modo bufferizzato (con opportuni parametri in RAX, RBX, RCX,
  10              	#       RDX). Tastiera e video ripristinano tutti i registri utilizzati (tranne
  11              	#       RAX per il sottoprogramma tastiera, che lascia il risultato in AL).
  12              	#
  13              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  14              	#         Created on 29/04/2019.
  15              	#
  16              	##
  17              	
  18              	.DATA
  19 0015 00       	    buff:   .byte 0
  20              	
  21              	.TEXT
  22              	
  23              	##
  24              	# tastiera: legge il successivo carattere battuto a tastiera e pone il suo
  25              	# codice ASCII nel registro AL; i caratteri battuti a tastiera, che compaiono in
  26              	# eco su video, vengono effettivamente letti quando da tastiera viene premuto il
GAS LISTING mess.s 			page 2


  27              	# tasto Enter; in lettura, Enter viene riconosciuto come carattere '\n' (nuova
  28              	# linea).
  29              	##
  30              	tastiera:
  31 0000 53       	    PUSHQ   %RBX                # salva il contenuto dei registri
  32 0001 51       	    PUSHQ   %RCX
  33 0002 52       	    PUSHQ   %RDX
  34 0003 48C7C003 	    MOVQ    $3, %RAX            # primitiva UNIX read
  34      000000
  35 000a 48C7C300 	    MOVQ    $0, %RBX            # ingresso standard
  35      000000
  36 0011 488D0D00 	    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di ingresso
  36      000000
  37 0018 48C7C201 	    MOVQ    $1, %RDX            # numero di byte da leggere
  37      000000
  38 001f CD80     	    INT     $0x80               # invoke system call
  39 0021 8A050000 	    MOVB    buff(%RIP), %AL     # mette il carattere letto nel registro AL
  39      0000
  40 0027 5A       	    POPQ    %RDX
  41 0028 59       	    POPQ    %RCX
  42 0029 5B       	    POPQ    %RBX                # contenuto dei registri ripristinato
  43 002a C3       	    RET
  44              	
  45              	##
  46              	# video: scrive su video il carattere il cui codice ASCII e' contenuto in AL; i
  47              	# caratteri inviati su video vengono effettivamente visualizzati quando viene
  48              	# inviati su video il carattere '\n' (nuova linea); viene inserito dal driver
  49              	# del video anche il carattere '\r' (ritorno carrello).
  50              	##
  51              	video:
  52 002b 50       	    PUSHQ   %RAX                # salva il contenuto dei registri
  53 002c 53       	    PUSHQ   %RBX
  54 002d 51       	    PUSHQ   %RCX
  55 002e 52       	    PUSHQ   %RDX
  56 002f 88050000 	    MOVB    %AL, buff(%RIP)
  56      0000
  57 0035 48C7C004 	    MOVQ    $4, %RAX            # primitiva UNIX write
  57      000000
  58 003c 48C7C301 	    MOVQ    $1, %RBX            # uscita standard
  58      000000
  59 0043 488D0D00 	    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di uscita
  59      000000
  60 004a 48C7C201 	    MOVQ    $1, %RDX            # numero byte da scrivere
  60      000000
  61 0051 CD80     	    INT     $0x80               # invoke system call
  62 0053 5A       	    POPQ    %RDX
  63 0054 59       	    POPQ    %RCX
  64 0055 5B       	    POPQ    %RBX
  65 0056 58       	    POPQ    %RAX                # contenuto dei registri ripristinati
  66 0057 C3       	    RET
  67              	
  68              	##
  69              	# uscita: restituisce il controllo al sistema operativo.
  70              	##
  71              	uscita:
  72 0058 BB000000 	    MOVL    $0, %EBX    # risultato per sistema operativo UNIX
  72      00
GAS LISTING mess.s 			page 3


  73 005d B8010000 	    MOVL    $1, %EAX    # primitiva UNIX exit
  73      00
  74              	                        # [1]
  75 0062 CD80     	    INT     $0x80       # Invokes system call - in this case system call number
  76              	                        # 1 with argument 0
  77              	                        # [2]
  78              	
  79              	# [1]
  80              	# On many computer operating systems, a computer process terminates its
  81              	# execution by making an exit system call. More generally, an exit in a
  82              	# multithreading environment means that a thread of execution has stopped
  83              	# running. For resource management, the operating system reclaims resources
  84              	# (memory, files, etc.) that were used by the process. The process is said to be
  85              	# a dead process after it terminates. Under Unix and Unix-like operating
  86              	# systems, a process is started when its parent process executes a fork system
  87              	# call. The parent process may then wait for the child process to terminate, or
  88              	# may continue execution (possibly forking off other child processes). When the
  89              	# child process terminates ("dies"), either normally by calling exit, or
  90              	# abnormally due to a fatal error or signal (e.g., SIGTERM, SIGINT, SIGKILL), an
  91              	# exit status is returned to the operating system and a SIGCHLD signal is sent
  92              	# to the parent process. The exit status can then be retrieved by the parent
  93              	# process via the wait system call.
  94              	
  95              	# [2]
  96              	# You can make use of Linux system calls in your assembly programs. You need to
  97              	# take the following steps for using Linux system calls in your program:
  98              	#
  99              	# 1. Put the system call number in the EAX register.
 100              	# 2. Store the arguments to the system call in the registers EBX, ECX, etc.
 101              	# 3. Call the relevant interrupt (80h).
 102              	# 4. The result is usually returned in the EAX register.
 103              	# There are six registers that store the arguments of the system call used.
 104              	# These are the EBX, ECX, EDX, ESI, EDI, and EBP. These registers take the
 105              	# consecutive arguments, starting with the EBX register. If there are more than
 106              	# six arguments, then the memory location of the first argument is stored in the
 107              	# EBX register.
 108              	
  28              	.GLOBAL _start
  29              	#-------------------------------------------------------------------------------
  30              	_start:
  31 0064 48C7C300 	    MOVQ    $mess, %RBX             # copia in RBX l'indirizzo contenuto in mess
  31      000000
  32 006b B115     	    MOVB    $(f_mess - mess), %CL   # copia in CL la lungezza della stringa mess
  33              	
  34              	ripeti:
  35 006d 8A03     	    MOVB    (%RBX), %AL     # copia in AL il carattere ASCII puntato da RBX
  36 006f E8B7FFFF 	    CALL    video           # stampa il carattere ASCII contenuto di AL
  36      FF
  37 0074 4883C301 	    ADDQ    $1, %RBX        # incrementa di 1 l'indirizzo contenuto in RBX
  38 0078 80E901   	    SUBB    $1, %CL         # decrementa di 1 il contatore CL
  39 007b 75F0     	    JNZ     ripeti          # se ho ancora caratteri da stampanre, ripeti
  40              	
  41 007d B00A     	    MOVB    $'\n', %AL      # copia in AL il carattere ASCII '\n'
  42 007f E8A7FFFF 	    CALL    video           # stampa il carattere ASCII contenuto in AL
  42      FF
  43 0084 EBD2     	    JMP     uscita          # salta a uscita
  44              	
GAS LISTING mess.s 			page 4


GAS LISTING mess.s 			page 5


DEFINED SYMBOLS
              mess.s:23     .data:0000000000000000 mess
              mess.s:24     .data:0000000000000015 f_mess
               ser.s:19     .data:0000000000000015 buff
               ser.s:30     .text:0000000000000000 tastiera
               ser.s:51     .text:000000000000002b video
               ser.s:71     .text:0000000000000058 uscita
              mess.s:30     .text:0000000000000064 _start
              mess.s:34     .text:000000000000006d ripeti

NO UNDEFINED SYMBOLS
