GAS LISTING conteggio_carattere_2.s 			page 1


   1              	##
   2              	#
   3              	# File: conteggio_carattere_2.s
   4              	#       VARIAZIONE sul tema per l’indirizzamento (uso di displacement + registro
   5              	#       di modifica).
   6              	#
   7              	#       Scrivere un programma che legge una stringa di memoria lunga un numero
   8              	#       arbitrario di caratteri (ma terminata da \0), inserita in un buffer di
   9              	#       memoria di indirizzo noto, e conta le volte che appare il carattere
  10              	#       specificato dentro un’altra locazione di memoria. Il risultato viene
  11              	#       messo in una terza locazione di memoria.
  12              	#
  13              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
  14              	#         Created on 29/04/2019.
  15              	#
  16              	##
  17              	
  18              	.INCLUDE "util.s"
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
GAS LISTING conteggio_carattere_2.s 			page 2


  35 002e 52       	    PUSHQ   %RDX
  36 002f 881D0000 	    MOVB    %BL, buff(%RIP)
  36      0000
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
GAS LISTING conteggio_carattere_2.s 			page 3


  85              	
  19              	
  20              	.GLOBAL _start
  21              	
  22              	.DATA
  23 0001 51756573 	    stringa:    .ASCIZ  "Questa e' una stringa di prova che usiamo come esempio"
  23      74612065 
  23      2720756E 
  23      61207374 
  23      72696E67 
  24 0038 65       	    lettera:    .BYTE   'e'
  25 0039 00       	    conteggio:  .BYTE   0x00
  26              	
  27              	.TEXT
  28              	_start:
  29 0064 90       	    NOP                         # No Operation
  30 0065 B100     	    MOVB    $0x00,      %CL     # Azzera il contenuto di CL
  31 0067 B200     	    MOVB    $0x00,      %DL
  32 0069 BE000000 	    MOV     $0,         %ESI    # The lea (load effective address) instruction
  32      00
  33              	                                # is used to put a memory address into the
  34              	                                # destination.
  35 006e 8A042500 	    MOV     lettera,    %AL     # Metti il contenuto di lettera in AL
  35      000000
  36              	
  37              	comp:
  38 0075 6780BE00 	    CMPB    $0x00,  stringa(%ESI)   # 1
  38      00000000 
  39 007d 740F     	    JE      print                   # Se ESI e' nullo salta abbiamo finito
  40 007f 673A8600 	    CMP     stringa(%ESI),  %AL     # Controlla il valore contenuto nel
  40      000000
  41              	                                    # puntatore presente nel registro ESI.
  42 0086 7502     	    JNE     poi                     # Se il contenuto e' diverso da AL salta
  43 0088 FEC1     	    INC     %CL                     # ...altrimenti incrementa CL di 1
  44              	
  45              	poi:
  46 008a FFC6     	    INC %ESI                # Incrementa il puntatore in ESI
  47 008c EBE7     	    JMP comp                # Salta (torna) a comp
  48              	
  49              	##
  50              	# Stampa il contenuto del registro CL in binario.
  51              	##
  52              	print:
  53 008e 80F900   	    CMPB    $0x00,  %CL
  54 0091 7422     	    JE      fine
  55 0093 D0E9     	    SHRB    %CL
  56 0095 80D200   	    ADCB    $0x0,   %DL
  57 0098 80FA00   	    CMPB    $0x00,  %DL
  58 009b 7402     	    JE      print_zero
  59 009d EB0B     	    JMP     print_one
  60              	
  61              	##
  62              	# Stampa il carattere '0'.
  63              	##
  64              	print_zero:
  65 009f B330     	    MOVB    $'0',   %BL
  66 00a1 E885FFFF 	    CALL    video
GAS LISTING conteggio_carattere_2.s 			page 4


  66      FF
  67 00a6 B200     	    MOVB    $0x00,  %DL
  68 00a8 EBE4     	    JMP     print
  69              	
  70              	##
  71              	# Stampa il carattere '1'.
  72              	##
  73              	print_one:
  74 00aa B331     	    MOVB    $'1',   %BL
  75 00ac E87AFFFF 	    CALL    video
  75      FF
  76 00b1 B200     	    MOVB    $0x00,  %DL
  77 00b3 EBD9     	    JMP     print
  78              	
  79              	fine:
  80 00b5 880C2500 	    MOV     %CL,    conteggio
  80      000000
  81 00bc B30A     	    MOVB    $'\n',  %BL         # carattere nuova riga
  82 00be E868FFFF 	    CALL    video
  82      FF
  83 00c3 EB93     	    JMP     uscita
  84              	
GAS LISTING conteggio_carattere_2.s 			page 5


DEFINED SYMBOLS
              util.s:13     .data:0000000000000000 buff
              util.s:16     .text:0000000000000000 tastiera
              util.s:31     .text:000000000000002b video
              util.s:48     .text:0000000000000058 uscita
conteggio_carattere_2.s:28     .text:0000000000000064 _start
conteggio_carattere_2.s:23     .data:0000000000000001 stringa
conteggio_carattere_2.s:24     .data:0000000000000038 lettera
conteggio_carattere_2.s:25     .data:0000000000000039 conteggio
conteggio_carattere_2.s:37     .text:0000000000000075 comp
conteggio_carattere_2.s:52     .text:000000000000008e print
conteggio_carattere_2.s:45     .text:000000000000008a poi
conteggio_carattere_2.s:79     .text:00000000000000b5 fine
conteggio_carattere_2.s:64     .text:000000000000009f print_zero
conteggio_carattere_2.s:73     .text:00000000000000aa print_one

NO UNDEFINED SYMBOLS
