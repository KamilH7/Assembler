Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik     

start:          mov     ax,dane   
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt
                ;;;
inicjalizacja:                 
                mov     ax, 0b800h              
                mov     es, ax                  ;adres pamieci bufra ekranu do es
                mov     ah, 01h                 ;kolor tla i kolor czcionki
                mov     al, 'A'                 ;pierwsza litera                
                mov     dh, 39                  ;poczatkowa liczba spacji
                mov     dl, 1                   ;poczatkowa liczba znakow                 
                xor     di, di                  ;di = 0
                xor     cx, cx                  ;cx = 0

mainLoop:       
                push ax                         ;odloz kolejny znak na stosie
                    mov     cl, dh              ;ustaw licznik na dh
                    mov     ax, 0020h           ;wpisz spacje do ax
                    call    wypiszNaEkran       ;wypisz spacje cx razy
                pop ax                          ;pobierz kolejny znak ze stosu
                
                mov     cl, dl                  ;ustaw licznik na dl       
                call    wypiszNaEkran           ;wypisz kolejn¹ litere cx razy  
                
                push ax                         
                    inc     dh                  ;-||-
                    mov     cl, dh              ;ustaw licznik na dh + 1 
                    mov     ax, 0020h           ;-||-
                    call    wypiszNaEkran
                pop ax
                
                sub     dh, 2                   ;mniej spacji
                add     dl, 2                   ;wiecej liter 
                inc     al                      ;nastepna litera
                inc     ah                      ;nastepny kolor   
                
                cmp     al, 'Z'                 
                jz      exit                    ;sprawdzamy, czy dotarlismy do ostatniej litery
                
                cmp     ah, 10h                 
                jnz     mainLoop                ;sprawdzamy, czy doszlismy do ostatniego koloru       
                
                mov     ah, 01h                 ;zeruj kolor    
                call    mainLoop                ;kolejna iteracja
                
wypiszNaEkran:
                mov     es:[di], ax
                add     di, 2              
                loop    wypiszNaEkran
                ret 

exit:
                mov     ah,0
                int     16h
                mov     ah,4ch
                mov     al,0
                int     21h                      ;wyjdz do systemu operacyjnego 
		        ;;;

Progr           ends

dane            segment
dane            ends

stosik          segment
		dw    100h dup(0)                       ;zeruje stos
szczyt          Label word   
stosik          ends

end start