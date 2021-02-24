Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik   

start:          mov     ax,dane   
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt
                ;;;
                
; sprawdz poprawnosc PSP
				xor		ax,ax
                mov     ah, 62h           
                int     21h                 ;pobierz adres PSP

                mov     es, bx              ;es wskazuje na PSP
                mov     bl, es:[80h]        ;pobierz ilosc znakow znajdujacych sie w PSP
                cmp     bl,2				          
                jbe     koniec              ;czy w PSP znajduja sie przynajmniej 3 znaki
                cmp     bl,7Eh
                ja      koniec              ;overflow
         
; przepisz zawartosc PSP do zmiennej tail
                xor     ax,ax
                xor     di,di
kolejnaLitera:								;81h - zaczyna sie string parametrow
											;82h - parametry po spacji
                mov     al,es:[82h+di]      ;pobierz kolejny znak z tail'a PSP      
                cmp     al,0Dh				;czy nie jest enterem
                je      otworzPlik
                mov     nazwaPliku[di],al   ;zapisz znak do nazwaPliku
                inc     di                  ;zwieksz pointer    
                jmp     kolejnaLitera       ;pobierz kolejna litera

; otworz plik o nazwie zawartej w zmiennej nazwaPliku
otworzPlik:
                lea     dx, nazwaPliku		
                xor		ax,ax
				mov     ah, 3Dh  
                int     21h                 
                jc      koniec				
                mov     odnosnik,ax			;adres pliku

; przejdz przez zawartosc pliku
czytaj3bajty:
				xor		ax,ax
                mov     ah,3Fh            
                mov     bx,odnosnik          ;do bx'a odnosnik do pliku
                mov     cx,3                 ;do cx'a ilosc bajtow do odczytania
                mov     dx,0                 ;do dx'a offset od ds'a na który zapisac odczytane dane ds:dx
                int     21h
                cmp     ax,3				 ;ax przechowuje liczbe pomyslnie wczytanych bajtow
                jne     koniec               
                mov     dl,ds:[0]			 ;wczytujemy nute
                xor		ax,ax
				mov     ah,02h				 ;wypisuje do consoli 1 symbol             
                int     21h
                call    analizujNute
                jmp     czytaj3bajty

koniec:                       
		        in		al,61h           
				and		al,0FCh				 ;ustawienie 2 ostatnich bitow kontolera na 0
				out		61h,al				
				lea		bx,nazwaPliku
				xor		ax,ax
				mov		ah,3Eh				 ;zamkniecie pliku
				int		21h	            

				xor		ax,ax
				mov		ah,4ch
				int		21h	 
          
; procesuj zawartosc bufora
analizujNute:
                mov     ax,36060 ;C 
	            cmp     dl,'C'
	            je      ustawNute
	            mov     ax,34000 ;C# 
	            cmp     dl,'c'
	            je      ustawNute
	            mov     ax,32162 ;D 
	            cmp     dl,'D'
	            je      ustawNute
	            mov     ax,30512 ;D# 
	            cmp     dl,'d'
	            je      ustawNute
	            mov     ax,29024 ;E 
	            cmp     dl,'E'
	            je      ustawNute
	            mov     ax,27045 ;F 
	            cmp     dl,'F'
	            je      ustawNute
	            mov     ax,25869 ;F# 
	            cmp     dl,'f'
	            je      ustawNute
	            mov     ax,24286 ;G 
	            cmp     dl,'G'
	            je      ustawNute
	            mov     ax,22885 ;G# 
	            cmp     dl,'g'
	            je      ustawNute
	            mov     ax,21636 ;A 
	            cmp     dl,'A'
	            je      ustawNute
	            mov     ax,20517 ;A# 
	            cmp     dl,'a'
	            je      ustawNute
	            mov     ax,19193 ;H 
	            cmp     dl,'H'
	            je      ustawNute
	            mov		ax,10000	
	            cmp     dl,'P'	
	            je      ustawNute

                jmp     koniec

ustawNute:
; obliczenia aby dostac odpowiedni dzwiek
                mov     cl,ds:[1]		;oktawa
	            sub     cl,30h			;rzeczywista wartosc
	            shr     ax,cl			;przesuniecie o oktawy
	            xor     cx,cx			

                call    grajNute

; poczekaj
				mov		cl,ds:[2]       ;pobierz czas oczekiwania z pliku    
				sub		cl,30h  		;zamien na rzeczywista wartosc
				xor		dx,dx			;procesor odczeka cx:dx mikrosekund
				xor		ax,ax
				mov		ah,86h			
				int		15h

                ret

grajNute:
; generuj ton
                out     42h,al			;wysylanie nuty (dzielnika czestotliwosci) 
	            mov     al,ah
	            out     42h,al			; 1 193 181 Hz, timer 2

; ustaw glosnnik
	            in      al,61h			;odczyt danych na porcie 61h (port kontrolera klawiatury), ktory kontroluje czy bd otwarty kanal do glosnika
	            or      al,3			;2 ostatnie bity na 1: bramka do glosnika (otwarta 0 lub zamknieta 1), mozliwosc wyslania danych do glosnika 
	            out     61h,al			;wyslanie danych

	            ret
                           
Progr           ends

dane            segment
                bufor	    DB 0,0,0
                odnosnik	DW 0 
                nazwaPliku	DB 127 dup(0);
dane            ends

stosik          segment
		dw    100h dup(0)                       
        szczyt          Label word   
stosik          ends

end start