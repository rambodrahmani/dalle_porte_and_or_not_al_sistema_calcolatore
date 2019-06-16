GAS LISTING codifica1a.s 			page 1


   1              	##
   2              	#
   3              	# File: codifica1a.s
   4              	#       Programma codifica1 (prima nuova versione del programma codifica):
   5              	#       - due file: il primo contiene il programma principale, il secondo
   6              	#         un sottoprogramma esamina, utilizzato dal primo file.
   7              	#
   8              	#       Il programma principale:
   9              	#       - legge caratteri fino alla fine della linea;
  10              	#       - per ogni carattere, oltre a stamparlo, richiama il sottoprogramma
  11              	#         esamina, quindi stampa il risultato prodotto da quest'ultimo.
  12              	#
  13              	#       Il sottoprogramma esamina:
  14              	#       - restituisce 8 caratteri in codifica ASCII, corrispondenti agli 8 bit
  15              	#         della codifica del carattere ricevuto.
  16              	#
  17              	#       Trasmissione dei dati fra programma e sottoprogramma:
  18              	#       - due variabili alfa e beta definite nel secondo file (esterno nel primo
  19              	#         file e globali nel secondo);
  20              	#         - alfa: contiene il codice del carattere, che il sottoprogramma deve
  21              	#           esaminare;
  22              	#         - beta: contiene l'indirizzo di una variabile array di 8 byte, dove il
  23              	#           sottoprogramma deve porre il risultato;
  24              	#       - il programma principale pone i dati in alfa e beta, quindi chiama
  25              	#         esamina.
  26              	#
  27              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  28              	#         Created on 07/05/2019.
  29              	#
  30              	##
  31              	
  32              	.INCLUDE "util.s"
   1              	##
   2              	#
   3              	# File: util.s
   4              	#       Fornisce funzioni di utilita'. Da includere nei file assembly che
   5              	#       effettuano operazioni di I/O.
   6              	#       Contiene tre sottoprogrammi: tastiera, video, uscita.
   7              	#
   8              	#       Tastiera, video e uscita utilizzano il servizio UNIX 0x80 che gestisce
   9              	#       l'I/O in modo bufferizzato (con opportuni parametri in RAX, RBx, RCX,
  10              	#       RDX). Tastiera e video ripristinano tutti i registri utilizzati (tranne
  11              	#       RAX per il sottoprogramma tastiera, che lascia il risultato in AL).
  12              	#
  13              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  14              	#         Created on 29/04/2019.
  15              	#
  16              	##
  17              	
  18              	.DATA
  19 0000 00       	    buff:   .byte 0
  20              	
  21              	.TEXT
  22              	
  23              	##
  24              	# tastiera: legge il successivo carattere battuto a tastiera e pone il suo
  25              	# codice ASCII nel registro AL; i caratteri battuti a tastiera, che compaiono in
GAS LISTING codifica1a.s 			page 2


  26              	# eco su video, vengono effettivamente letti quando da tastiera viene premuto il
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
  46              	# video: scrive su video il carattere il cui codice ASCII e' contenuto in BL; i
  47              	# caratteri inviati su video vengono effettivamente visualizzati quando viene
  48              	# inviati su video il carattere '\n' (nuova linea); viene inserito dal driver
  49              	# del video anche il carattere '\r' (ritorno carrello).
  50              	##
  51              	video:
  52 002b 50       	    PUSHQ   %RAX                # salva il contenuto dei registri
  53 002c 53       	    PUSHQ   %RBX
  54 002d 51       	    PUSHQ   %RCX
  55 002e 52       	    PUSHQ   %RDX
  56 002f 881D0000 	    MOVB    %BL, buff(%RIP)
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
GAS LISTING codifica1a.s 			page 3


  72      00
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
  33              	
  34              	.EXTERN alfa, beta, esamina
  35              	
  36              	.DATA
  37 0001 00000000 	    kappa:  .fill   8,  1
  37      00000000 
  38              	
  39              	.GLOBAL _start
  40              	
  41              	.TEXT
  42              	_start:
  43              	
  44              	ancora:
  45 0064 E897FFFF 	    CALL    tastiera        # leggi il carattere digitato su tastiera in %AL
  45      FF
  46 0069 3C0A     	    CMPB    $'\n',  %AL     # se il carattere letto corrisponde al nuova linea
  47 006b 744F     	    JE      fine            # salta a fine
  48 006d 88C3     	    MOVB    %AL,    %BL     # altrimenti, sposta il carattere letto in %BL
  49 006f E8B7FFFF 	    CALL    video           # stampa a video il contenuto di %BL
GAS LISTING codifica1a.s 			page 4


  49      FF
  50 0074 B320     	    MOVB    $' ',   %BL     # mette in %BL la codifica ASCII di ' '
  51 0076 E8B0FFFF 	    CALL    video
  51      FF
  52 007b 88050000 	    MOVB    %AL,    alfa(%RIP)
  52      0000
  53 0081 488D0500 	    LEAQ    kappa(%RIP), %RAX
  53      000000
  54 0088 48890500 	    MOVQ    %RAX,   beta(%RIP)
  54      000000
  55 008f E8000000 	    CALL    esamina
  55      00
  56 0094 488D0500 	    LEAQ    kappa(%RIP), %RAX
  56      000000
  57 009b 48C7C600 	    MOVQ    $0,     %RSI
  57      000000
  58              	
  59              	ripeti:
  60 00a2 8A1C30   	    MOVB    (%RAX, %RSI), %BL
  61 00a5 E881FFFF 	    CALL    video
  61      FF
  62 00aa 48FFC6   	    INCQ    %RSI
  63 00ad 4883FE08 	    CMPQ    $8, %RSI
  64 00b1 72EF     	    JB      ripeti
  65 00b3 B30A     	    MOVB    $'\n',  %BL
  66 00b5 E871FFFF 	    CALL    video
  66      FF
  67 00ba EBA8     	    JMP     ancora
  68              	
  69              	fine:
  70 00bc EB9A     	    JMP uscita
  71              	
GAS LISTING codifica1a.s 			page 5


DEFINED SYMBOLS
              util.s:19     .data:0000000000000000 buff
              util.s:30     .text:0000000000000000 tastiera
              util.s:51     .text:000000000000002b video
              util.s:71     .text:0000000000000058 uscita
        codifica1a.s:37     .data:0000000000000001 kappa
        codifica1a.s:42     .text:0000000000000064 _start
        codifica1a.s:44     .text:0000000000000064 ancora
        codifica1a.s:69     .text:00000000000000bc fine
        codifica1a.s:59     .text:00000000000000a2 ripeti

UNDEFINED SYMBOLS
alfa
beta
esamina
