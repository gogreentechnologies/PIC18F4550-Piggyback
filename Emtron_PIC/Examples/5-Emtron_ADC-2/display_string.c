#include <p18f4550.h>


#define _XTAL_FREQ 20e6
#define EN          PORTDbits.RD2      // enable signal
#define RW          PORTDbits.RD1      // read/write signal
#define RS          PORTDbits.RD0     // register select signal
#define databits PORTD
 
void LCD_write(unsigned char data);
void LCD_write_string(static char *str);
 
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

/*----------------PIC INITIALIZATION------------*/
void pic_init()
{  
   TRISD = 0x00;         //Configuring PORTD as output
   PORTD = 0xff;
}
 
/*-------------LCD FUNCTIONS BEGIN--------------*/
void LCD_STROBE(void)
{
    EN = 1;
    myMsDelay(15);
    EN = 0;
}
 
void data(unsigned char c)
{
     
   
    databits = (c & 0xf0);      //MSB FIRST
	 RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();

 databits = (c << 4) & 0xf0;  //LSB NEXT
     RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();
}
 
void cmd(unsigned char c)
{
    

    databits = (c & 0xf0);     //MSB FIRST
	RS = 0;
    RW=0;
    myMsDelay(50);
    LCD_STROBE();

	databits = (c << 4)& 0xf0;  //LSB NEXT
    RS = 0;
    RW=0;
    myMsDelay(50);    
    LCD_STROBE();
}

void clear(void)
{
    cmd(0x01);
   myMsDelay(50);
}

  
void lcd_init()
{
unsigned int i ;
		RS = 0;
	 	RW = 0;
		EN = 0;
	myMsDelay(150);

    databits = 0x30 ;
    RS = 0;
    RW=0;
    myMsDelay(50);    
    LCD_STROBE();
    myMsDelay(15);

	databits = 0x30 ;
    RS = 0;
    RW=0;
    myMsDelay(50);    
    LCD_STROBE();
    myMsDelay(15);

	databits = 0x30 ;
    RS = 0;
    RW=0;
    myMsDelay(50);    
    LCD_STROBE();
    myMsDelay(15);

	databits = 0x20 ;
    RS = 0;
    RW=0;
    myMsDelay(50);    
    LCD_STROBE();
    myMsDelay(15);
       
     cmd(0x28);				// Function set (4-bit interface, 2 lines, 5*7Pixels)
     myMsDelay(15);
     cmd(0x0f);            // Make cursorinvisible
     myMsDelay(15);
     cmd(0x06); 
     myMsDelay(15);           // Set entry Mode(auto increment of cursor)
}
 
 

void lcddata(unsigned char value)
{
   databits = (value & 0xf0);      //MSB FIRST
	 RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();

 databits = (value << 4) & 0xf0;  //LSB NEXT
     RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();
    return ;
}

 

/*-------------LCD END--------------------*/
 
void main(void)

{
  	int L_BYTE,H_BYTE,Bin_TEMP;
	float temp1,temp2;
	char str1[20]={"};
	int i,temp;"ADC O/P in BCD:
	char strng[4]={"0000"};
	char *itoa(int temp, char *strng);

    	pic_init();
    	lcd_init();
		clear();

   	TRISAbits.TRISA0=1;  //Configuring RA0 as input
	TRISAbits.TRISA2=1;

// ADCON0: A/D CONTROL REGISTER 0 Page 261

	ADCON0=0x01;	// Channel CH=0 select ( total 12 channels)
	ADCON1=0x0E;	// Voltage Reference Vref, VDD Port congiguration Analog or Digital 
	ADCON2=0xCE;	// FOSC/64 ; 12TAD for 10 bit resolution ; Right Justified
    myMsDelay(15);
 

 //Displays the default string str1 on the LCD
	for(i=0;str1[i]!='\0';i++)
	{
		lcddata(str1[i]);
		myMsDelay(15);
	}
   

while (1) { 

	ADCON0bits.GO=1;                // To start the ADC
	while(ADCON0bits.DONE == 1);    // Waits till the A/D conversion is compelete
	L_BYTE=ADRESL;                  //8 LSB bits of the output placed in L_BYTE
	H_BYTE=ADRESH;                  //2 MSB bits of the output placed in H_BYTE
	H_BYTE=H_BYTE<<8;               
	H_BYTE=H_BYTE|L_BYTE;           //Entire 10 bits combined and placed in H_BYTE
    Bin_TEMP=H_BYTE;
    temp1 = Bin_TEMP;         //Stores the value 
    
    cmd(0xc0);				       // 2nd Line
    myMsDelay(1);

	itoa(temp1,&strng);      
  
for(i=0;i<4;i++)            		//Displays the value of the voltage on the LCD
    {
    lcddata(strng[i]);
    }

     }
}