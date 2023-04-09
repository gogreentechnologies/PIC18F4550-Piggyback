
; This program demonstrates how to read a push-button and control LED's.
;
; Port A is connected to 8 LEDs. 
; RB4 is connected to a switch (BOOT).
; This program increments a file register count every time PB4 is pressed.
; The value of count is displayed on the LEDs connected to Port A.
; The LEDs should increment in a binary manner each time Boot (RB4) is pressed.

#include<p18f4450.inc>

	CONFIG WDT=OFF; disable watchdog timer
	CONFIG MCLRE = ON; MCLEAR Pin on
	CONFIG DEBUG = OFF; Enable Debug Mode
	CONFIG LVP = OFF; Low-Voltage programming disabled (necessary for debugging)
	CONFIG FOSC = INTOSCIO_EC;Internal oscillator, port function on RA6
	
org 0; start code at 0

Count res 2 ;reserve 2 byte for the variable Delay1
 
Start:
	clrf	Count	; Clear Count
Again:
	clrf	LATA	; Clear PORTA output latch
	clrf	TRISA	; Make PORTA pins all outputs
	clrf	LATD	; Clear PORTD output latch
	clrf	TRISD	; Make PORTD pins all outputs

	clrf	LATC	; Clear PORTC output latch
	clrf    PORTC
	movlw   0xff	; Make PORTB pins all I/P
	movwf   TRISC

Loop
;	btfsc	PORTC,0	; Has PC0 =0
	btfss	PORTC,0	; Has PC0 =1
	goto	Loop	; No, check again

	bsf		PORTA, 4; LED ON
;   bcf		PORTA, 4; LED OFF
    
	incf	Count,F		; Increment Count
	movff	Count,LATD	; move Count to PORTD

	goto	Again		; yes, wait for next key press


	END		; directive indicates end of code

