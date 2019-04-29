##
#
# File: util.s
#       Fornisce funzioni di utilita'. Da includere nei file assembly che
#       effettuano operazioni di I/O.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 29/04/2019.
#
##

.DATA
    buff:   .byte 0

.TEXT
tastiera:
    PUSHQ   %RBX
    PUSHQ   %RCX
    PUSHQ   %RDX
    MOVQ    $3, %RAX            # primitiva UNIX read
    MOVQ    $0, %RBX            # ingresso standard
    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di ingresso
    MOVQ    $1, %RDX            # numero di byte da leggere
    INT     $0x80
    MOVB    buff(%RIP), %AL
    POPQ    %RDX
    POPQ    %RCX
    POPQ    %RBX
    RET

video:
    PUSHQ   %RAX
    PUSHQ   %RBX
    PUSHQ   %RCX
    PUSHQ   %RDX
    MOVB    %BL, buff(%RIP)
    MOVQ    $4, %RAX            # primitiva UNIX write
    MOVQ    $1, %RBX            # uscita standard
    LEAQ    buff(%RIP), %RCX    # indirizzo buffer di uscita
    MOVQ    $1, %RDX            # numero byte da scrivere
    INT     $0x80
    POPQ    %RDX
    POPQ    %RCX
    POPQ    %RBX
    POPQ    %RAX
    RET

uscita:
    MOVL    $0, %EBX    # risultato per UNIX
    MOVL    $1, %EAX    # primitiva UNIX exit
    INT     $0x80

