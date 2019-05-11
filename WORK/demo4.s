# Ulteriore variante di demo1 in cui e' utilizzato il sottoprogramma outmess

.DATA
mess:       .BYTE   0x0A,0x0D
            .ASCII  "Tutto OK"

.TEXT
_main:      NOP
            MOV  $mess,%EBX # Passaggio dei parametri
            MOV  $10,%CX    # necessari al sottoprogramma
visualizza: CALL outmess

            CALL exit

.INCLUDE "C:/amb_GAS/utility" 
