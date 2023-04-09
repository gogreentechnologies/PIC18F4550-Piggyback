#line 1 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"
#line 1 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"



























#line 29 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"
#line 34 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"
#line 39 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"
#line 43 "C:\Program Files\Microchip\Third Party\PICC\Examples\EX_LCDKB.C"





void main() {
   char k;

   lcd_init();
   kbd_init();

   lcd_putc("\fReady...\n");

   while (TRUE) {
      k=kbd_getc();
      if(k!=0)
        if(k=='*')
          lcd_putc('\f');
        else
          lcd_putc(k);
   }
}
