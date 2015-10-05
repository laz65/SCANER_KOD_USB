/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 18.07.2014
Author  : NeVaDa
Company : Укртелеком
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=2
   .equ __scl_bit=3
#endasm
#include <i2c.h>
#include <delay.h>
#include <stdlib.h>

#define kn1 PINC.5
#define kn2 PINC.1
#define kn3 PINC.3
#define zvuk PORTD.7
#define PS2_CLK   PIND.4       
#define PS2_DATA  PIND.5
 


// Declare your global variables here
#define EEPROM_BUS_ADDRESS 0xA0
 unsigned char KeyV[100], read, kluch, k, dat, addr0=0, addr1=0, n, j, i, KeyVal, zna;
 bit  flag=0, ravno=0, enter=0;
 unsigned int address, addr, paus, add;
 char conv[5];
 flash unsigned char KeyU[] = {'','','','','','','','','','','','','','','~','','','','','','','Q','!','','','','Z','S','A','W','@','','','C','X','D','E','$','#','','',' ','V','F','T','R','%','','','N','B','H','G','Y','^','','','','M','J','U','&','*','','','<','K','I','O',' )','(','','','>','?','L',':','P','_','','','','\"','','{','+','','','','',0x0A,'}','|',''};
 flash unsigned char KeyD[] = {'','','','','','','','','','','','','','','`','','','','','','','q','1','','','','z','s','a','w','2','','','c','x','d','e','4','3','','',' ','v','f','t','r','5','','','n','b','h','g','y','6','','','','m','j','u','7','8','','',',','k','i','o','0','9','','','.','/','l',';','p','-','','','','\'','','[','=','','','','',0x0A,']','\\',''}; 
 
#define ADC_VREF_TYPE 0xC0

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}


// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 48
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}





#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0) if (!kn2) return 0xFF;
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

/***************************************************************************************
+ Читаем ячейку из 24с02.
+ В параметрах указывается адрес читаемой ячейки.
+ Функция возвращает прочитаное из ячейки.
****************************************************************************************/
unsigned char eep_read(unsigned char address1, unsigned char address2) {
unsigned char data;                    //переменная для прочитаных данных
#asm("cli")
i2c_start();                           //посылаем команду "старт" в шину i2c
i2c_write(EEPROM_BUS_ADDRESS);         //посылаем в шину адрес устройства
i2c_write(address1);
i2c_write(address2);                    //посылаем в шину адрес читаемой ячейки
i2c_start();                           //снова посылаем "старт" в шину
i2c_write(EEPROM_BUS_ADDRESS | 1);     //незнаю зачем но без этого не работает
data=i2c_read(0);                      //принимаем данные с лини и сохраняем в переменную
i2c_stop();                            //посылаем команду "стоп"
#asm("sei")
return data;                           //возврощаем значение прочитаного
}

/***************************************************************************************
+ Запись данных в ячейку 24с02.
+ В параметрах указывается адрес записываемой ячейки (adress).
+ Также указуем в параметрах данные которые надо записать в ячейку.
****************************************************************************************/
void eep_write(unsigned char address1, unsigned char address2, unsigned char data) {
#asm("cli")
i2c_start();                           //посылаем команду "старт" в шину i2c
i2c_write(EEPROM_BUS_ADDRESS);         //посылаем в шину адрес устройства
i2c_write(address1);
i2c_write(address2);                    //посылаем в шину адрес записываемой ячейки
i2c_write(data);                       //посылаем данные для записи
i2c_stop();
#asm("sei")
delay_ms(5);                           //посылаем команду "стоп"
}

void err(void)
{
kluch = 0;
k = 0;
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(100);
  zvuk = 0;
  delay_ms(150);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(150);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(150);
  zvuk = 1;
  delay_ms(200);
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(50);
  zvuk = 0;
  delay_ms(50);
  zvuk = 1;
  delay_ms(50);
lcd_clear();
lcd_putsf("      ERROR     ");
lcd_gotoxy(0,1);
lcd_putsf("                ");
kluch = 0;
k = 0;
read = 0xFF;
while(rx_counter != 0) getchar() ;

}

unsigned char Scan_Data()     // Чтение из сканера
{
    unsigned char Data=0,temp;
    while(PS2_CLK==0);
    for(i=0;i<10;i++)
    {
        paus = 0;
        while(PS2_CLK==1) { if(paus++ > 65000) return(0);} ;
        temp=PS2_DATA;
        temp<<=i;
        Data|=temp;
        while(PS2_CLK==0);
    }
//    PORTD=0x00;
//    delay_ms(1);
    return(Data);
}



void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=P State5=P State4=P State3=P State2=T State1=P State0=T
PORTC=0x7A;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=1 State6=P State5=P State4=P State3=P State2=P State1=T State0=T
PORTD=0xFC;
DDRD=0x80;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// I2C Bus initialization
i2c_init();

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")
dat = 0x94;
address = eep_read(0,0)*256;       // восстановление последнего записаного адреса
address = address + eep_read(0,1);
zna = eep_read(0,2);
//address = address + 1;
//k = 4;

lcd_clear();


// ADC initialization
// ADC Clock frequency: 62,500 kHz
// ADC Voltage Reference: Int., cap. on AREF
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;
zvuk=0;
delay_ms(500);
addr = read_adc(4)/10;
addr = addr * 71;
zvuk=1;
itoa(addr,conv)  ;
      lcd_gotoxy(0,0);
      lcd_putsf("U pit. =  ");
      lcd_putchar(conv[0]);
      lcd_putsf(".");
      lcd_putchar(conv[1]);
      lcd_putsf("v") ;
ADMUX = 0 ;
ADCSRA = 0 ;
delay_ms(1000);
    if (addr < 4800)
    {
    lcd_gotoxy(0,1);
    lcd_putsf(" LOW BATTERY!!! ");
    err() ;
    lcd_gotoxy(0,1);
    lcd_putsf(" LOW BATTERY!!! ");
    delay_ms(1000);
    };
   
k=0;
lcd_clear();
        addr = address;
        lcd_gotoxy(0,0);               
        lcd_putsf("Bcero = ");
        add = zna+1;
        itoa(addr/add, conv);
        lcd_puts(conv);
while (1)
  {
//----------------------------------------------------------------------------------
    if (k==0)       // обработка клавиш
    {
        if (PS2_CLK==0) 
         {    
            j++;
            KeyV[j]=Scan_Data(); // Читать байт  
            if (KeyV[j] == 90) k=1; // Если Enter выполнить следующий блок  
            if (KeyV[j] == 0) j=0; // Если 0 пропуск и заново  
            paus = 0;
         }
        if (rx_counter > 0) if(getchar() == 0x20) k=2; // если w с комп, то - передача на комп
        if (!kn1) k = 4; 
        if (!kn2) k = 5;
        if (!kn3) k = 3;    
        if (j > 0) if (paus++ > 11111) 
        {
            KeyV[++j] = 90;
            k = 1;
        }
    };      
    
    if (k==1)   // Введен готовый номер
    {   
            
        n=j;          
        i = 1;  
        j = 0;
        flag = 0;
        while(i <= n)   
        {
            if (KeyV[i] == 0x12) 
            { 
                flag = 1; 
                i++; 
            };
            if (KeyV[i] == 0xF0) 
            {
               if (KeyV[++i] == 0x12) flag = 0;
               i++;
            };             
            //*******************************************   
            if(KeyV[i] != 0x12 && KeyV[i] != 0xF0)  
            {      
                if (flag) KeyV[++j] = KeyU[KeyV[i++]];
                else KeyV[++j] = KeyD[KeyV[i++]];
            }  
        }
//        KeyV[++j] = 0x0A;       
        flag = 0;
        addr=address; 
        add = zna+1; 
        for(i=0;i<10;i++)         // Поиск совпадающий номеров
        {   
            n=j;    
            while (n > 0)   
            {
                addr1 = addr>>8;
                addr0 = addr -  (unsigned int) addr1*256 ;  
                KeyVal = eep_read(addr1,addr0);
                if (KeyVal != KeyV[n]) 
                {
                    flag = 0;
                    addr = addr - n;
                    n = 0; 
                } 
                else 
                {     
                    flag = 1;
                    addr = addr - 1; 
                    if(--n == 0) i = 21;   
                } 
                if (addr < 3)
                {
                    if (i < 10) i = 10;
                    break;
                }
            }  
            if(add != j) flag = 1;
            if (flag && i < 10) i = 10;
                    
        }
              
        if (flag)
        {
            zvuk = 0;
            lcd_clear(); 
            if (i > 20) lcd_putsf("POVTOR! j = "); 
            else lcd_putsf("ERR! j = ");      
            itoa(j-1, conv);    
            lcd_puts(conv);               
            lcd_gotoxy(0,1);
            delay_ms(50);
            zvuk = 1; 
            delay_ms(50) ;
            
        }                            
        else
        {
            n = 0;
            addr = address;
            flag = 1;  
            lcd_clear();           
            while(++n <= j)
            {  
                addr = addr + 1;
                addr1 = addr>>8;
                addr0 = addr -  (unsigned int) addr1*256 ;  
                eep_write(addr1,addr0,KeyV[n]);  
                if  (eep_read(addr1,addr0) != KeyV[n]) 
                {  
                    flag = 0;
                    err();  // проверка записи
                    break;
                }  
                if (zna > 15) { if (KeyV[n] != 0x0A) lcd_putchar(KeyV[n]); } else lcd_putchar(KeyV[n]);
            }                              
            if (flag)
            {                            
                eep_write(0,0,addr1);   
                eep_write(0,1,addr0);
                if  (eep_read(0,0) != addr1)            
                {
                    err();  // проверка записи
                    break;
                }
                if  (eep_read(0,1) != addr0)             
                {
                    err();  // проверка записи
                    break;
                }
            }
            address = addr;
        }    
        zvuk = 0; 
        addr = address; 
        lcd_putsf(" Bcero ");
        add = zna+1;
        itoa(addr/add, conv);       
        k = 0;   
        j = 0;
        ravno = 0;  
        delay_ms(50); 
        lcd_puts(conv);
        zvuk = 1;        
    }    
    
    if (k == 4)
    {
        zvuk = 0; 
        addr = address;        
        delay_ms(50); 
        zvuk = 1;
        lcd_clear();
        lcd_putsf("Bcero = ");
        add = zna+1;
        itoa(addr/add, conv);
        delay_ms(50); 
        lcd_puts(conv);       
        itoa(zna, conv); 
        lcd_gotoxy(0,1);
        lcd_putsf("3HAKOB = ");
        lcd_puts(conv);               
        delay_ms(500); 
  
        k = 0;
        j = 0;

    }      
    
    if (k == 3)
    {
        zvuk = 0; 
        delay_ms(50); 
        lcd_clear();
        lcd_putsf(" Wait... ");
        zvuk = 1;
        j = n;        
        n=0;
        while (addr > 3) 
        {  
            addr = addr - 1;                  
            addr1 = addr>>8;
            addr0 = addr -  (unsigned int) addr1*256 ;  
            KeyVal = eep_read(addr1,addr0);
            if (KeyVal ==  0x0A )
            {
               break;
            }
        }   
        zvuk = 0; 
        lcd_clear();
        lcd_putsf("Bcero = ");
        add = zna+1;
        itoa(addr/add, conv);
        delay_ms(50); 
        lcd_puts(conv);
        itoa(zna, conv); 
        lcd_gotoxy(0,1);
        lcd_putsf("3HAKOB = ");
        lcd_puts(conv);               
        zvuk = 1;        
        delay_ms(500); 
        address = addr;
        k = 0;
        j = 0;

    }   
    
    if (k == 5)
    {
        zvuk = 0; 
        delay_ms(50); 
        flag = 0;
        lcd_clear();
        lcd_putsf(" 3AHOBO?  Y / N ");
        zvuk = 1;  
        while (kn1 && kn3); 
        while(!kn2)
        {
            if(!kn3)
            {
                zvuk = 1;  
                lcd_clear();
                zna++;
                itoa(zna, conv);
                delay_ms(200);
                lcd_putsf("3HAKOB = "); 
                lcd_puts(conv);
                zvuk = 1;  
                delay_ms(200); 
            }
            if(!kn1)
            {
                zvuk = 1;  
                lcd_clear();
                zna--;
                itoa(zna, conv);
                delay_ms(200); 
                lcd_putsf("3HAKOB = ");
                lcd_puts(conv);
                zvuk = 1;  
                delay_ms(200); 
            }   
             flag = 1;
        }     
        if (flag) 
        {
            eep_write(0,2,zna);   
            if  (eep_read(0,2) != zna)            
            {
                err();  // проверка записи
                break;
            }                 
            
        }
        delay_ms(500); 
        if (!kn3)    address = 2; 
        addr = address;            
        zvuk = 0; 
        lcd_clear();
        lcd_putsf("Bcero = ");
        add = zna+1;
        itoa(addr/add, conv);
        delay_ms(50); 
        lcd_puts(conv);
        itoa(zna, conv); 
        lcd_gotoxy(0,1);
        lcd_putsf("3HAKOB = ");
        lcd_puts(conv);               
        zvuk = 1;  
        j = 0;
        k = 0;
        delay_ms(500); 
    }

//----------------------------------------------------------------------------------

    if(k == 2)
    {
          lcd_clear();
          lcd_putsf("peredacha ");
          itoa(address, conv);
          lcd_gotoxy(10,0);
          lcd_puts(conv);
                addr = 2;  
                putchar(eep_read(0,0));
                putchar(eep_read(0,1));
                putchar(0x0A);
                while (addr < address)
                {
                addr=addr+1;
                addr1 = addr>>8;
                addr0 = addr - (unsigned int) addr1*256 ;
                read = eep_read(addr1,addr0);
                putchar(read);
                } ;
      lcd_clear();
      lcd_putsf("konec peredachi!");
      lcd_gotoxy(0,1);
      lcd_putsf("                ");
      k = 0;
        
    }


  };
}