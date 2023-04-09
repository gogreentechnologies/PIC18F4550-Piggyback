; This program demonstrates the use of oscillator switching.
; 
; The data held in MYDAT is periodically flashed on the PORTB
; LEDs.  Each time a keypress is detected on RA4, the data is 
; incremented and the oscillator source is changed.

	#include<p18f4450.inc>
	
	CONFIG WDT=OFF; disable watchdog timer
	CONFIG MCLRE = ON; MCLEAR Pin on
	CONFIG DEBUG = ON; Enable Debug Mode
	CONFIG LVP = OFF; Low-Voltage programming disabled (necessary for debugging)
	CONFIG FOSC = INTOSCIO_EC;Internal oscillator, port function on RA6

	
KEY		EQU   4	

;-------------------18C452 RAM LOCATIONS------------------------------


COUNT0		EQU      0x0000      ; used for software timing loop
COUNT1		EQU      0x0001      ;            "
MYDAT		EQU      0x0002      ; data storage register

;------------------BIT DEFINITIONS------------------------------------

F                 EQU      0x0001

;------------------VECTORS--------------------------------------------

ORG		0x000000	; reset vector
BRA		START

;--------------------PROGRAM-----------------------------------

START
	CLRF LATD
	CLRF TRISD
	movlw   0xff	; 
	movwf   LATD



   rcall    INIT		; setup ports, etc.
   bsf      T1CON, T1OSCEN	; setup the LP oscillator

MLOOP

   btfss    PORTA,KEY
   rcall    KEYPRESS		; call keypress routine if
 							; button is pressed
   movff    MYDAT,PORTD		; move data to portb
   rcall    WAIT		; wait a while
   clrf     PORTD		; clear the port
   rcall    WAIT		; wait a while
   
   bra      MLOOP

;-------------------------------SUBROUTINES---------------------------------

KEYPRESS

   btfss    PORTA,KEY
   bra      KEYPRESS
   incf     MYDAT

; Oscillator source changes every time the subroutine is called.

   btg      OSCCON,SCS0  ;BTG = Toggle Page 34
   btg      OSCCON,SCS1  ;BTG = Toggle
     
   return

INIT

   clrf     PORTA
   clrf     PORTD
   bsf      DDRA,4
   clrf     DDRD
   
   return

WAIT                                   ; software time delay
   clrf     COUNT0
   movlw    0x08
   movwf    COUNT1
WLOOP
   decfsz   COUNT0,F
   bra      WLOOP
   decfsz   COUNT1,F
   bra      WLOOP
      
   return

	end	
