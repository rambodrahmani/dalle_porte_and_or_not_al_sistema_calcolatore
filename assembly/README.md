# Assembly

## Appunti di Programmazione Assembly.

The following is quoted from the book "REVERSING - Secrets of Reverse
Engineering"

In order to understand low-level software, one must understand assembly
language. For most purposes, assembly language is the language of reversing, and
mastering it is an essential step in becoming a real reverser, because with most
programs assembly language is the only available link to the original source
code.

The following sections provide a quick introduction to the world of assembly
language, while focusing on the IA-32 (Intel's 32-bit architecture), which is
the basis for all of Intel's x86 CPUs from the historical 80386 o the modern-day
implementations. I've chosen to focus on the Intel IA-32 assembly language
because it is used in every PC in the world and is by far the msot popular
processor architecture out there.

### The AT&T Assembly Language Notation
Enev though the assembly language instruction format described here follows the
notation used in the official IA-32 documentation provided by Intel, it is not
the only notation used for presenting IA-32 assembly language code. The AT&T
Unix notation is another notation for assembly language instructions that is
quite different from the Intel notation. In the AT&T notation the source operand
usually precedes the destination operand (the opposite of how it is done in the
Intel notation). Also, register names are prefixed with an % (so that EAX is
referenced as %EAX). Memory addresses are denoted using parantheses, so that
%(EBX) means "the address pointed to by EBX". The AT&T notation is mostly used
in Unix development tools such as the GNU tools, while the Intel notation is
primarily used in Windows tools.

