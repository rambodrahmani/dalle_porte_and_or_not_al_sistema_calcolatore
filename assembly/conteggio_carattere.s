##
# Scrivere un programma che legge una stringa di memoria lunga un numero
# arbitrario di caratteri (ma terminata da \0), inserita in un buffer di memoria
# di indirizzo noto, e conta le volte che appare il carattere specificato dentro
# un’altra locazione di memoria. Il risultato viene messo in una terza locazione
# di memoria.
##
.GLOBAL _start

.DATA
    stringa:    .ASCIZ  "Questa e' una stringa di prova che usiamo come esempio"
    lettera:    .BYTE   'e'
    conteggio:  .BYTE   0x00

.TEXT
_main:
    NOP
    MOV     $0x00,      %CL
    LEA     stringa,    %ESI
    MOV     lettera,    %AL

comp:
    CMPB    $0x00,      (%ESI)
    JE      fine
    CMP     (%ESI),     %AL
    JNE     poi
    INC     %CL

poi:
    INC     %ESI
    JMP     comp

fine:
    
    MOVL    $0, %EBX    # risultato per UNIX
    MOVL    $1, %EAX    # primitiva UNIX exit

