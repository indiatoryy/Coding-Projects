.text 
.global _start, SWAP
_start: 
LDR R4, =LIST 
LDR R10, [R4] 

MAIN: 
MOV    R8, #0 
MOV R9, #1 
ADD R5, R4, #4 

LOOP: 
CMP R9, R10 
BEQ END_FOR
MOV R0, R5 
BL SWAP
ORR R8, R8, R0 

ADD R9, R9, #1
ADD R5, R5, #4 
B LOOP

END_FOR: 
SUB R10, R10, #1 
CMP R8, #0 
BNE MAIN


END: 
B END

SWAP: 
PUSH {R1-R3}
MOV R3, R0
MOV R0, #0 

LDR R1, [R3] 
LDR R2, [R3, #4] 
CMP R1, R2
BLT END_SWAP

STR R2, [R3]
STR R1, [R3, #4]
MOV R0, #1 

END_SWAP: 
POP {R1-R3}
MOV PC, LR 



.end 