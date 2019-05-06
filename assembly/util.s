##
#
# File: util.s
#       Fornisce funzioni di utilita'. Da includere nei file assembly che
#       effettuano operazioni di I/O.
#       Contiene tre sottoprogrammi: tastiera, video, uscita.
#
#       Tastiera, video e uscita utilizzano il servizio UNIX 0x80 che gestisce
#       l'I/O in modo bufferizzato (con opportuni parametri in RAX, RBx, RCX,
#       RDX). Tastiera e video ripristinano tutti i registri utilizzati (tranne
#       RAX per il sottoprogramma tastiera, che lascia il risultato in AL).
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 29/04/2019.
#
##

.DATA
    buff:   .byte 0

.TEXT

##
# tastiera: legge il successivo carattere battuto a tastiera e pone il suo
# codice ASCII nel registro AL; i caratteri battuti a tastiera, che compaiono in
# eco su video, vengono effettivamente letti quando da tastiera viene premuto il
# tasto Enter; in lettura, Enter viene riconosciuto come carattere '\n' (nuova
# linea).
##
tastiera:
    PUSHQ   %RBX                # salva il contenuto dei registri
    PUSHQ   %RCX
    PUSHQ   %RDX
    MOVQ    $3, %RAX            # primitiva UNIX read
    MOVQ    $0, %RBX            # ingresso standard
    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di ingresso
    MOVQ    $1, %RDX            # numero di byte da leggere
    INT     $0x80               # invoke system call
    MOVB    buff(%RIP), %AL     # mette il carattere letto nel registro AL
    POPQ    %RDX
    POPQ    %RCX
    POPQ    %RBX                # contenuto dei registri ripristinato
    RET

##
# video: scrive su video il carattere il cui codice ASCII e' contenuto in BL; i
# caratteri inviati su video vengono effettivamente visualizzati quando viene
# inviati su video il carattere '\n' (nuova linea); viene inserito dal driver
# del video anche il carattere '\r' (ritorno carrello).
##
video:
    PUSHQ   %RAX                # salva il contenuto dei registri
    PUSHQ   %RBX
    PUSHQ   %RCX
    PUSHQ   %RDX
    MOVB    %BL, buff(%RIP)
    MOVQ    $4, %RAX            # primitiva UNIX write
    MOVQ    $1, %RBX            # uscita standard
    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di uscita
    MOVQ    $1, %RDX            # numero byte da scrivere
    INT     $0x80               # invoke system call
    POPQ    %RDX
    POPQ    %RCX
    POPQ    %RBX
    POPQ    %RAX                # contenuto dei registri ripristinati
    RET

##
# uscita: restituisce il controllo al sistema operativo.
##
uscita:
    MOVL    $0, %EBX    # risultato per sistema operativo UNIX
    MOVL    $1, %EAX    # primitiva UNIX exit
                        # [1]
    INT     $0x80       # Invokes system call - in this case system call number
                        # 1 with argument 0
                        # [2]

# [1]
# On many computer operating systems, a computer process terminates its
# execution by making an exit system call. More generally, an exit in a
# multithreading environment means that a thread of execution has stopped
# running. For resource management, the operating system reclaims resources
# (memory, files, etc.) that were used by the process. The process is said to be
# a dead process after it terminates. Under Unix and Unix-like operating
# systems, a process is started when its parent process executes a fork system
# call. The parent process may then wait for the child process to terminate, or
# may continue execution (possibly forking off other child processes). When the
# child process terminates ("dies"), either normally by calling exit, or
# abnormally due to a fatal error or signal (e.g., SIGTERM, SIGINT, SIGKILL), an
# exit status is returned to the operating system and a SIGCHLD signal is sent
# to the parent process. The exit status can then be retrieved by the parent
# process via the wait system call.

# [2]
# You can make use of Linux system calls in your assembly programs. You need to
# take the following steps for using Linux system calls in your program:
#
# 1. Put the system call number in the EAX register.
# 2. Store the arguments to the system call in the registers EBX, ECX, etc.
# 3. Call the relevant interrupt (80h).
# 4. The result is usually returned in the EAX register.
# There are six registers that store the arguments of the system call used.
# These are the EBX, ECX, EDX, ESI, EDI, and EBP. These registers take the
# consecutive arguments, starting with the EBX register. If there are more than
# six arguments, then the memory location of the first argument is stored in the
# EBX register.

