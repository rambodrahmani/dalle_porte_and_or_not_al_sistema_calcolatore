GAS LISTING conteggio_carattere.s 			page 1


   1              	##
   2              	#
   3              	# File: conteggio_carattere.s
   4              	#       Scrivere un programma che legge una stringa di memoria lunga un numero
   5              	#       arbitrario di caratteri (ma terminata da \0), inserita in un buffer di
   6              	#       memoria di indirizzo noto, e conta le volte che appare il carattere
   7              	#       specificato dentro un’altra locazione di memoria. Il risultato viene
   8              	#       messo in una terza locazione di memoria.
   9              	#
  10              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  11              	#         Created on 29/04/2019.
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
GAS LISTING conteggio_carattere.s 			page 2


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
GAS LISTING conteggio_carattere.s 			page 3


  18              	
  19              	.DATA
  20 0001 51756573 	    stringa:    .ASCIZ  "Questa e' una stringa di prova che usiamo come esempio"
  20      74612065 
  20      2720756E 
  20      61207374 
  20      72696E67 
  21 0038 65       	    lettera:    .BYTE   'e'
  22 0039 00       	    conteggio:  .BYTE   0x00
  23              	
  24              	.TEXT
  25              	_start:
  26 0064 90       	    NOP                         # No Operation
  27 0065 B100     	    MOVB    $0x00,      %CL     # Azzera il contenuto di CL
  28 0067 B200     	    MOVB    $0x00,      %DL
  29 0069 8D342500 	    LEA     stringa,    %ESI    # The lea (load effective address) instruction
  29      000000
  30              	                                # is used to put a memory address into the
  31              	                                # destination.
  32 0070 8A042500 	    MOV     lettera,    %AL     # Metti il contenuto di lettera in AL
  32      000000
  33              	
  34              	comp:
  35 0077 67803E00 	    CMPB    $0x00,  (%ESI)  # 1
  36 007b 740B     	    JE      print           # Se ESI e' nullo salta abbiamo finito
  37 007d 673A06   	    CMP     (%ESI), %AL     # Controlla il valore contenuto nel puntatore
  38              	                            # presente nel registro ESI.
  39 0080 7502     	    JNE     poi             # Se il contenuto e' diverso da AL salta a poi
  40 0082 FEC1     	    INC     %CL             # ...altrimenti incrementa CL di 1
  41              	
  42              	poi:
  43 0084 FFC6     	    INC %ESI                # Incrementa il puntatore in ESI
  44 0086 EBEF     	    JMP comp                # Salta (torna) a comp
  45              	
  46              	##
  47              	# Stampa il contenuto del registro CL in binario.
  48              	##
  49              	print:
  50 0088 80F900   	    CMPB    $0x00,  %CL
  51 008b 7422     	    JE      fine
  52 008d D0E9     	    SHRB    %CL
  53 008f 80D200   	    ADCB    $0x0,   %DL
  54 0092 80FA00   	    CMPB    $0x00,  %DL
  55 0095 7402     	    JE      print_zero
  56 0097 EB0B     	    JMP     print_one
  57              	
  58              	##
  59              	# Stampa il carattere '0'.
  60              	##
  61              	print_zero:
  62 0099 B330     	    MOVB    $'0',   %BL
  63 009b E88BFFFF 	    CALL    video
  63      FF
  64 00a0 B200     	    MOVB    $0x00,  %DL
  65 00a2 EBE4     	    JMP     print
  66              	
  67              	##
GAS LISTING conteggio_carattere.s 			page 4


  68              	# Stampa il carattere '1'.
  69              	##
  70              	print_one:
  71 00a4 B331     	    MOVB    $'1',   %BL
  72 00a6 E880FFFF 	    CALL    video
  72      FF
  73 00ab B200     	    MOVB    $0x00,  %DL
  74 00ad EBD9     	    JMP     print
  75              	
  76              	fine:
  77 00af 880C2500 	    MOV %CL,    conteggio
  77      000000
  78 00b6 B30A     	    MOVB    $'\n',  %BL         # carattere nuova riga
  79 00b8 E86EFFFF 	    CALL    video
  79      FF
  80 00bd EB99     	    JMP uscita
  81              	
  82              	##
  83              	# 1
  84              	# Fondamentale: che succede se mi scordo la B nella CMPB?
  85              	# Succede che l'assemblatore non segnala niente, e ci mette una L (vedere il
  86              	# disassemblato per rendersene conto). In questo modo il programma non funziona
  87              	# (infatti, prende sempre una lettera in piu' perche' straborda nella locazione
  88              	# successiva della variabile lettera.
  89              	##
  90              	
GAS LISTING conteggio_carattere.s 			page 5


DEFINED SYMBOLS
              util.s:13     .data:0000000000000000 buff
              util.s:16     .text:0000000000000000 tastiera
              util.s:31     .text:000000000000002b video
              util.s:48     .text:0000000000000058 uscita
conteggio_carattere.s:25     .text:0000000000000064 _start
conteggio_carattere.s:20     .data:0000000000000001 stringa
conteggio_carattere.s:21     .data:0000000000000038 lettera
conteggio_carattere.s:22     .data:0000000000000039 conteggio
conteggio_carattere.s:34     .text:0000000000000077 comp
conteggio_carattere.s:49     .text:0000000000000088 print
conteggio_carattere.s:42     .text:0000000000000084 poi
conteggio_carattere.s:76     .text:00000000000000af fine
conteggio_carattere.s:61     .text:0000000000000099 print_zero
conteggio_carattere.s:70     .text:00000000000000a4 print_one

NO UNDEFINED SYMBOLS
