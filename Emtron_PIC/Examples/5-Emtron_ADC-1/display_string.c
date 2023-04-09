#include <p18f4550.h>
 
/*The following lines of code perform interrupt vector relocation to work with the USB bootloader. These must be
used with every application program to run as a USB application.*/
extern void _startup (void);
#pragma code _RESET_INTERRUPT_VECTOR = 0x1000

void _reset (void)
{
        _asm goto _startup _endasm
}

#pragma code
#pragma code _HIGH_INTERRUPT_VECTOR = 0x1008
void high_ISR (void)
{
}

#pragma code
#pragma code _LOW_INTERRUPT_VECTOR = 0x1018
void low_ISR (void)
{
}

 #pragma code
void myMsDelay (unsigned int time)
{
        unsigned int i, j;
        for (i = 0; i < time; i++)
                for (j = 0; j < 710; j++);/*Calibrated for a 1 ms delay in MPLAB*/
}


void main(void)

{
  	int L_BYTE,H_BYTE,Bin_TEMP;
	
   	TRISAbits.TRISA0=1;  //Page - 113 Configuring RA0 as input
	TRISAbits.TRISA2=1;

// ADCON0: A/D CONTROL REGISTER 0 Page 261

	ADCON0=0x01;	// Channel CH=0 select, AD ON ( total 12 channels)
	ADCON1=0x0E;	// Voltage Reference Vref, VDD, AN0 Port congiguration Analog or Digital 
	ADCON2=0xCE;	// FOSC/64 ; 12TAD for 10 bit resolution ; Right Justified
    myMsDelay(15);
 
    TRISB = 0;		// PORTB as O/P LEDs
 

while (1) { 

	ADCON0bits.GO=1;                // To start the ADC
	while(ADCON0bits.DONE == 1);    // Waits till the A/D conversion is compelete
	L_BYTE=ADRESL;                  //8 LSB bits of the output placed in L_BYTE
	H_BYTE=ADRESH;                  //2 MSB bits of the output placed in H_BYTE
	H_BYTE=H_BYTE<<8;               
	H_BYTE=H_BYTE|L_BYTE;           //Entire 10 bits combined and placed in H_BYTE
    Bin_TEMP=H_BYTE;
    
    LATB =  Bin_TEMP;  				// O/P on LEDs
}
}