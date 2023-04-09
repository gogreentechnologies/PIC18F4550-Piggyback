	 Title "IP8-3 ASCII to Binary"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

ASCII	EQU		0x00		;Define registers that are used
CHECK1	EQU		0x01
CHECK2	EQU		0x02

ASCIIBIN:;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: This subroutine takes an ASCII Hex digit, masks its parity bit.  If the digit is :
		;	    less than 30H it sends out an error code; otherwise, it converts the number    :
		;	    into its binary equivalent                                                                                   :
		;Input: 	    ASCII digit in WREG                                                                                       :
		;Output:	    Binary equivalent of ASCII digit in WREG                                                     :
		;Modifies the contents in WREG                                                                                         :
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

		ANDLW		B'01111111'	;Mask parity bit B7
		MOVWF		ASCII		;Save Hex digit 
		MOVLW		0x2F		;Check invalid ASCII Hex digits 
		MOVWF		CHECK1	
		MOVLW		D'10'		;Check for ASCII larger than digit 9
		MOVWF		CHECK2	
		MOVF		ASCII,W		;Get original ASCII characters
		CPFSLT		CHECK1		;Is value less than 30H
		BRA			ILLEGAL		;If yes, go to display illegal code
		MOVLW		0x30
		SUBWF		ASCII,0,0	;Find ASCII digits from 0 to 9
		CPFSLT	CHECK2			;If larger than 9, find A through F
		RETURN
		MOVWF		ASCII		;Subtract additional 7 to find A to F
		MOVLW		0x07
		SUBWF		ASCII,0,0
		RETURN		
ILLEGAL:MOVLW		0xFF		;Hex code less than 30H
		RETURN
		
		END

