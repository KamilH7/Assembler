	 ORG 800H  
	 MVI B,'0'  
	 MVI C,'0'  
	 MVI D,'0'  
	 MVI E,'0'  
PETLA  
;wypisywanie 
	 MOV A,B  
	 RST 1  
	 MOV A,C  
	 RST 1  
	 MOV A,D  
	 RST 1  
	 MOV A,E  
	 RST 1  
	 MVI A,13  
	 RST 1  
	 MVI A,10  
	 RST 1  
;jednosci  
	 INR E  
	 MOV A,E  
	 CPI 3AH  
	 JNZ PETLA  
;dziesiatki   
	 MVI E,'0'  
	 INR D  
	 MOV A,D  
	 CPI 3AH  
	 JNZ PETLA  
;setki   
	 MVI D,'0'  
	 INR C  
	 MOV A,C  
	 CPI 3AH  
	 JNZ PETLA  
;tysiace  
	 MVI C,'0'  
	 INR B  
	 MOV A,B  
	 CPI 3AH  
	 JNZ PETLA  
	 HLT  
