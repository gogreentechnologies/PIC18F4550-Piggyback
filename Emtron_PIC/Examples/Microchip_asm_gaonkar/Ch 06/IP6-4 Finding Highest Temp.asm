	Title "IP6-4: Finding Max Temperature"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file 

REG0	EQU 	0x00			;Define data register address
BUFFER 	EQU		0x10			;Data stored starting from register 10H

		ORG	0x20				;Begin assembly at 0020H
START:	CLRF	REG0			;REG0 is used to store maximum temparature
		LFSR	FSR0,BUFFER		;Set up FSR0 as pointer for data registers	
NEXT:	MOVF	POSTINC0,W 		;Get data byte in WREG
		BZ		FINISH			;Is byte = 0? If yes, data string is finished
		BTFSC	WREG,7			;Is byte negative? If yes, go back; otherwise skip
		BRA		NEXT			;Byte is negative - go back
		CPFSLT	REG0,0			;Is byte larger than previous one? If yes, save
		BRA		NEXT			;Byte is smaller - get next one
		MOVWF	REG0			;Save larger byte
		BRA		NEXT			;Go back and check next byte
FINISH	NOP
		END
