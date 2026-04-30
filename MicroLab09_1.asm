	ORG     0000H
        JMP     0100H

        ORG     0100H
START:
        MOV     SP, #3FH
        CLR     EA
        SETB    P1.0
        JB      P1.0, $
        CALL    DELAY_500MS

        MOV     TMOD, #21H
        MOV     SCON, #50H
        MOV     TH1, #0F3H
        SETB    TR1

        MOV     R0, #10
SEND_10_LINES:
        MOV     DPTR, #MY_INFO
        CALL    SEND_STRING
        CALL    DELAY_500MS
        DJNZ    R0, SEND_10_LINES

        MOV     DPTR, #WANT_A
        CALL    SEND_STRING
        
        JMP     $

SEND_STRING:
        CLR     A
        MOVC    A, @A+DPTR
        JZ      END_STRING
        MOV     SBUF, A
WAIT_TI:
        JNB     TI, WAIT_TI
        CLR     TI
        INC     DPTR
        JMP     SEND_STRING
END_STRING:
        RET

DELAY_500MS:
        MOV     R7, #5
DLY_OUTER:
        MOV     R6, #200
DLY_INNER:
        MOV     R5, #250
DLY_LOOP:
        DJNZ    R5, DLY_LOOP
        DJNZ    R6, DLY_INNER
        DJNZ    R7, DLY_OUTER
        RET

MY_INFO: 
        DB 'B6729943 Chokchai Chokkoed',0AH, 0
WANT_A:  
        DB 'I Want A', 0DH,0

        END
