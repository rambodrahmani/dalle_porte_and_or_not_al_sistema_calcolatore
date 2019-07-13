#*******************************************************************************
# File: esercizio1.s
#       32-bit Assembly translation for esercizio1.cpp.
#
#       Compile using:
#           g++ -g -m32 -no-pie esercizio1.s prova1.cpp
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/07/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.TEXT
.GLOBAL fz
#-------------------------------------------------------------------------------
fz:
    pushl   %ebp
    movl    %esp, %ebp
    subl    $4, %esp        # int i;

    pushl   %eax            # save general purpose registers content
    pushl   %ebx
    pushl   %ecx

# for (i = 0; i < 5; i++)
    movl    $0, -4(%ebp)    # i = 0
ciclo1:
    cmpl    $5, -4(%ebp)    # i < 5
    jl      avan1           # continue looping
    jmp     fine1           # exit loop

avan1:
    movl    8(%ebp), %eax               # eax = p
    movl    -4(%ebp), %ebx              # ebx = i
    movl    (%eax, %ebx, 4), %eax       # eax = p->a[i]
    cmpl    %eax, 12(%ebp, %ebx, 4)     # if (p->a[i] == s.a[i])
    jne     step1
    movl    8(%ebp), %eax               # eax = p
    movl    -4(%ebp), %ebx              # ebx = i
    movl    44(%ebp, %ebx, 4), %ecx     # ecx = s.b[i]
    movl    %ecx, 32(%eax, %ebx, 4)     # p->b[i] = s.b[i]

step1:
    incl    -4(%ebp)                    # i++
    jmp     ciclo1                      # loop again

fine1:                                  # end loop 1

# for (i = 5; i < 8; i++)
    movl    $5, -4(%ebp)    # i = 5
ciclo2:
    cmpl    $8, -4(%ebp)    # i < 8
    jl      avan2           # continue looping
    jmp     fine2           # exit loop

avan2:
    movl    8(%ebp), %eax               # eax = p
    movl    -4(%ebp), %ebx              # ebx = i
    movl    32(%eax, %ebx, 4), %ecx     # ecx = s.b[i]
    addl    %ecx, %ecx                  # ecx *= 2;
    movl    %ecx, 32(%eax, %ebx, 4)     # p->b[i] = ecx
    incl    -4(%ebp)                    # i++
    jmp     ciclo2                      # loop again

fine2:                                  # end loop 2

    popl    %ecx    # restore general purpore registers content
    popl    %ebx
    popl    %eax

    leave           # return
    ret
#*******************************************************************************

#*******************************************************************************
# ACTIVATION FRAME LAYOUT
# The following is how the activation frame for the fz function looks like:
#
#   ______________________
#  |          i           |   -4(%ebp)
#  |----------------------|
#  |         EBP          |   %ebp
#  |----------------------|
#  |         EIP          |   %eip
#  |----------------------|
#  |   sc* p  [address]   |   +8(%ebp)
#  |----------------------|
#  |    sc s   -   s.a    |   +12(%ebp)
#  |----------------------|
#  |    sc s   -   s.b    |   +44(%ebp)
#  |----------------------|
#
#*******************************************************************************

#*******************************************************************************
# GDB ACTIVATION FRAME VIEW
# The following is the activation frame for the fz function from gdb:
#
#   Breakpoint 1, main (argc=1, argv=0xffffd104) at prova1.cpp:78
#   78	    fz(pu, stt1);
#
#   (gdb) info frame
#   Stack level 0, frame at 0xffffd070:
#    eip = 0x80495a9 in main (prova1.cpp:78); saved eip = 0xf7b168b9
#    source language c++.
#    Arglist at 0xffffd058, args: argc=1, argv=0xffffd104
#    Locals at 0xffffd058, Previous frame's sp is 0xffffd070
#    Saved registers:
#     ebx at 0xffffd054, ebp at 0xffffd058, eip at 0xffffd06c
#
#   (gdb) s
#   fz () at esercizio1.s:17
#   17	    pushl   %ebp
#
#   (gdb) x/18x $sp
#   0xffffcf4c:	0x080495f0	0xffffd00c	0x00000000	0x00000002
#   0xffffcf5c:	0x00000004	0x00000004	0x00000005	0x00000006
#   0xffffcf6c:	0x00000007	0x00000008	0x0000000b	0x0000000c
#   0xffffcf7c:	0x0000000d	0x0000000e	0x0000000f	0x00000010
#   0xffffcf8c:	0x00000011	0x00000012
#
#   (gdb) x/uw 0xffffd00c
#   0xffffd00c:	1
#
#   (gdb) x/16uw 0xffffd00c
#   0xffffd00c:	1	2	3	4
#   0xffffd01c:	5	6	8	8
#   0xffffd02c:	10	20	30	40
#   0xffffd03c:	50	60	70	80
#
#   (gdb) x/8uw 0xffffd00c+32
#   0xffffd02c:	10	20	30	40
#   0xffffd03c:	50	60	70	80
#
#*******************************************************************************

