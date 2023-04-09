 #include<p18f4450.inc>

	CONFIG WDT=OFF; disable watchdog timer
	CONFIG MCLRE = ON; MCLEAR Pin on
	CONFIG DEBUG = ON; Enable Debug Mode
	CONFIG LVP = OFF; Low-Voltage programming disabled (necessary for debugging)
	CONFIG FOSC = INTOSCIO_EC;Internal oscillator, port function on RA6
	
org 0; start code at 0

Delay1 res 2 ;reserve 2 byte for the variable Delay1
 
Start:
	CLRF LATD
	CLRF TRISD
	CLRF Delay1
	 
MainLoop:
	
	movlw   0xff	; 
	movwf   LATD

Delay11:
	DECFSZ Delay1,1 ;Decrement Delay1 by 1, skip next instruction if Delay1 is 0
	GOTO Delay11 

	movlw   0x00	; 
	movwf   LATD

Delay22:
	DECFSZ Delay1,1 ;Decrement Delay1 by 1, skip next instruction if Delay1 is 0
	GOTO Delay22 

 
	GOTO MainLoop
end

