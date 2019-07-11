#*******************************************************************************
# File: codifica7b.s
#       Assembly version for codifica6b.cpp.
#       Reads the input chars from the keyboard and prints out the corresponding
#       ASCII char binary code for each input.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 11/0y/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.TEXT
.GLOBAL esamina
#-------------------------------------------------------------------------------
esamina:
    # 8(%RBP)  = char aa
    # 12(%RBP) = &bb[0]

    PUSHQ   %RBP            # activation frame
    MOVQ    %RSP, %RBP
    SUBQ    $4, %RSP        # int i;
                            # -4(%RBP)

    PUSHQ   %RAX            # save general registers content
    PUSHQ   %RBX
    PUSHQ   %RSI

# retrieve function actual parameters from stack
    MOVB    8(%RBP), %AL    # char aa
    MOVQ    12(%RBP), %RBX  # &bb[0]

    MOVQ    $0, -4(%RBP)    # i = 0

# for (i = 0; i < 8; i++)
ciclo:
    MOVQ    -4(%RBP), %RSI
    TESTB   $0x80, %AL
    JZ      zero
    MOVB    $'1', (%RBX, %RSI)  # bb[i] = '1';
    JMP     avanti

zero:
    MOVB    $'0', (%RBX, %RSI)  # bb[i] = '0';

avanti:
    SHLB    $1, %AL         # aa = aa << 1;
    INCQ    -4(%RBP)        # i++
    CMPQ    $8, -4(%RBP)    # i < 8
    JB      ciclo

    POPQ    %RSI            # restore general registers content
    POPQ    %RBX
    POPQ    %RAX

    LEAVE                   # return
    RET
#*******************************************************************************

