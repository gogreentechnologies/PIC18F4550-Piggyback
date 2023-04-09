; This program is a simple implementation of the
; PIC18C452's A/D. 
;
; One Channel is selected (AN0).
; The hardware for this program is the PICDEM-2 board. The program 
; converts the potentiometer value on RA0 and displays it as
; an 8 bit binary value on Port B.
;
; The A/D is configured as follows:
; Vref = +5V internal
; A/D Osc. = internal RC
; A/D Channel = AN0 (RA0)

	LIST P=18C452
	#include <P18C452.INC>	; File contains addresses for register and bit names

;************************************************************
; reset and interrupt vectors

	org	0x00000	; Reset Vector Address
	goto	Start

	org	0x00008	; Interrupt Vector Address
	goto	ISR	; goto Interrupt Service Routine	

;************************************************************
; program code starts here

	org	0x00020
Start
	clrf	PORTB		; clear all bits of PORTB	
	clrf	TRISB		; Set PORTB as outputs

	call	InitializeAD 	; configure A/D module
	
	call	SetupDelay	; delay for 15 instruction cycles

	bsf	ADCON0,GO	; Start first A/D conversion

Main	goto	Main		; do nothing loop

;************************************************************
; Service A/D interrupt
; Get value and display on LEDs

ISR
	; Save context (WREG and STATUS) if required.

	btfss	PIR1,ADIF	; Did A/D cause interrupt?
	goto	OtherInt	; No, check other sources
	
	movf	ADRESH,W	; Get A/D value
	movwf	LATB		; Display on LEDs
	bcf	PIR1,ADIF	; Reset A/D int flag

	call	SetupDelay	; Delay for 15 cycles

	bsf	ADCON0,GO	; Start A/D conversion

	goto	EndISR		; return from ISR

OtherInt
	; This would be replaced by code to check and service other interrupt sources
	goto	$	; trap here, loops to self

EndISR
	; Restore context if saved.

	retfie		; Return, enables GIE

;************************************************************
; InitializeAD - initializes and sets up the A/D hardware.
; Select AN0 to AN3 as analog inputs, RC clock, and read AN0.

InitializeAD
	movlw	B'00000100'	; Make RA0,RA1,RA4 analog inputs
	movwf	ADCON1

	movlw	B'11000001'	; Select RC osc, AN0 selected,
	movwf	ADCON0		; A/D enabled

	bcf	PIR1,ADIF	; Clear A/D interrupt flag
	bsf	PIE1,ADIE	; Enable A/D interrupt
	
	bsf	INTCON,PEIE	; Enable peripheral interrupts
	bsf	INTCON,GIE	; Enable Global interrupts

	return

;************************************************************
; This is used to allow the A/D time to sample the input
; (acquisition time).
;
; This routine requires 11 cycles to complete.
; The call and return add another 4 cycles.
;
; 15 cycles with Fosc=4MHz means this delay consumes 15us.

SetupDelay
	movlw	.3		; Load Temp with decimal 3
	movwf	TEMP
SD
	decfsz	TEMP, F		; Delay loop
	goto	SD
	return

	END

