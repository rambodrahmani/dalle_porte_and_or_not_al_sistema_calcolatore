GAS LISTING conteggio_bit.s 			page 1


   1              	##
   2              	#
   3              	# File: conteggio_bit.s
   4              	#       Conteggio dei bit a 1 in un long.
   5              	#
   6              	# Author: Rambod Rahmani <rambodrahmani@autistici.org>
   7              	#         Created on 28/04/2019.
   8              	#
   9              	##
  10              	
  11              	.INCLUDE "util.s"
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
  37 0035 48C7C004 	    MOVQ    $4, %RAX            # primitiva UNIX write
  37      000000
  38 003c 48C7C301 	    MOVQ    $1, %RBX            # uscita standard
  38      000000
GAS LISTING conteggio_bit.s 			page 2


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
  12              	
  13              	.GLOBAL _start
  14              	
  15              	# Dichiarazioni di variabile (direttive).
  16              	.DATA
  17              	    # La prima e' un LONG, cioè uno spazio da 4 locazioni contigue, che
GAS LISTING conteggio_bit.s 			page 3


  18              	    # contengono (inizialmente) il numero 0x0F0F0101. L’indirizzo della prima
  19              	    # locazione e' riferibile nel programma con il nome "dato".
  20              	    # dato: .LONG 0x0F0F0101
  21 0001 AC4F0E00 	    dato:   .LONG 0xE4FAC
  22              	
  23              	    # La seconda e' un BYTE, cioè uno spazio da 1 locazione, che contiene
  24              	    # (inizialmente) il numero 0x00. L’indirizzo di tale locazione e' riferibile
  25              	    # nel programma con il nome "conteggio".
  26 0005 00       	    conteggio: .BYTE 0x00
  27              	
  28              	.TEXT
  29              	
  30              	_start:
  31 0064 90       	    NOP     # 1
  32 0065 B100     	    MOVB    $0x00,  %CL
  33 0067 B000     	    MOVB    $0x00,  %AL
  34              	
  35              	    # Questo e' un caso di indirizzamento diretto, in cui l'indirizzo della
  36              	    # (prima) locazione e' stato sostituito dal nome simbolico.
  37 0069 8B042500 	    MOVL    dato,   %EAX
  37      000000
  38              	
  39              	# In questo caso assegno all’istruzione CMPL un nome simbolico, che posso
  40              	# riferire dentro la succes-sive JMP. Questo viene tradotto
  41              	# dall’assemblatore come se fosse un salto relativo (vedere codice
  42              	# mnemonico a destra). L’aspetto positivo e', ovviamente, che non sono
  43              	# tenuto a farmi i conti per poterlo scrivere.
  44              	comp:
  45 0070 83F800   	    CMPL    $0x00,  %EAX
  46 0073 7407     	    JE      print
  47 0075 D1E8     	    SHRL    %EAX
  48 0077 80D100   	    ADCB    $0x0,   %CL
  49 007a EBF4     	    JMP     comp
  50              	
  51              	##
  52              	# Stampa il contenuto del registro CL in binario.
  53              	##
  54              	print:
  55 007c 80F900   	    CMPB    $0x00,  %CL
  56 007f 7420     	    JE      fine
  57 0081 D0E9     	    SHRB    %CL
  58 0083 1400     	    ADCB    $0x0,   %AL
  59 0085 3C00     	    CMPB    $0x00,  %AL
  60 0087 7402     	    JE      print_zero
  61 0089 EB0B     	    JMP     print_one
  62              	
  63              	##
  64              	# Stampa il carattere '0'.
  65              	##
  66              	print_zero:
  67 008b B330     	    MOVB    $'0',   %BL
  68 008d E899FFFF 	    CALL    video
  68      FF
  69 0092 B000     	    MOVB    $0x00,  %AL
  70 0094 EBE6     	    JMP     print
  71              	
  72              	##
GAS LISTING conteggio_bit.s 			page 4


  73              	# Stampa il carattere '1'.
  74              	##
  75              	print_one:
  76 0096 B331     	    MOVB    $'1',   %BL
  77 0098 E88EFFFF 	    CALL    video
  77      FF
  78 009d B000     	    MOVB    $0x00,  %AL
  79 009f EBDB     	    JMP     print
  80              	
  81              	# Stessa cosa di prima. Attenzione ad una sottigliezza. Il nome finenon e' stato
  82              	# dichiarato al momento del suo utilizzo.
  83              	# 2
  84              	fine:
  85 00a1 880C2500 	    MOVB    %CL,    conteggio
  85      000000
  86 00a8 B30A     	    MOVB    $'\n',  %BL         # carattere nuova riga
  87 00aa E87CFFFF 	    CALL    video
  87      FF
  88 00af EBA7     	    JMP     uscita
  89              	
  90              	##
  91              	# 1
  92              	#
  93              	# NOP (No OPeration) e' un'istruzione assembly, il cui scopo e' quello di
  94              	# permettere all'unita' di esecuzione della pipeline di oziare per N cicli di
  95              	# clock (dove N cambia a seconda del processore utilizzato), come deducibile dal
  96              	# nome dunque, non esegue alcuna operazione.
  97              	# L'istruzione NOP occupa dunque tempo e memoria, ma ha una sua utilita' nel
  98              	# mondo della programmazione (oltre che alla creazione di ritardi convenzionali
  99              	# e di riserve di spazio in memoria), risolvendo alcuni problemi chiamati
 100              	# "hazard", ovvero quei tipi di conflitti ed incongruenze che possono avvenire
 101              	# all'interno di una pipeline durante l'esecuzione del programma. L'istruzione
 102              	# puo' anche essere utilizzata per risolvere i problemi della branch delay slot
 103              	# in modo poco efficiente.
 104              	##
 105              	
 106              	##
 107              	# 2
 108              	# In Assembler, i nomi possono essere usati prima di essere stati definiti. Ci
 109              	# pensa l’assemblatore a strigare il tutto (fa due passate: nella prima
 110              	# controlla che i nomi riferiti ci siano tutti, nella seconda fa la traduzione
 111              	# vera e propria). Il motivo per cui cio' e' necessario e' ovvio: altrimenti non
 112              	# sarebbe possibile scrivere codice con salti in avanti, come quello che c’e' in
 113              	# questo programma. Dall’altra parte, questo consente di scrivere programmi di
 114              	# devastante incomprensibilita'. Ad esempio, nessuno mi obbliga a mettere tutte
 115              	# le dichiarazioni di variabili raggruppate in cima, ne' a mettere la
 116              	# definizione delle costanti prima del loro primo utilizzo, magari insieme alle
 117              	# dichiarazioni di variabile. Questi stili di programmazione vanno evitati.
 118              	# L'unico caso in cui e' lecito (stilisticamente) usare un'etichetta non ancora
 119              	# definita e' quello di salto in avanti nel codice. Non va fatto in nessun altro
 120              	# caso.
 121              	##
 122              	
GAS LISTING conteggio_bit.s 			page 5


DEFINED SYMBOLS
              util.s:13     .data:0000000000000000 buff
              util.s:16     .text:0000000000000000 tastiera
              util.s:31     .text:000000000000002b video
              util.s:48     .text:0000000000000058 uscita
     conteggio_bit.s:30     .text:0000000000000064 _start
     conteggio_bit.s:21     .data:0000000000000001 dato
     conteggio_bit.s:26     .data:0000000000000005 conteggio
     conteggio_bit.s:44     .text:0000000000000070 comp
     conteggio_bit.s:54     .text:000000000000007c print
     conteggio_bit.s:84     .text:00000000000000a1 fine
     conteggio_bit.s:66     .text:000000000000008b print_zero
     conteggio_bit.s:75     .text:0000000000000096 print_one

NO UNDEFINED SYMBOLS
