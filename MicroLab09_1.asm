# MicroLab09
T2CON   EQU     0C8H
RCAP2L  EQU     0CAH
RCAP2H  EQU     0CBH

        ORG     0000H
        JMP     0100H

        ORG     0100H
START:
        MOV     SP, #3FH
        CLR     EA

        MOV     TMOD, #20H 
        MOV     SCON, #50H
        MOV     TH1, #0F3H
        SETB    TR1

MAIN_LOOP:
        CLR     RI
        JNB     RI, $
        MOV     A, SBUF

_IS_ASCII_A:
        CJNE    A, #'A', _IS_ASCII_B
        MOV     A, #0AH
        CALL    DISPLAY
        SETB    P2.7
        JMP     MAIN_LOOP

_IS_ASCII_B:
        CJNE    A, #'B', _IS_ASCII_ETC
        MOV     A, #0BH
        CALL    DISPLAY
        CLR     P2.7
        JMP     MAIN_LOOP

_IS_ASCII_ETC:
        NOP
        JMP     MAIN_LOOP

DISPLAY:
        MOV     DPTR, #SEG_TAB
        MOVC    A, @A+DPTR
        CPL     A
        MOV     P0, A
        CLR     P1.4
        CLR     P1.5
        RET

SEG_TAB:
        DB      03FH, 006H, 05BH, 04FH, 066H, 06DH, 07DH, 007H
        DB      07FH, 06FH, 077H, 07CH, 039H, 05EH, 079H, 071H

        END
