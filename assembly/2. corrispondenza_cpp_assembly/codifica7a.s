#*******************************************************************************
# File: codifica7a.s
#       Assembly version for codifica6a.cpp.
#       Reads the input chars from the keyboard and prints out the corresponding
#       ASCII char binary code for each input.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/0y/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.INCLUDE "servizio.s"
#-------------------------------------------------------------------------------
.TEXT
.GLOBAL main
#-------------------------------------------------------------------------------
main:
    PUSHQ   %RBP            # acitvation fram
    MOVQ    %RSP, %RBP
    SUBQ    $16, %RSP       # char kappa[8]; char cc; int i;
                            # -16(%RBP) = &kappa[0]
                            # -8(%RBP) = cc
                            # -4(%RBP) = i

    PUSHQ   %RSI            # save general register content

# for (;;)
ancora:
    CALL    leggisuccessivo     # cin.get(cc);
    MOVB    %AL, -8(%RBP)
    CMPB    $'\n', -8(%RBP)     # if (cc == '\n')
    JE      fine                # break
    MOVB    -8(%RBP), %DIL
    CALL    scrivicarattere     # cout << cc << " ";
    CALL    scrivispazio

# prepare for subroutine call
    LEAQ    -16(%RBP), %RSI     # &kappa[0] parameter
    PUSHQ   %RSI
    PUSHQ   -8(%RBP)            # cc parameter
    CALL    esamina             # call subroutine

# clear stack on return
    ADDQ    $8, %RSP

# for (i = 0; i < 8; i++)
    MOVQ    $0, -4(%RBP)        # i = 0
ripeti:
    MOVQ    -4(%RBP), %RSI
    MOVB    -16(%RBP, %RSI), %DIL   # kappa[i]
    CALL    scrivicarattere
    INCQ    -4(%RBP)                # i++
    CMPQ    $8, -4(%RBP)            # i < 8
    JB      ripeti
    CALL    nuovalinea              # cout << endl;

    JMP     ancora

fine:
    POP     %RSI            # restore general register content
    XORQ    %RAX, %RAX

    LEAVE
    RET
#*******************************************************************************

