		AREA BST, CODE, READONLY
		ENTRY
		MOV r8,#20	;initialise counter to 20 
		LDR r2,=HO	;address of HO
		LDR r3,=HA	;address of HA
		
CYCLE
		LDRB r1,[r2],#1	;load values from HO
		STRB r1,[r3],#1	;store values to HA 
		SUBS r8,r8,#1	;decrement counter
		CMP r8,#0		;compare counter to 0
		BNE CYCLE		;loop back till array ends
		
START

		MOV r5,#19		;initialise passes/counter to 19 
		MOV r7,#0		;flag to denote exchange has occured
		LDR r1,=HA		;load the address of first value
		
LOOP1	
		LDRB r2,[r1],#1	;word align to array element
		LDRB r3,[r1]		;load second number
		CMP r2,r3		;compare numbers
		BLT LOOP2		;if r2<r3 go to LOOP2
		STRB r2,[r1],#-1	;interchange number r2&r3
		STRB r3,[r1]		;interchange number r2&r3
		MOV r7,#1		;flag denoting exchange has taken place
		ADD r1,#1		;restore the pointer 
		
LOOP2
		SUBS r5,r5,#1	;decrement counter
		CMP r5,#0		;compare counter to 0
		BNE LOOP1		;LOOP back till array ends
		CMP r7,#0		;comparing flag
		BNE START		;if flag is not zero then go to START loop
		BEQ bst
		
bst		
		LDR r4,=HA ;load sorted array
		MOV r8,#10 ;counter
		LDRB r6,[r4,r8] ;load middle value
		MOV r7,#2 ;smallest value
		CMP r6,r7 
		BNE min
		B max

min
		MOV r8,r8,LSR#1 ;counter/2
		LDRB r6,[r4,r8] ;load middle/2 value 
		CMP r6,r7 
		BNE min
		
max
		MOV r8,#10 ;reset counter
		LDRB r9,[r4,r8] ;load middle value
		MOV r10,#0x98 ;largest value
		CMP r9,r10
		BNE max1
		B stop

max1
		MOV r11,r8,LSR#1 ;counter/2
		B max3
		
max2		
		MOV r11,r11,LSR#1 ;updated counter/2
		
max3
		ADD r11,r8,r11 ;counter+updated counter/2 
		LDRB r9,[r4,r11] ;load value at position counter+updated counter/2
		CMP r9,r10
		BNE max2
			
stop	B stop
		
HO DCB 0x21, 0x02, 0x34, 0x54, 0x33, 0x22, 0x11, 0x09, 0x98, 0x67, 0x59, 0x89, 0x50, 0x60, 0x77, 0x71, 0x37, 0x44,0x47, 0x93
		
		AREA DATA1, DATA, READWRITE
HA DCB 0x0	
		END