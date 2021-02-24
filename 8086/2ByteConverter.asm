Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik  
start:                
                mov     ax,dane   
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt                
                ;;;
                lea     dx,wiadomosc1           ;wypisz 'Podaj liczbe:'       
                xor     ax,ax
                mov     ah,09h
                int     21h
                
                xor     cx,cx                   ;zeruj licznik cyfr
                xor     bx,bx                   ;zeruj licznik znakow
czytaj:         
                inc     bx      
                xor     ax,ax
                mov     ah,01h
                int     21h                     ;pobierz kolejny znak od uzytkownika  
                xor     ah,ah
                
                cmp     ax,0Dh                  ;czy znak jest enterem         
                jz      konwertuj               ;jesli tak to konwertuj na hex                  
          
                cmp     bx,1                    ;czy jest to pierwszy znak
                jnz     czyJestCyfra            ;jesli nie to sprawdz czy jest cyfra
                cmp     ax,'-'                  ;czy jest to minus
                jnz     czyJestCyfra            ;jesli nie to sprawdz czy jest cyfra
	            push    ax                      ;wrzuc minus na stos
		        jmp     czytaj                  ;pobierz kolejny znak
czyJestCyfra:           
                inc     cx                      ;zwieksz licznik cyfr
                
                sub     al,30h                  ;zamien znak na liczbe                               
                js      blednedane              ;jesli wynik dzialania jest ujemny to znak nie jest cyfra
                                              
                sub     ax,0Ah                  ;odejmij od wartosci cyfry 10                
                jns     blednedane              ;jesli wynik nie jest ujemny to znak nie jest cyfra                 
                add     ax,0Ah                  ;przywroc rzeczywista wartosc
                                
                push    ax                      ;zapisz liczbe na stosie                                                           
                jmp     czytaj                   ;pobierz kolejna liczbe
blednedane:     
                lea     dx,wiadomosc5           ;wypisz 'bledne dane'           
                xor     ax,ax
                mov     ah,09h
                int     21h
                jmp     start                   ;wroc na start

konwertuj:                              
                mov     ax,1                    ;pierwszym mnoznikiem jest 1
                xor     dx,dx                   ;zeruj wynik
                    
konwertujloop:     
                
                pop     bx                      ;pobierz kolejna cyfre ze stosu
                
                push    ax                      ;zapisz aktualny mnoznik na stosie
                    push    dx                  
                        mul     bx              ;pomnoz aktualna cyfre z aktualnym mnoznikiem dx:ax = bx * ax
                    pop     dx
                              
                    add     dx,ax               ;dodaj wynik mnozenia do calosci wyniku
                    
                    push    dx
                            sub     dx,8000h    ;odejmij maksymalna wartosc od wyniku
                            jns     blednedane  ;jesli wynik jest dodatni to przekroczyl prog                             
                    pop     dx
                pop     ax                      ;sciagnij aktualny mnoznik ze stosu        
                
                push dx
                    mul     mnoznik             ;pomnoz aktualny mnoznik przez 10
                pop dx
                
                loop    konwertujloop           ;powtorz cx razy
                                   
                mov     bx,'0'                  ;zapisz 0 w bx (znak liczby)

                pop     ax                      ;sciagnij wartosc ze stosu
                    cmp     ax, '-'
                    jnz     skip                ;jesli ta wartoscia jest '-'
                    mov     bx,'1'              ;zapisz 1 w bx (znak liczby)
                    neg     dx                  ;zaneguj wynik
skip:               
                push    ax                      ;odloz na stos
                
                ;hex
                push    dx
                    lea     dx,wiadomosc2       ;wypisz 'hex:'     
                    xor     ax,ax
                    mov     ah,09h
                    int     21h
                pop     dx
           
                call    wypiszHex
                
                ;zu2
                push    dx
                    lea     dx,wiadomosc4      ;wypisz 'zu2'      
                    xor     ax,ax
                    mov     ah,09h
                    int     21h
                pop     dx
                
                call    wypiszBinarnie         
                
                ;zm
                push    dx
                    lea     dx,wiadomosc3     ;wypisz 'zm2'         
                    xor     ax,ax
                    mov     ah,09h
                    int     21h
                pop     dx
                
                push    dx                    ;zostaw wynik na stosie
                    lea     dx,zeroZM         ;lea '0.'
                    cmp     bx,'1'                
                    jnz     skip2             ;jesli na bx jest 1
                    lea     dx,jedenZM        ;lea '1.'
                    
                    pop     cx                ;pobierz wynik ze stosu
                        neg     cx            ;spowrotem na zm
                    push    cx                ;odloz wynik na stos
skip2:       
                    xor     ax,ax
                    mov     ah,09h
                    int     21h               ;wypisz dx     
                pop     dx  
                
                call    wypiszBinarnie  
                              
                jmp     start                 
                                                             
wypiszHex:                
                push    dx                    
                    xor     ax,ax              
                    mov     al,dh             ;wrzuc do al starsze 2 bajty wyniku
                    call    wypiszStarszy     ;wypisz starszy bajt z nich
                pop     dx
                
                push    dx  
                    xor     ax,ax              
                    mov     al,dh             ;wrzuc do al starsze 2 bajty wyniku
                    call    wypiszMlodszy     ;wypisz mlodszy bajt z nich
                pop     dx
                
                push    dx
                    xor     ax,ax 
                    mov     al,dl             ;wrzuc do al mlodsze 2 bajty wyniku
                    call    wypiszStarszy     ;wypisz starszy bajt z nich
                pop     dx
                
                push    dx  
                    xor     ax,ax              
                    mov     al,dl             ;wrzuc do al mlodsze 2 bajty wyniku
                    call    wypiszMlodszy     ;wypisz mlodszy bajt z nich
                pop     dx
                
                ret                  
             
wypiszStarszy:     
                xor     dx,dx                     
                div     dzielnik              ;podziel wynik przez 0010h przesuwajac wynik o 4 miejsca w prawo
                call    wypiszAL              ;wypisz zawartosc al
                ret
                
wypiszMlodszy:                                
                xor     dx,dx                      
                div     dzielnik              ;podziel wynik przez 0010h przesuwajac wynik o 4 miejsca w prawo
                mov     al,dl                 ;zapisz reszte z dzielenia do al
                call    wypiszAL              ;wypisz zawartosc al
                ret
                                                                 
wypiszAL:
                sub     ax,0Ah                ;odejmij od ax 0Ah
                    js      liczba            ;jesli wynik jest ujemny to zawartosc ax jest liczba
                add     ax,0Ah                ;przywroc ax pierwotna wartosc
                add     ax,37h                ;dodaj 37h aby zamienic zawartosc ax na stringa
                
                mov     dx,ax                 ;wypisz zawartosc ax
                xor     ax,ax 
                mov     ah,02h
                int     21h               
                ret
                                              ;wroc do wypiszMlodszy/wypiszStarszy
liczba:         
                add     ax,0Ah                ;przywroc ax pierwotna wartosc
                add     ax,30h                ;dodaj do ax 30h aby zamienic go na stringa
                
                mov     dx,ax                 ;wypisz zawartosc ax
                xor     ax,ax 
                mov     ah,02h
                int     21h               
                ret
                                  
wypiszBinarnie:                
                mov     ax,8000h              ;ustaw dzielnik na 2^16
                mov     cx,16                 ;ustaw licznik na 16 by wypisac 16 bitow
binarnieLoop:         
                test    ax,dx                 
                jz      zapiszZero            ;jesli wynikiem test jest 0 to bit jest pazysty wiec wypisz 0
                jmp     zapiszJeden           ;w przeciwnym wypadku wypisz 1  
dalej:          
                push     dx  
                    xor     dx,dx    
                    div     dwojka            ;podziel aktualny dzielnik przez 2
                pop     dx
                  
                loop     binarnieLoop         ;wykonaj sie cx razy
                
                ret               
                
zapiszZero:            
                push ax 
                    push dx
                        xor ax,ax
                        mov ah,09h
                        lea dx,zero
                        int 21h 
                    pop dx
                pop  ax 
                jmp  dalej
                

zapiszJeden:   
                push ax 
                    push dx 
                        xor ax,ax
                        mov ah,09h
                        lea dx,jeden
                        int 21h 
                    pop dx
                pop  ax 
                jmp  dalej
                                  
		        ;;;
exit: 
		        mov     ah,4ch
                mov     al,0
                int     21h                     

Progr           ends

dane            segment 
    wiadomosc1 db 0dh, 0ah, "Podaj Liczbe: $"
    wiadomosc2 db 0dh, 0ah, "HEX:  $" ;efektywny = 11h, logiczny = 4965h:11h, fizyczny = 10h * 4965h + 11h = 49650 +11h = 49661h
    wiadomosc3 db 0dh, 0ah, "ZM :$"
    wiadomosc4 db 0dh, 0ah, "ZU2:  $"
    wiadomosc5 db 0dh, 0ah, "Bledne Dane! $"
    zeroZM     db "0.$"
    jedenZM     db "1.$"
    mnoznik  dw  0ah
    dzielnik dw  0010h 
    dwojka   dw  0002h
    zero     db  '0$'
    jeden    db  '1$'
dane            ends

stosik          segment
		dw    100h dup(0)                       ;zeruje stos
        szczyt          Label word   
stosik          ends

end start