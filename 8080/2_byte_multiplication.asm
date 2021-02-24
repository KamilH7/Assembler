	 ORG 800H  
START  
	 CALL WPISZDANE  
	 CALL SPRAWDZDANE  
PETLALICZACA  
	 MOV A,C  
	 CPI 0  
	 JZ WYPISZWYNIK  
	 DAD D  
	 DCR C  
	 JMP PETLALICZACA  
WPISZDANE  
	 LXI H,PRZYWITANIE  
	 RST 3  
	 LXI H,LICZBA1  
	 RST 3  
	 RST 5  
	 MOV C,E  
	 MOV B,D  
	 LXI H,LICZBA2  
	 RST 3  
	 RST 5  
	 LXI H,WYNIK  
	 RST 3  
	 LXI H,0  
	 RET  
SPRAWDZDANE  
	 MOV A,B  
	 CPI 0  
	 JNZ BLEDNEDANE  
	 MOV A,D  
	 CPI 0  
	 JNZ BLEDNEDANE  
	 RET  
BLEDNEDANE  
	 LXI H,BLEDNYWYNIK  
	 RST 3  
	 JMP START
WYPISZWYNIK  
	 MOV A,H  
	 RST 4  
	 MOV A,L  
	 RST 4  
	 HLT    
PRZYWITANIE  
	 DB 'MNOZENIE DWOCH LICZB@'                    
LICZBA1  
	 DB 10,13,'PODAJ PIERWSZA LICZBE (0-FF): @'                    
LICZBA2  
	 DB 10,13,'PODAJ DRUGA LICZBE (0-FF): @'                    
WYNIK  
	 DB 10,13,'WYNIK MNOZENIA: @'              
BLEDNYWYNIK  
	 DB 'PODALES ZLE DANE!',10,13,10,13,'@'              
