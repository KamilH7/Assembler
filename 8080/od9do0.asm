	 ORG 800H  
	 MVI A,39H  
PETLA  
	 RST 1  
	 DCR A  
	 CPI 2FH  
	 JNZ PETLA  
	 HLT  
