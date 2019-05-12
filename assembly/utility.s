##
# File: utility.s (C:/amb_GAS/utility)
#       Provides utility functions to be used with DOSBox.
#       DOSBox is a DOS-emulator that uses the SDL-library which makes DOSBox
#       very easy to port to different platforms. DOSBox has already been ported
#       to many different platforms, such as Windows, BeOS, Linux, MacOS X...
#
#       DOSBox also emulates CPU:286/386 realmode/protected mode, Directory
#       FileSystem/XMS/EMS, Tandy/Hercules/CGA/EGA/VGA/VESA graphics, a
#       SoundBlaster/Gravis Ultra Sound card for excellent sound compatibility
#       with older games...
#
#       DOSBox is totally free of charge and OpenSource.
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 12/05/2019
#
# Original version first seen here:
# http://docenti.ing.unipi.it/~a080368/Teaching/RetiLogiche/pdf/Esercizi/utility
##

.nolist

#------------------------------------------------------------------------------

# H=07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
# Return: AL = character read from standard input
#
# Notes:
#   - does not check ^C/^Break
#
# SeeAlso: AH=01h, AH=06h, AH=08h, AH=0Ah.

.TEXT

inchar: PUSH %EBX
        MOV  %AX,%BX 
        MOV  $0x07,%AH 
        INT  $0x21
        MOV  %BH,%AH
        POP  %EBX
        RET

/*
# Anche questo sembra funzionare

.DATA
appAL_128uTrq98: .byte 0			 		

.TEXT
inchar :PUSH %EAX
	MOV  $0x0,%EAX 
	PUSH %EBX
	PUSH %ECX
 	PUSH %EDX
	
	CALL _getch
	
	POP %EDX
	POP %ECX
	POP %EBX
	MOV %AL,appAL_128uTrq98
	POP %EAX 
	MOV appAL_128uTrq98,%AL 
	RET
*/

#------------------------------------------------------------------------------

# AH = 02h - WRITE CHARACTER TO STANDARD OUTPUT
# Entry: DL = character to write
# Return: AL = last character output
#
# Notes:
#   - ^C/^Break are checked
#   - the last character output will be the character in DL unless DL=09h on
#     entry, in which case AL=20h as tabs are expanded to blanks
#   - if standard output is redirected to a file, no error checks
#     (write-protected, full media, etc.) are performedSeeAlso: AH=06h,AH=09h

.TEXT
outchar: PUSH %EAX
         PUSH %EDX
         MOV $0x02,%AH
         MOV %AL,%DL
         INT $0x21
         POP %EDX
         POP %EAX
         RET
         
/*

#Anche questo sembra funzionare

.DATA
string_128uTrq98: .ASCII  "%c\0"

.TEXT
outchar: PUSH %EAX
         PUSH %ECX
         PUSH %EDX

         AND  $0X000000FF,%EAX
         PUSH %EAX
         MOV  $string_128uTrq98,%EAX
         PUSH %EAX
         CALL _printf
         POP  %EAX
         POP  %EAX

         POP  %EDX
         POP  %ECX
         POP  %EAX
         RET
*/

/*

# Forse per Linux

.DATA
tmp: .ASCII  "0"

.TEXT

outchar: PUSH %EAX 
         PUSH %EBX
         PUSH %ECX
         PUSH %EDX
         MOV %al,temp
         MOV $0,%EAX 
         MOV $0,,%ECX
         MOV $4,%EAX
         MOV $1,%EBX
         MOV $temp,%ECX
         MOV $1,%EDX
         INT $0x80
         POP %EDX
         POP %ECX
         POP %EBX
         POP %EAX
         ret
*/

//------------------------------------------------------------------------------

.TEXT
inbyte:  PUSH %EBX
         MOV  %AH,%BH
         CALL inhexchar
         CALL outchar
         MOV  %AL,%AH
         CALL inhexchar
         CALL outchar
         CALL HA2B8
         MOV  %BH,%AH
         POP  %EBX
         RET

//------------------------------------------------------------------------------

.TEXT
inword:  CALL inbyte
         MOV  %AL,%AH
         CALL inbyte
         RET

//------------------------------------------------------------------------------

.TEXT
indword:  CALL inword
         SHL  $16,%EAX
         CALL inword
         RET

//------------------------------------------------------------------------------

.TEXT
outbyte: PUSH %EAX
         CALL B8HA2
         XCHG %AL,%AH
         CALL outchar
         XCHG %AL,%AH
         CALL outchar
         POP  %EAX
         RET

//------------------------------------------------------------------------------

.TEXT
outword: XCHG %AL,%AH
         CALL outbyte
         XCHG %AL,%AH
         CALL outbyte
         RET

//------------------------------------------------------------------------------

.TEXT
outdword: ROL  $16, %EAX
              CALL outword
              ROL  $16,%EAX
              CALL outword
              RET

//------------------------------------------------------------------------------

.TEXT
newline: PUSH  %EAX
         MOV   $0x0D,%AL
         CALL  outchar
         MOV   $0x0A,%AL
         CALL  outchar
         POP   %EAX
         RET

#------------------------------------------------------------------------------

.DATA
L247513: .ASCII  "Checkpoint number "
L247003: .ASCII  "x. Press any key to continue"
L247893: .FILL 1,4

.TEXT
pause :  NOP
pause0:  MOVB $0x30,L247003
         JMP L271893     
pause1:  MOVB $0x31,L247003
         JMP L271893     
pause2:  MOVB $0x32,L247003
         JMP L271893     
pause3:  MOVB $0x33,L247003
         JMP L271893     
pause4:  MOVB $0x34,L247003
         JMP L271893     
pause5:  MOVB $0x35,L247003
         JMP L271893     
pause6:  MOVB $0x36,L247003
         JMP L271893
pause7:  MOVB $0x37,L247003
         JMP L271893     
pause8:  MOVB $0x38,L247003
         JMP L271893     
pause9:  MOVB $0x39,L247003
         JMP L271893     
L271893: PUSH %EAX
         PUSH %ECX  
         PUSH %ESI
         CALL newline
         MOV  $L247513,%ESI
         MOV  $(L247893-L247513),%CX
L247527: MOV  (%ESI),%AL
         CALL outchar
         INC  %ESI
         DEC  %CX
         JNZ  L247527
         CALL newline
         CALL inchar
         POP  %ESI
         POP  %ECX
         POP  %EAX
         RET

#---------------------------------------------------------------------------

.TEXT
inline:  CMP     $2,%CX
         JB      L409ABB  # salta a fine
         CMP     $80,%CX
         JA      L409ABB  # salta a fine

         PUSH    %EAX
         PUSH    %EBX
         PUSH    %ECX
             
L4004C:  CMP     $2, %CX      #ciclo
         JE      L40093       #salta a quasi fine
         CALL    inchar    
         CMP     $0x0D,%AL
         JE      L40093      # salta a quasi fine 
            
         CMP     $0x08,%AL   
         JE      L67193      #salta a elimina carattere
             
L50193:  CALL    outchar
         MOV     %AL,(%EBX)
         INC     %EBX
         DEC     %CX
         JMP     L4004C      #torna in ciclo

L67193:  DEC     %EBX        #elimina carattere
         INC     %CX
         MOV     $0x08, %AL
         CALL    outchar
         MOV     $0x20, %AL
         CALL    outchar 
         MOV     $0x08, %AL
         CALL    outchar
         JMP     L4004C
                 
L40093:  MOV     $0x0D,%AL   #quasi fine
         CALL    outchar
         MOV     %AL,(%EBX)
         INC     %EBX
         MOV     $0x0A,%AL
         CALL    outchar
         MOV     %AL,(%EBX)
         POP     %ECX
         POP     %EBX
         POP     %EAX
L409ABB: RET

#------------------------------------------------------------------------------

.TEXT
outline: PUSH %EAX
         PUSH %EBX
         PUSH %ECX
         MOV $80,%CX
L4001B:  MOV  (%EBX),%AL
         CMP  $0x0D,%AL
         JZ   L4002A
         DEC %CX
         JZ   L4002A
         CALL outchar
         INC  %EBX
         JMP  L4001B
L4002A:  CALL newline
		 POP  %ECX
         POP  %EBX
         POP  %EAX
         RET
#------------------------------------------------------------------------------

.TEXT
outmess:   PUSH   %EAX
	   PUSH   %EBX
	   PUSH   %ECX
L087509:   CMP    $0,%CX
	   JE     L087508
	   MOV    (%EBX),%AL
	   CALL   outchar
	   INC    %EBX
	   DEC    %CX
	   JMP    L087509
L087508:   POP    %ECX
	   POP    %EBX
	   POP    %EAX
	   RET

#------------------------------------------------------------------------------

.TEXT
inhexchar: CALL  inchar
            CMP   $'0',%AL
            JB    inhexchar
            CMP   $'F',%AL
            JA    inhexchar
            CMP   $'9',%AL
            JBE   L3A89B3
            CMP   $'A',%AL
            JB    inhexchar
L3A89B3:    RET

#------------------------------------------------------------------------------

.TEXT
B4HA1:    AND    $0x0F,%AL
          CMP    $9,%AL
          JA     L3ACD37
L3ACD30:  ADD    $0x30,%AL
          RET
L3ACD37: ADD    $0x37,%AL
          RET

#------------------------------------------------------------------------------

.TEXT
B8HA2: PUSH    %ECX
       MOV     %AL,%CH
       SHR     $4,%AL
       CALL    B4HA1
       MOV     %AL,%AH
       MOV     %CH,%AL
       CALL    B4HA1
       POP     %ECX
       RET

#------------------------------------------------------------------------------

HA1B4:    CMP     $'9',%AL
          JA      L3KCD37
sub_0x30: SUB     $0x30,%AL
          RET
L3KCD37:  SUB     $0x37,%AL
          RET

#------------------------------------------------------------------------------

.TEXT
HA2B8:   PUSH  %ECX
         MOV   %AL,%CH
         MOV   %AH,%AL
         CALL  HA1B4
         MOV   %AL,%AH
         ROL   $4,%AH 
         MOV   %CH,%AL
         CALL  HA1B4
         OR    %AH,%AL 
         POP   %ECX
         RET

#------------------------------------------------------------------------------

outdecimal_tiny:  PUSH %EAX  
                  AND  $0x000000FF,%EAX 
                  CALL outdecimal_long 
                  POP  %EAX 
                  RET 

#------------------------------------------------------------------------------

outdecimal_short:  PUSH %EAX  
                  AND  $0x0000FFFF,%EAX 
                  CALL outdecimal_long 
                  POP  %EAX 
                  RET 

#-----------------------------------------------------------

.DATA
resti_cifre:      .fill 11,1

.TEXT
outdecimal_long:  PUSH  %EAX
				  PUSH  %EBX
                  PUSH  %ECX
                  PUSH  %EDX
                  PUSH  %ESI
				  PUSH  %EDI
				  PUSH  %EBP

                  MOV   $10,%ECX
                  CMP   $999999999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $99999999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $9999999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $999999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $99999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $9999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $999,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $99,%EAX
                  JA    long_L4013K
                  DEC   %ECX
                  CMP   $9,%EAX
                  JA    long_L4013K
                  DEC   %ECX

long_L4013K:      LEA   resti_cifre,%EDI
				  MOV   %ECX, %EBP
                  ADD   %ECX,%EDI      # EDI punta sotto alla cifra da inserire per prima
                  DEC   %EDI           # EDI torna a puntare alla prima cifra da inserire
ciclolongL4013K:  MOV   $0,%EDX        # costruzione del dividendo EDX:EAX
                  MOV   $10,%ESI       # divisore in ESI
                  DIVL  %ESI   
                  AND   $0x0000000F,%EDX # sistemazione del resto_cifra codificato ASCII
                  ADD   $0x30,%DL
                  MOV   %DL,(%EDI) 

                  DEC   %EDI   
                  DEC   %ECX
                  CMP   $0,%ECX        # Controllo fine ciclo
                  JNE   ciclolongL4013K

                  LEA   resti_cifre,%EBX
				  MOV   %EBP, %ECX
                  CALL  outmess  

				  POP   %EBP
				  POP   %EDI
                  POP   %ESI
                  POP   %EDX
                  POP   %ECX
				  POP   %EBX
                  POP   %EAX
                  RET

#------------------------------------------------------------------------------

.TEXT
indecimal_tiny:   MOVB  $3,num_cifre_1eWK7
                  PUSH %EBX
                  PUSH %EAX
                  CALL converti_1eWK6
                  MOV  %AL,%BL
                  POP  %EAX
                  MOV  %BL,%AL
                  POP  %EBX
                  RET

indecimal_short:   MOVB  $5,num_cifre_1eWK7
                  PUSH %EBX
                  PUSH %EAX
                  CALL converti_1eWK6
                  MOV  %AX,%BX
                  POP  %EAX
                  MOV  %BX,%AX
                  POP  %EBX
                  RET

indecimal_long:   MOVB  $10,num_cifre_1eWK7
                  CALL  converti_1eWK6
                  RET

#------------------------------------------------------------------------------
# Converta da decimale a binario in EAX

.DATA
prodotti_parziali_1eWK7:   .fill 1,4
num_cifre_1eWK7:           .fill 1,1

.TEXT   
converti_1eWK6:    NOP
P_di_0_1eWK7:      MOVL  $0, prodotti_parziali_1eWK7
                 
ciclo_1eWK7:       CMPB  $0x00,num_cifre_1eWK7     # termina se cifre finite
                   JE    fine_1eWK7
new_cifra_1eWK7:   CALL  inchar                    # prelievo eventuale nuova cifra
                   CMP   $0x0D,%AL                 # termina se ritorno carrello
                   JE    fine_1eWK7 
                   
                   CMP   $'0',%AL                  # scarta cifre non decimali
                   JB    new_cifra_1eWK7
                   CMP   $'9',%AL
                   JA    new_cifra_1eWK7
                   CALL  outchar

                   PUSH  %EAX                      # nuovo prodotto parziale
                   MOV   $10,%EAX
                   MULL  prodotti_parziali_1eWK7    
                   MOV   %EAX,prodotti_parziali_1eWK7
                   POP   %EAX          
                   AND   $0x0000000F,%EAX
                   ADDL  %EAX, prodotti_parziali_1eWK7

                   DECB  num_cifre_1eWK7                  
                   JNE   ciclo_1eWK7                        
                  
fine_1eWK7:        MOV   prodotti_parziali_1eWK7,%EAX 
                   RET

#-------------------------------------------------------------------------

.DATA
LZ647513: .BYTE   0x0A,0x0D,0x0A,0x0D
          .ASCII  "Press Q to exit . . . "
LZ567893: .BYTE

.TEXT
exit:          MOV  $LZ647513,%ESI
               MOV  $(LZ567893-LZ647513),%CX
LZ247AA7:      MOV  (%ESI),%AL
               CALL outchar
               INC  %ESI
               DEC  %CX
               JNZ  LZ247AA7
waitQ_LZc247A: CALL inchar
               CMP  $'Q',%AL
               JNE  waitQ_LZc247A
               MOV $0x4C,%AH     # per Linux MOV $0x0001,%AX
               INT $0x21         # per Linux INT $0x80
          
#----------------------------------------------------------------------------- 

.global _main

