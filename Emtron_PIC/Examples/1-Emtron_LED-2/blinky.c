 
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
/*End of interrupt vector relocation*/
/*Start of main program*/
void myMsDelay (unsigned int time)
{
	unsigned int i, j;
	for (i = 0; i < time; i++)
		for (j = 0; j < 710; j++);/*Calibrated for a 1 ms delay in MPLAB*/
}

void main()
{	int i,j;   
   TRISB = 0;
	while(1)
	{
	  i=0xff;		
	  LATB = 0xff;	
	for(j=0;j<=7;j++)
	{
 		LATB=i;
 		i<<=1; 
 		myMsDelay(500);
	}
	for(j=0;j<=7;j++)
	{
 		LATB=i;
 		i>>=1; 
 		myMsDelay(500);  
 	}
	}
}
