#*******************************************************************************
# File: esercizio2.s
#       32-bit Assembly translation for esercizio2.cpp.
#
#       Compile using:
#           g++ -g -m32 -no-pie esercizio2.s prova2.cpp
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/07/2019
#*******************************************************************************

#-------------------------------------------------------------------------------
.TEXT
.GLOBAL ff
#-------------------------------------------------------------------------------
ff:
    pushl   %ebp
    movl    %esp, %ebp
    subl    $28, %esp       # int i;      <- 4 bytes
                            # miastr lav; <- 24 bytes

    pushl   %ecx    # save general purpose registers content
    pushl   %edx
    pushl   %edi
    pushl   %esi

    movl    8(%ebp), %eax   # return value address
    movl    $0, -28(%ebp)   # lav.a = 0;

# for (i = 0; i < 5; i++)
    movl    $0, -4(%ebp)    # i = 0
ciclo1:
    cmpl    $5, -4(%ebp)    # if i < 5
    jl      avan1           # continue loop
    jmp     finec1          # end loop
avan1:
    movl    -4(%ebp), %edx              # edx = i
    movl    16(%ebp, %edx, 4), %ecx     # ecx = stru.vv[i]
    addl    %ecx, -28(%ebp)             # lav.a += stru.vv[i];
    incl    -4(%ebp)                    # i++
    jmp     ciclo1                      # loop again

finec1:                                 # end loop 1
    movl    $0, -4(%ebp)                # i = 0;

ciclo2:                                 # while (stru.vv[i] > 0 && i < 5)
    movl    -4(%ebp), %ecx              # ecx = i
    cmpl    $0, 16(%ebp, %ecx, 4)       # stru.vv[i] > 0
    jle     finec2
    cmpl    $5, -4(%ebp)                # i < 5
    je      finec2
    movl    -4(%ebp), %edx
    movl    12(%ebp), %ecx              # ecx = stru.a
    movl    %ecx, -24(%ebp, %edx, 4)    # lav.vv[i] = stru.a;
    incl    -4(%ebp)                    # i++;
    jmp     ciclo2                      # loop again

finec2:                                 # end loop 2

ciclo3:                     # for (; i < 5; i++)
    cmpl    $5, -4(%ebp)    # i < 5
    jl      avan3           # continue loop
    jmp     finec3          # end loop

avan3:
    movl    -4(%ebp), %edx          # edx = i
    movl    $0, -24(%ebp, %edx, 4)  # lav.vv[i] = 0;
    incl    -4(%ebp)                # i++
    jmp     ciclo3                  # loop again

finec3:                             # end loop 3
    movl    %eax, %edi
    leal    -28(%ebp), %esi
    cld
    movl    $6, %ecx
    rep
    movsl

    popl    %esi    # restore general purpore registers content
    popl    %edi
    popl    %edx
    popl    %ecx

    leave           # return
    ret
#*******************************************************************************

#*******************************************************************************
# ACTIVATION FRAME LAYOUT
# The following is how the activation frame for the ff function looks like:
#
#   ----------------------
#  |         lav          |   -24(%ebp)
#  |______________________|
#  |          i           |   -4(%ebp)
#  |----------------------|
#  |         EBP          |   %ebp
#  |----------------------|
#  |         EIP          |   %eip
#  |----------------------|
#  | return val [address] |   +8(%ebp)
#  |----------------------|
#  |        stru.a        |   +12(%ebp)
#  |----------------------|
#  |        stru.vv       |   +16(%ebp)
#  |----------------------|
#
#*******************************************************************************

#*******************************************************************************
# GDB ACTIVATION FRAME VIEW
# The following is the activation frame for the ff function from gdb:
#
#   Breakpoint 1, main (argc=1, argv=0xffffd144) at prova2.cpp:37
#   warning: Source file is more recent than executable.
#   37	    str1 = ff(stru);
#
#   (gdb) info frame
#   Stack level 0, frame at 0xffffd0b0:
#    eip = 0x80492b3 in main (prova2.cpp:37); saved eip = 0xf7b168b9
#    source language c++.
#    Arglist at 0xffffd098, args: argc=1, argv=0xffffd144
#    Locals at 0xffffd098, Previous frame's sp is 0xffffd0b0
#    Saved registers:
#     ebx at 0xffffd094, ebp at 0xffffd098, eip at 0xffffd0ac
#
#   (gdb) s
#   ff () at esercizio2.s:17
#   17	    pushl   %ebp
#
#   (gdb) x/8x $sp
#   0xffffcffc:	0x080492d1	0xffffd020	0x00000005	0x00000001
#   0xffffd00c:	0x00000002	0x00000003	0x00000000	0x00000005
#
#*******************************************************************************

