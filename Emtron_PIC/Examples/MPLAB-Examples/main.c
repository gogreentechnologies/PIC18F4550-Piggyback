#include <xc.h>
int c = 0;
void delay(int count)
{
    int i;
    for(i = 0; i <= count; i++)
    {
        continue;
    }
}
void main(void)
{
    // timer 1 configuration 
    T1CONbits.TON = 0 ; // timer 1 off
    T1CONbits.TCS = 0 ; // internal clock Fp
    T1CONbits.TCKPS = 0b10 ;  // prescalar  1:64   b for binary  and  x for hexadecimal 
    PR1 = 570 ;//570
    //PR2 = 1000;// prescale for about half second 
    IFS0bits.T1IF = 0 ; // clear interrupt flag
    IEC0bits.T1IE = 1 ; // enable interrupt
    T1CONbits.TON = 1 ; // timer 1 on
    TRISDbits.TRISD5 = 0 ; // RD5 as output  
    
    TRISBbits.TRISB10 = 0 ; // RD5 as output  
    TRISBbits.TRISB11 = 0 ; // RD5 as output  
    TRISBbits.TRISB12 = 0 ; // RD5 as output 
    TRISBbits.TRISB13 = 0 ; // RD5 as output 
    TRISBbits.TRISB14 = 0 ; // RD5 as output 
    TRISBbits.TRISB15 = 0 ; // RD5 as output 
    while(1)
    {
        
    }
}

void __attribute__((interrupt(no_auto_psv))) _T1Interrupt(void)
{
    
    c++;
    if(c == 1)
    {
        LATBbits.LATB10 = 1 ; // toggele led
        LATBbits.LATB11 = 0 ; // toggele led	
                    
    }
    if(c == 2)
     {//3.3
        LATBbits.LATB10 = 1 ; // toggele led
        LATBbits.LATB11 = 0 ; // toggele led	
               
    
    }
    if(c == 3)
     {//6.6
        LATBbits.LATB10 = 1 ; // toggele led
        LATBbits.LATB11 = 0 ; // toggele led	
               
    
        LATBbits.LATB12 = 1 ; // toggele led
        LATBbits.LATB13 = 0 ; // toggele led
                
        LATBbits.LATB14 = 0 ; // toggele led
        LATBbits.LATB15 = 1 ; // toggele led
      }
    if(c == 4)
    {//10
        LATBbits.LATB10 = 0 ; // toggele led
        LATBbits.LATB11 = 1 ; // toggele led	
               
    
        LATBbits.LATB12 = 1 ; // toggele led
        LATBbits.LATB13 = 0 ; // toggele led
                
        LATBbits.LATB14 = 0 ; // toggele led
        LATBbits.LATB15 = 1 ; // toggele led
    }
    if(c == 5)
    {//13.3
        LATBbits.LATB10 = 0 ; // toggele led
        LATBbits.LATB11 = 1 ; // toggele led	
               
    
        LATBbits.LATB12 = 1 ; // toggele led
        LATBbits.LATB13 = 0 ; // toggele led
                
        LATBbits.LATB14 = 1 ; // toggele led
        LATBbits.LATB15 = 0 ; // toggele led
    }
    if(c == 6)
    {//16.6
        LATBbits.LATB10 = 0 ; // toggele led
        LATBbits.LATB11 = 1 ; // toggele led	
               
    
        LATBbits.LATB12 = 0 ; // toggele led
        LATBbits.LATB13 = 1 ; // toggele led
                
        LATBbits.LATB14 = 1 ; // toggele led
        LATBbits.LATB15 = 0 ; // toggele led            
            }
    if(c == 7)
    {//20
        LATBbits.LATB10 = 0 ; // toggele led
        LATBbits.LATB11 = 1 ; // toggele led	
               
    
        LATBbits.LATB12 = 0 ; // toggele led
        LATBbits.LATB13 = 1 ; // toggele led
                
        LATBbits.LATB14 = 1 ; // toggele led
        LATBbits.LATB15 = 0 ; // toggele led
        c=0;
    }
    delay(1300);
}
