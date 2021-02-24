	 ORG 800H  
	 MVI B,'0'  
	 MVI C,'0'  
PETLA  
	 MOV A,B  
	 RST 1  
	 MOV A,C  
	 RST 1  
	 MVI A,13  
	 RST 1  
	 MVI A,10  
	 RST 1  
	 INR C  
	 MOV A,C  
	 CPI 3AH  
	 JNZ PETLA  
	 MVI C,'0'  
	 INR B  
	 MOV A,B  
	 CPI 3AH  
	 JNZ PETLA  
	 HLT  
