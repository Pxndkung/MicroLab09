T2CON   EQU     0C8H
RCAP2L  EQU     0CAH
RCAP2H  EQU     0CBH

        ORG     0000H
        JMP     START

        ORG     0100H
START:
        MOV     SP, #3FH
        CLR     EA
        MOV     TMOD, #20H
        MOV     SCON, #50H
        MOV     TH1, #0F3H
        SETB    TR1
        MOV     R4, #0
        MOV     R5, #0
        SETB    P3.2
        SETB    P3.7

MAIN_LOOP:
        JNB     RI, PROCESS_STATE
        MOV     A, SBUF
        CLR     RI
        MOV     R2, A
        MOV     R0, #0

CHECK_LOOP:
        MOV     A, R0
        MOV     DPTR, #CHECK_LIST
        MOVC    A, @A+DPTR
        JZ      NOT_FOUND
        XRL     A, R2
        JZ      FOUND_IT
NEXT_CH:
        INC     R0
        SJMP    CHECK_LOOP

FOUND_IT:
        JMP     MODE_SL

NOT_FOUND:
        MOV     A, #16
        CALL    DISPLAY
        CLR     P3.2
        CLR     P3.7
        MOV     R5, #0
        SJMP    MAIN_LOOP

PROCESS_STATE:
        MOV     A, R5
        JZ      MAIN_LOOP
        CJNE    A, #1, CHECK_DOWN
        INC     R4
        MOV     A, R4
        CJNE    A, #10, SHOW_NOW
        MOV     R4, #0
        SJMP    SHOW_NOW

CHECK_DOWN:
        DEC     R4
        MOV     A, R4
        CJNE    A, #0FFH, SHOW_NOW
        MOV     R4, #9

SHOW_NOW:
        MOV     A, R4
        CALL    DISPLAY
        CALL    DELAY
        SJMP    MAIN_LOOP

MODE_SL:
        MOV     A, R0
        CJNE    A, #9, CHECK_IF_NUM
        JMP     DO_COUNT_DOWN

CHECK_IF_NUM:
        JC      DO_BLINK
        CJNE    A, #10, NOT_ADD
        JMP     DO_COUNT_UP
NOT_ADD:
        CJNE    A, #11, NOT_ZERO
        JMP     DO_HOLD
NOT_ZERO:
        JMP     MAIN_LOOP

DO_BLINK:
        SETB    P3.7
        MOV     R3, A
        INC     R3
        MOV     A, #16
        CALL    DISPLAY
        SETB    P3.2
        MOV     R5, #0
BLINK_LOOP:
        SETB    P3.7
        CALL    DELAY_BLINK
        CLR     P3.7
        CALL    DELAY_BLINK
        DJNZ    R3, BLINK_LOOP
        CLR     P3.7
        SJMP    MAIN_LOOP

DO_COUNT_UP:
        CLR     P3.7
        CLR     P3.2
        MOV     R5, #1
        JMP     MAIN_LOOP

DO_COUNT_DOWN:
        CLR     P3.7
        CLR     P3.2
        MOV     R5, #2
        JMP     MAIN_LOOP

DO_HOLD:
        CLR     P3.7
        CLR     P3.2
        MOV     R5, #0
        JMP     MAIN_LOOP

DISPLAY:
        MOV     DPTR, #SEG_TAB
        MOVC    A, @A+DPTR
        CPL     A
        MOV     P0, A
        RET

DELAY:
        MOV     R1, #10
D3:     MOV     R6, #200
D1:     MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, D1
        DJNZ    R1, D3
        RET

DELAY_BLINK:
        MOV     R1, #8
DB3:    MOV     R6, #200
DB1:    MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, DB1
        DJNZ    R1, DB3
        RET

SEG_TAB:
        DB      3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H
        DB      7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
        DB      40H

CHECK_LIST:
        DB      '1', '2', '3', '4', '5', '6', '7', '8', '9'
        DB      '-', '+', '0', 0

        END
