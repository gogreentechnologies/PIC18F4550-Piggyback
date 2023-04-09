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
 
void display_string_LCD(static char *pstring1, static char *pstring2)
{ 			cmd(0x80);
         	myMsDelay(15);
     		LCD_write_string(pstring1);
     		myMsDelay(15);

     		 cmd(0xc0);     // initiate cursor to second line
 			myMsDelay(15);
     		LCD_write_string(pstring2); 
      
     		myMsDelay(1000);
     		return;
}

void LCD_write(unsigned char data)
{
   databits = (data & 0xf0);      //MSB FIRST
	 RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();

 databits = (data << 4) & 0xf0;  //LSB NEXT
     RS = 1;
	 RW = 0;
    myMsDelay(50);
    LCD_STROBE();
    return ;
}

//Function to split the string into individual characters and call the LCD_write function

 void LCD_write_string(static char *str)   //store address value of the string in pointer *str
{
    int i = 0;
    while (str[i] != 0)
    {
        LCD_write(str[i]);      // sending data on LCD byte by byte
        myMsDelay(15);
                i++;
    }
    return;
}

/*-------------LCD END--------------------*/
 
void main(void)

{
  		char var1[] = "  VISHWANIKETAN  ";
        char var2[] = "    Hello :-)    ";
    	pic_init();
    	lcd_init();

        display_string_LCD(var1, var2);
     
    while (1) { }
}