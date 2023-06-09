; This program demonstrates pulse width modulation using CCP2.
;
; The PWM period is fixed and then the duty cycle is varied by
; looking up a new value in a table.  When the final value of 
; the table is read, the table is read in reverse. The PWM output
; is set to RC1.  Parts Y3, C6 & C7 are are not installed the 
; on the PICDEM 2 board.  PWM signal can be observed on RC1 pin.
;

list P = 18f4550
#include "p18f4550.inc"
	
	config FOSC = HSPLL_HS    ;// Using 20 MHz crystal with PLL
	config PLLDIV = 5         ;// Divide by 5 to provide the 96 MHz PLL with 4 MHz input
	config CPUDIV = OSC1_PLL2 ;// Divide 96 MHz PLL output by 2 to get 48 MHz system clock
	config USBDIV = 2         ;// USB clock comes from 96 MHz PLL output / 2
	config FCMEN = OFF 		  ;// Disable Fail-Safe Clock Monitor
	config IESO = OFF  		  ;// Disable Oscillator Switchover mode
	config PWRT = OFF         ;// Disable Power-up timer
	config BOR = OFF          ;// Disable Brown-out reset
	config VREGEN = ON        ;// Use internal USB 3.3V voltage regulator
	config WDT = OFF          ;// Disable Watchdog timer
	config MCLRE = ON         ;// Enable MCLR Enable
	config LVP = OFF          ;// Disable low voltage ICSP
	config ICPRT = OFF        ;// Disable dedicated programming port (44-pin devices)
	config CP0 = OFF          ;// Disable code protection
	
	
		
;************************************************************
; bit definitions

F                 EQU      0x0001

;************************************************************
; 18C452 RAM LOCATIONS

DIRFLAG           EQU      0x0000

;************************************************************
; 18C452 ROM LOCATIONS

TABLADDR          EQU      0x0003000

;************************************************************
; vectors

	org	0x000000		; reset vector
	bra	START
	
	org	0x000008		; high priority interrupt vector
	bra	TMR1_ISR

;************************************************************
; program
START
	MOVLW	00 			;Load 00 into WREG
    MOVWF	TRISA 		;Set up PORTC as output port
    MOVWF	LATA 		;Display 55H at PORTC
	MOVLW	0xFF 		;Load byte 55H to turn on alternate LEDs
    MOVWF	PORTA 		;Display 55H at PORTC
again             
  	goto	again   
    
;Set up PWM module
;Set PWM period by writing to PR2
;Set PWM duty cycle by writing to the CCPR2L register
; and the CCP2CON<5:4>>bits
;Make the CCP2 pin an output by clearing the TRISC<2> bit.
	clrf	CCP2CON			;CCP module is off
	bsf	CCP2CON, CCP2M3		;select PWM mode
	bsf	CCP2CON, CCP2M2		;select PWM mode
	movlw	0x3F			;Set PWM frequency to 78.12kHz
	movwf	PR2			;
	bcf	TRISC, 1		;make channel 1 an output
	movlw	0x00
	movwf	CCPR2L

;Set the TMR2 prescale value and enable Timer2 by writing to T2CON
;Configure the CCP2 module for PWM operation 
	clrf	T2CON			;clear T2CON
	clrf	TMR2			;clear Timer2
	bsf	T2CON,TMR2ON		;turn on Timer2	

;initialize direction flag for table
	clrf	DIRFLAG	

; Initialize the table pointer registers
; to the first location of the data stored in program memory.

	movlw	UPPER(TABLADDR)
	movwf	TBLPTRU
	movlw	HIGH(TABLADDR)
	movwf	TBLPTRH
	movlw	LOW(TABLADDR)
	movwf	TBLPTRL

;setup interrupt
	bsf	RCON,IPEN	;enable priority interrupts.
	bsf	IPR1,TMR1IP	;set Timer1 as a high priority interrupt source
	bcf	PIR1,TMR1IF	;clear the Timer1 interrupt flag
	bsf	PIE1,TMR1IE	;enable Timer1 interrupts
	bsf	INTCON,GIEH	;set the global interrupt enable bits
	bsf	INTCON,GIEL	;	"
  
;Timer1 setup
	clrf	T1CON
	clrf	TMR1H		;clear Timer1 high
	clrf	TMR1L		;clear Timer1 low
	bsf	T1CON,TMR1ON	;turn on Timer1
		  
MLOOP             
  	goto	MLOOP

;************************************************************   
; subroutines

TMR1_ISR			; high priority isr                      

	bcf	PIR1,TMR1IF	;Clear the Timer1 interrupt flag.
	rcall   CHECK_ADDR
   
	btfsc   DIRFLAG,0
	bra	RD_DOWN



RD_UP

; Code here does a table read, post-increments, and writes the
; value to the CCPR2L PWM duty-cycle register.
   
	tblrd*+
	movff	TABLAT,CCPR2L
      
	bra	T1POLL   
   
RD_DOWN

; Code here does a table read, post-decrements, and writes the 
; value to the CCPR2L PWM duty-cycle register.

	tblrd*-  
	movff	TABLAT,CCPR2L
           
	bra	T1POLL

T1POLL
	btfss	PIR1,TMR1IF	;Poll TMR11 interrupt flag to wait for another
				; TMR1 overflow.
	bra	T1POLL		
	bcf	PIR1,TMR1IF	;Clear the Timer1 interrupt flag again.

	retfie

CHECK_ADDR
   movlw    LOW(TABEND) - 1
   subwf    TBLPTRL,W
   bnz      CHECK_LOW
   setf     DIRFLAG
   return
   
CHECK_LOW
   movlw    LOW(TABLADDR)
   subwf    TBLPTRL,W
   bnz      DONE_CHECK
   clrf     DIRFLAG
DONE_CHECK
   return


;-------------------------------DATA---------------------------------------

   org TABLADDR
   
   DB  0x00,0x06,0x0C,0x12,0x18,0x1E,0x23,0x28      
   DB  0x2D,0x31,0x35,0x38,0x3A,0x3D,0x3E,0x3F        

TABEND

	END

