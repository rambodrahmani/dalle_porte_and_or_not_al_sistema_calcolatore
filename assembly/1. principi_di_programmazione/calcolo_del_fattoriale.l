GAS LISTING calcolo_del_fattoriale.s 			page 1


   1              	##
   2              	#
   3              	# File: calcolo_del_fattoriale.s
   4              	#       Si scriva un programma che calcola il fattoriale di un numero naturale
   5              	#       (da 0 a 9) contenuto nella variabile numero, di tipo byte. Il risultato
   6              	#       deve essere inserito in una variabile risultato, di dimensione
   7              	#       opportuna. Si controlli che dato non ecceda 9. Prestare attenzione al
   8              	#       dimensionamento della moltiplicazione.
   9              	#
  10              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  11              	#         Created on 02/05/2019.
  12              	#
  13              	##
  14              	
  15              	.INCLUDE "util.s"
   1              	##
   2              	#
   3              	# File: util.s
   4              	#       Fornisce funzioni di utilita'. Da includere nei file assembly che
   5              	#       effettuano operazioni di I/O.
   6              	#
   7              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
   8              	#         Created on 29/04/2019.
   9              	#
  10              	##
  11              	
  12              	.DATA
  13 0000 00       	    buff:   .byte 0
  14              	
  15              	.TEXT
  16              	tastiera:
  17 0000 53       	    PUSHQ   %RBX
  18 0001 51       	    PUSHQ   %RCX
  19 0002 52       	    PUSHQ   %RDX
  20 0003 48C7C003 	    MOVQ    $3, %RAX            # primitiva UNIX read
  20      000000
  21 000a 48C7C300 	    MOVQ    $0, %RBX            # ingresso standard
  21      000000
  22 0011 488D0D00 	    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di ingresso
  22      000000
  23 0018 48C7C201 	    MOVQ    $1, %RDX            # numero di byte da leggere
  23      000000
  24 001f CD80     	    INT     $0x80
  25 0021 8A050000 	    MOVB    buff(%RIP), %AL
  25      0000
  26 0027 5A       	    POPQ    %RDX
  27 0028 59       	    POPQ    %RCX
  28 0029 5B       	    POPQ    %RBX
  29 002a C3       	    RET
  30              	
  31              	video:
  32 002b 50       	    PUSHQ   %RAX
  33 002c 53       	    PUSHQ   %RBX
  34 002d 51       	    PUSHQ   %RCX
  35 002e 52       	    PUSHQ   %RDX
  36 002f 881D0000 	    MOVB    %BL, buff(%RIP)
  36      0000
GAS LISTING calcolo_del_fattoriale.s 			page 2


  37 0035 48C7C004 	    MOVQ    $4, %RAX            # primitiva UNIX write
  37      000000
  38 003c 48C7C301 	    MOVQ    $1, %RBX            # uscita standard
  38      000000
  39 0043 488D0D00 	    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di uscita
  39      000000
  40 004a 48C7C201 	    MOVQ    $1, %RDX            # numero byte da scrivere
  40      000000
  41 0051 CD80     	    INT     $0x80
  42 0053 5A       	    POPQ    %RDX
  43 0054 59       	    POPQ    %RCX
  44 0055 5B       	    POPQ    %RBX
  45 0056 58       	    POPQ    %RAX
  46 0057 C3       	    RET
  47              	
  48              	uscita:
  49 0058 BB000000 	    MOVL    $0, %EBX    # risultato per sistema operativo UNIX
  49      00
  50 005d B8010000 	    MOVL    $1, %EAX    # primitiva UNIX exit
  50      00
  51              	                        # [1]
  52 0062 CD80     	    INT     $0x80       # Invokes system call - in this case system call number
  53              	                        # 1 with argument 0
  54              	                        # [2]
  55              	
  56              	# [1]
  57              	# On many computer operating systems, a computer process terminates its
  58              	# execution by making an exit system call. More generally, an exit in a
  59              	# multithreading environment means that a thread of execution has stopped
  60              	# running. For resource management, the operating system reclaims resources
  61              	# (memory, files, etc.) that were used by the process. The process is said to be
  62              	# a dead process after it terminates. Under Unix and Unix-like operating
  63              	# systems, a process is started when its parent process executes a fork system
  64              	# call. The parent process may then wait for the child process to terminate, or
  65              	# may continue execution (possibly forking off other child processes). When the
  66              	# child process terminates ("dies"), either normally by calling exit, or
  67              	# abnormally due to a fatal error or signal (e.g., SIGTERM, SIGINT, SIGKILL), an
  68              	# exit status is returned to the operating system and a SIGCHLD signal is sent
  69              	# to the parent process. The exit status can then be retrieved by the parent
  70              	# process via the wait system call.
  71              	
  72              	# [2]
  73              	# You can make use of Linux system calls in your assembly programs. You need to
  74              	# take the following steps for using Linux system calls in your program:
  75              	#
  76              	# 1. Put the system call number in the EAX register.
  77              	# 2. Store the arguments to the system call in the registers EBX, ECX, etc.
  78              	# 3. Call the relevant interrupt (80h).
  79              	# 4. The result is usually returned in the EAX register.
  80              	# There are six registers that store the arguments of the system call used.
  81              	# These are the EBX, ECX, EDX, ESI, EDI, and EBP. These registers take the
  82              	# consecutive arguments, starting with the EBX register. If there are more than
  83              	# six arguments, then the memory location of the first argument is stored in the
  84              	# EBX register.
  85              	
  16              	
  17              	.GLOBAL _start
GAS LISTING calcolo_del_fattoriale.s 			page 3


  18              	
  19              	.DATA
  20 0001 09       	    numero:     .BYTE   9
  21 0002 01000000 	    risultato:  .LONG   1
  22              	
  23              	.TEXT
  24              	_start:
  25 0064 90       	    NOP
  26 0065 B9000000 	    MOV $0, %ECX
  26      00
  27 006a B8010000 	    MOV $1, %EAX
  27      00
  28 006f 8A0C2500 	    MOV numero, %CL
  28      000000
  29 0076 80F909   	    CMP $9, %CL
  30 0079 770B     	    JA  fine        # se CL contiene un numero piu' grande di 9 mi fermo
  31 007b 80F901   	    CMP $1, %CL
  32 007e 7606     	    JBE fine        # se CL contiene un numero piu' piccolo di 1 mi fermo
  33              	
  34              	# Se numero e' compreso tra 1 e 9 continuo, ricordiamo infatti che il fattoriale
  35              	# di 0 e' uguale ad 1 che si trova gia' inserito dentro EAX.
  36              	
  37              	ciclo_f:
  38 0080 F7E1     	    MUL %ECX        # ricordiamo che in CL e' stato inserito numero
  39 0082 FEC9     	    DEC %CL         # decremento CL di 1
  40 0084 75FA     	    JNZ ciclo_f     # sinche' CL non vale 0 ripeto il ciclo
  41              	
  42              	fine:
  43 0086 89042500 	    MOV %EAX,   risultato
  43      000000
  44 008d EBC9     	    JMP uscita
  45              	
GAS LISTING calcolo_del_fattoriale.s 			page 4


DEFINED SYMBOLS
              util.s:13     .data:0000000000000000 buff
              util.s:16     .text:0000000000000000 tastiera
              util.s:31     .text:000000000000002b video
              util.s:48     .text:0000000000000058 uscita
calcolo_del_fattoriale.s:24     .text:0000000000000064 _start
calcolo_del_fattoriale.s:20     .data:0000000000000001 numero
calcolo_del_fattoriale.s:21     .data:0000000000000002 risultato
calcolo_del_fattoriale.s:42     .text:0000000000000086 fine
calcolo_del_fattoriale.s:37     .text:0000000000000080 ciclo_f

NO UNDEFINED SYMBOLS
