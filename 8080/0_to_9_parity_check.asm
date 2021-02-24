	 ORG 800H  
	 MVI B,48  
PETLA  
	 MOV A,B  
	 ANI 1  
	 JZ EVEN  
	 JNZ ODD  
EVEN  
	 MOV A,B  
	 RST 1  
	 INR B  
	 LXI H,TEXTEVEN  
	 RST 3  
	 MOV A,B  
	 CPI 58  
	 JNZ PETLA  
	 HLT  
ODD  
	 MOV A,B  
	 RST 1  
	 INR B  
	 LXI H,TEXTODD  
	 RST 3  
	 MOV A,B  
	 CPI 58  
	 JNZ PETLA  
	 HLT  
TEXTEVEN 	 DB ': i parzyste',10,13,'@'      
TEXTODD 	 DB ': i nieparzyste',10,13,'@'      
