GAS LISTING codifica.s 			page 1


   1              	#*******************************************************************************
   2              	# File: codifica.s
   3              	#       Come secondo esempio, riportiamo il programma seguente, che:
   4              	#        1) legge un carattere e, se uguale al carattere '\n', termina,
   5              	#           altrimenti:
   6              	#        2) scrive su terminale il carattere letto seguito dal carattere spazio;
   7              	#        3) ricava dagli 8 bit del carattere letto, a partire dal bit piu'
   8              	#           significativo, 9 caratteri '0' oppure '1' (corrispondenti,
   9              	#           rispettivamente, ai bit 0 e 1), e li scrive su terminale seguiti dal
  10              	#           carattere '\n';
  11              	#        4) torna al punto 1.
  12              	#
  13              	#       In altre parole, stampa la codifica binaria dei caratteri ASCII immessi
  14              	#       su terminale.
  15              	#
  16              	#       [rambodrahmani@rr-laptop corrispondenza_cpp_assembly]$ ./codifica 
  17              	#       Stringa di prova
  18              	#       S 0a0a00aa
  19              	#       t 0aaa0a00
  20              	#       r 0aaa00a0
  21              	#       i 0aa0a00a
  22              	#       n 0aa0aaa0
  23              	#       g 0aa00aaa
  24              	#       a 0aa0000a
  25              	#         00a00000
  26              	#       d 0aa00a00
  27              	#       i 0aa0a00a
  28              	#         00a00000
  29              	#       p 0aaa0000
  30              	#       r 0aaa00a0
  31              	#       o 0aa0aaaa
  32              	#       v 0aaa0aa0
  33              	#       a 0aa0000a
  34              	#
  35              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  36              	#         Created on 12/06/2019
  37              	#-------------------------------------------------------------------------------
  38              	.TEXT
  39              	.INCLUDE "ser.s"
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
GAS LISTING codifica.s 			page 2


  19 0000 00       	    buff:   .byte 0
  20              	
  21              	.TEXT
  22              	
  23              	##
  24              	# tastiera: legge il successivo carattere battuto a tastiera e pone il suo
  25              	# codice ASCII nel registro AL; i caratteri battuti a tastiera, che compaiono in
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
GAS LISTING codifica.s 			page 3


  66 0057 C3       	    RET
  67              	
  68              	##
  69              	# uscita: restituisce il controllo al sistema operativo.
  70              	##
  71              	uscita:
  72 0058 BB000000 	    MOVL    $0, %EBX    # risultato per sistema operativo UNIX
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
  40              	.GLOBAL _start
  41              	#-------------------------------------------------------------------------------
  42              	_start:
  43              	ancora:
  44 0064 E897FFFF 	    CALL    tastiera    # legge un carattere in AL
  44      FF
  45 0069 3C0A     	    CMPB    $'\n', %AL  # controlla se AL contiene la codifica ASCII di '\n'
  46 006b 7437     	    JE      fine        # in tal caso salta all'etichetta fine
  47              	
  48 006d E8B9FFFF 	    CALL    video       # stampa il carattere ASCII che si trova in AL
  48      FF
  49 0072 88C3     	    MOVB    %AL, %BL    # porta in BL il carattere letto
GAS LISTING codifica.s 			page 4


  50 0074 B020     	    MOVB    $' ', %AL   # carattere spazio
  51 0076 E8B0FFFF 	    CALL    video
  51      FF
  52              	
  53 007b B100     	    MOVB    $0, %CL     # azzera il contenuto di CL che funga da contatore
  54              	
  55              	ciclo:
  56 007d F6C380   	    TESTB   $0x80, %BL  # esame del bit piu' significativo di BL, [0]
  57 0080 7409     	    JZ      zero        # salta a zero
  58 0082 B031     	    MOVB    $'1', %AL
  59 0084 E8A2FFFF 	    CALL    video
  59      FF
  60 0089 EB07     	    JMP     avanti
  61              	
  62              	zero:
  63 008b B030     	    MOVB    $'0', %AL
  64 008d E899FFFF 	    CALL    video
  64      FF
  65              	
  66              	avanti:
  67 0092 D0E3     	    SHLB    $1, %BL     # shift left di BL di 1, [1]
  68 0094 FEC1     	    INCB    %CL         # incrementa il contatore CL
  69 0096 80F908   	    CMPB    $8, %CL     # controlla il contenuto del contatore
  70 0099 72E2     	    JB      ciclo       # ripeti il ciclo se inferire a 8
  71              	
  72 009b B00A     	    MOVB    $'\n', %AL
  73 009d E889FFFF 	    CALL    video
  73      FF
  74 00a2 EBC0     	    JMP     ancora      # leggi il prossimo carattere
  75              	
  76              	fine:
  77 00a4 EBB2     	    JMP     uscita
  78              	
  79              	# [0]
  80              	# 0x80 = 1000 0000
  81              	# It performs a bitwise AND of the two operands. Neither of the operands is
  82              	# altered, however, the instruction alters the flags, most importantly the ZF
  83              	# flag to either 1 if the result of the AND is zero, or 0 otherwise.
  84              	# The following jne performs a jump if ZF is equal to 0.
  85              	
  86              	# [1]
  87              	# Usando i shift left possiamo posizionare nella posizione piu' significativa
  88              	# ogni volta il bit successivo degli 8 bit totale che conpongono la
  89              	# rappresentazione binaria del carratere ASCII letto.
  90              	
GAS LISTING codifica.s 			page 5


DEFINED SYMBOLS
               ser.s:19     .data:0000000000000000 buff
               ser.s:30     .text:0000000000000000 tastiera
               ser.s:51     .text:000000000000002b video
               ser.s:71     .text:0000000000000058 uscita
          codifica.s:42     .text:0000000000000064 _start
          codifica.s:43     .text:0000000000000064 ancora
          codifica.s:76     .text:00000000000000a4 fine
          codifica.s:55     .text:000000000000007d ciclo
          codifica.s:62     .text:000000000000008b zero
          codifica.s:66     .text:0000000000000092 avanti

NO UNDEFINED SYMBOLS
