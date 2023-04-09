	Title "PIC18F452 IP8-7 Temperature Display"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file

BUFFER		EQU		0x10
COUNTER		EQU		0x01
TEMP		EQU		0x02


MAIN:	BTFSS	STATUS,C		;Is there a set of new data?
		BRA		MAIN			;If yes, skip this instruction
		LFSR	FSR0, BUFFER	;Set up pointer for where data begins
		RCALL	CHKNULL			;Find number of bytes in data string
		LFSR	FSR0, BUFFER	;Set up pointer for data again
		MOVFF	COUNTER,TEMP	;Save the count in temporary register
		RCALL	ADDITION		;Add temperature readings
		MOVFF	TEMP,COUNTER 	;Get the count again to find average
		RCALL	AVG				;Find average temperature
		MOVF	QUOTIENT,W		;Copy the average in WREG
		RCALL	BINBCD			;Convert temperature reading in BCD
		MOVF	BUFF0,W
		RCALL 	BINASC			;Convert BCD numbers in ASCII codes
		MOVWF	BUFF0
		MOVF	BUFF1,W
		RCALL 	BINASC
		MOVWF	BUFF1
		MOVF	BUFF2,W
		RCALL 	BINASC
		MOVWF	BUFF2
		BRA		MAIN			;Go back to check new data

CHKNULL:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	;Function: This subroutine counts the number of temperature:
	;	     readings in the data string until it finds the  :
	;          null character.                                 :
	;Input:    Address in FSR0 to point to data string	     :
	;Output:   Count in COUNTER register representing the      :
	;          number of bytes in data string                  :
	;Registers Changed: FSR0
	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		CLRF	COUNTER			;Clear counter
AGAIN:	INCF	COUNTER,1		;Begin counting
TEST:	TSTFSZ 	POSTINC0		;Check for 00 and increment pointer
		BRA		AGAIN			;Continue checking
		DECF	COUNTER,1		;Adjust counter for extra increment
		RETURN

ADDITION:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function: Adds the data bytes in the data string          :
			;Input:    Address in FSR0 to point to data string	     :
			;	     Count of data bytes in COUNTER register         :
			;Output:   16-bit sum-High byte in CYREG and low byte in W :
			;Registers Changed: COUNTER and FSR0
            ;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CYREG	EQU 	0x03
		CLRF 	CYREG			;Clear carry register
		LFSR	FSR0,BUFFER		;Set up FSR0 as pointer for data registers
		MOVLW	0x00			;Clear W register to save sum
NEXTADD:	ADDWF	POSTINC0,W 		;Add byte and increment FSR0
		BNC		SKIP			;Check for carry-if no carry jump to SKIP
		INCF	CYREG,1			;If there is carry, increment CYREG
SKIP:	DECF	COUNTER,1,0		;Next count and save count in register
		BNZ		NEXTADD		;If COUNT =/ 0, go back to add next byte
		RETURN


AVG:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: Finds the average of 16-bit sum by dividing the                 :
 	    ; sum by the number of data bytes
		;Input:   16-bit sum - High-byte in CYREG and low-byte in W:
		;	     Count of data bytes in COUNTER register         :
		;Output:   Average reading in QUOTIENT register            :
		;Registers Changed: WREG
        ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

DIVIDNDLO	EQU	0x04			;Stores low byte of the sum
DIVIDNDHI	EQU	0x05			;Stores high byte of the sum
QUOTIENT	EQU	0x06			;Saves the average
DIVISOR		EQU	0x07			;Stores divisor

		MOVWF	DIVIDNDLO		;Get 16-bit sum
		MOVFF	CYREG, DIVIDNDHI
		MOVFF	COUNTER, DIVISOR	;Place count in DIVISOR register
		CLRF	QUOTIENT		;Clear to save result
SUBTRAC:	MOVF	DIVISOR,W		;Place count in WREG
		INCF	QUOTIENT,1		;Add one to average reading
		SUBWF	DIVIDNDLO,1		;Divide by subtracting
		BTFSC	STATUS, 0		;Is low byte negative?
		GOTO	SUBTRAC		;If not, go back to subtract again
		DECF	DIVIDNDHI,1		;Decrement high byte
		BTFSC	STATUS, 0		;Is high byte negative?
		GOTO	SUBTRAC		;If not, go back to subtract again
		DECF	QUOTIENT,1		;Adjust for extra addition in beginning
		RETURN

BINBCD:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	;Function: Converts a Hex data byte into three BCD digits  :
	;Input:    Hex data byte in W:
	;Output:   BCD digits in BUFF0, BUFF1, and BUFF2           :
	;Registers Changed: WREG
	;Calls BCD subroutine
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

BUFF0		EQU	0x20			;Define registers to save BCD digits
BUFF1		EQU	0x21
BUFF2		EQU	0x22
TEMPR		EQU	0x23

		CLRF	BUFF0			;Clear registers for BCD digits
		CLRF	BUFF1
		CLRF	BUFF2

		MOVWF	TEMPR			;Get the saved sum again
		LFSR	FSR0,BUFF2		;Set up pointer to BUFF2
		MOVLW	D'100' 		;Place 100  in WREG as a divisor
		RCALL	BCD			;Find BCD2 digit
		LFSR	FSR0, BUFF1		;Set up pointer to BUFF1
		MOVLW	D'10'			;Place 10  in WREG as a divisor
		RCALL 	BCD			;Find BCD1
		LFSR	FSR0, BUFF0		;Set up pointer to BUFF0
		MOVFF	TEMPR,BUFF0		;Remainder is BCD0
		RETURN

BCD:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: Converts Hex number into BCD one at a time      :
		;Input:    Hex data byte in TEMPR register                 :
		;	     Powers of ten as divisor in W and pointer FSR0
		;	     where BCD digit should be stored
		;Output:   BCD digit in register pointed by FSR0           :
		;Registers Changed: TMPR
        ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		INCF	INDF0,1		;Begin counting number of subtractions
		SUBWF	TEMPR,1		;Subtract powers of ten
		BTFSC	STATUS,C	;If C flag =0, skip next instruction
		GOTO	BCD			;If  C flag  =1, go back to next subtraction
		ADDWF	TEMPR,1		;One too many subtractions - adjust
		DECF	INDF0,1		;Adjust the last subtraction
		RETURN

BINASC:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	;Function: Converts BCD digit into ASCII character         :
	;Input:    BCD digit in WREG                               :
	;Output:   ASCII character in WREG                         :
	;Registers Changed: WREG                                   :
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ASCII	EQU		0x33

		MOVWF	ASCII			;Get BCD digit
		MOVLW	D'10'
		CPFSGT 	ASCII		;Is digit smaller than 9
		BRA		ADD30			;If yes, branch to add 30H
		MOVLW	0x07			;If no, add 07H
		ADDWF	ASCII,1,0

ADD30:	MOVLW	0x30
		ADDWF	ASCII,0,0		;Add 30H
		RETURN
		END



