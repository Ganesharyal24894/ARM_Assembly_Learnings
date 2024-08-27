# ARM_Assembly_Learnings
Repository documenting my learning journey of ARM assembly instructions. Includes detailed notes and examples of each instruction as I master them.

## Instructions :-

### LABEL
	_label:
	_mylabel:  ; section of code labeled _mylabel
Gives a label to a section of code (similar to a function name, 'label' is not a keyword this can be anyname).

### GLOBAL

	.global
	.global _mylabel	; making _mylabel globally visible
Makes a label/variable global, so that it is globally visible to other files as well.


### **MOV**

	mov r0,#69 
	mov r1,#0x49 
	mov r0,r1 
Used for moving data into the register. When loading a small immediate value, you can use `mov` (which is faster but has only 12 bits for immediate data out of 32 bits), but for loading large immediate values like memory locations, use the `ldr` instruction, which uses a pseudo-instruction to accomplish this. for more details - https://stackoverflow.com/questions/14046686/why-use-ldr-over-mov-or-vice-versa-in-arm-assembly

### **LDR**

	ldr	
Loads data from memory to register.

	ldr r1,[r0] 
Here R0 contains the memory location from where the data is fetched.

	ldr r0,=0x0020300
It can also be used to assign immediate memory location/any value into a register.

	ldr r1,= my_data 
	.data
	my_data:
		.word 45,56,23,34

Here my_data is a label that points to the first data (45) in memory and the address of this data can be stored using given syntax.

### ADD, ADDS and ADC

	add r3,r2,r1 ; r3=r2+r1 without updating flags

Adding two values stored in registers and store the result in another register without updating any flag in the CPSR ( Current Program Status Register ). 


	adds r3,r2,r1 ; r3=r2+r1 with flags updation

Adding two values, stored in registers and store the result in another register. Flags are not ignored and they are updated in CPSR register. 

	adc r0,r3,r4 ; r0=r3+r4+carrybit

Takes carry bit into consideration while adding values.

Flag bits are :
N (Negative) : set if the result is negative.
Z (Zero) : set if the result is zero.
C (Carry) : set if the addition result generates a carry.(used in unsigned arithmetic).
V (Overflow) : set if the addition results in overflow(used in signed arithmetic).   


### AND and ANDS

	AND r0,r1,r2         ; r0 = r1 & r2
	AND r0,r0,#0xff      ; r0 = r0 & 0xff
	AND r2,r2,0xffffff00 ; all the bits except first 8 bits will get masked	

Used for 'Anding' values and can also be used to clear/mask unwanted bits of a register.

	ANDS r0,r3,r4 ; updates CPSR flags

Same as **AND** operation but also updates flag inside CPSR register. Generally adding 'S' at the end of instructions will be equivalent to an instruction that performs same operation and updates the flag bits, like ORRS = ORR + flag bit updation.

### MOVN ,ORR, EOR

	MOVN R0,#0xaa ;0xaa will be negated and then stored into r0 
											(r0 = 0xffffff55)				

Used for **NOT** operation of data while moving it from one register to another register.

	ORR r0,r2,r1    ; r0 = r2 | r1
	ORR r2,r2,#0x07 ; r2 = r2 | 0x07

Used for **OR** operation of data.

	EOR r0,r0,#0x02 ; r0 = r0 ^ 0x02

Used for **EX-OR** operation between two data.


### LSL, LSR and ROR

	LSL R0, #3         ; R0 = R0 << 3
	LSL R0, R1, #2     ; R0 = R1 << 2
	MOV R1, R0, LSL #1 ; R1 = R0 << 1

Logical shift left operation, also used or multiplication. You can also combine this with mov instruction to move and shift in one operation.

	LSR R0, #4         ; R0 = R0 >> 4
	LSR R0, R1, #2     ; R0 = R1 >> 2
	MOV R1, R0, LSR #1 ; R1 = R0 >> 1

Logical shift right operation, also used for division.

	ROR R0, #4         ; R0 = R0 rotated right by 4 bits 
	ROR R0, R1, #2     ; R0 = R1 rotated right by 2 bits
	MOV R1, R0, ROR #1 ; R1 = R0 rotated right by 1 bits
Rotate right operation.
## **Types of addressing modes :-**
#### 1. Immediate addressing mode:
Immediate data is provided.

	mov r0,#34
#### 2. Register direct addressing mode:
When the data is copied from one register to another.

	mov r3,r4
#### 3. Indirect register addressing mode:
The data is moved from a memory location (which is stored inside a register) to a register.

	ldr r0,[r3]	

Here in this R3 contains some memory location.

	ldr r0,[r3,#4]

'#4' is memory location offset {which means that it will fetch the data from (r3+4) memory location and store it in r0}.

## Post-increment and Pre-increment in Assembly

	ldr r0,[r3],#4
**Post-increment** : It means suppose R3 stores memory location 0x4523, so after fetching data from this location R3 will be incremented by four and to access next memory location now you don't have to add offset because R3 will already be (0x4523+4) equals to next memory location.


Example program for Post-increment :

		.global _start
	_start:
		ldr r0,=0xff200020   ; address of SSD display
		ldr r1,=list   ; store address of list
		ldr r2,[r1],#4 ;fetching the data(0x3f)into r2 and then incrementing r1
		str r2,[r0]    ;storing data from r2 register to address contained in r0
		ldr r2,[r1],#4 ;fetching the data(0x06)into r2 and then incrementing r1
		str r2,[r0]    ;storing data from r2 register to address contained in r0
		ldr r2,[r1],#4 ;fetching the data(0x5b)into r2 and then incrementing r1
		str r2,[r0]    ;storing data from r2 register to address contained in r0
		ldr r2,[r1],#4 ;fetching the data(0x4f)into r2 and then incrementing r1
		str r2,[r0]    ;storing data from r2 register to address contained in r0
		
	
	.data
	list:
		.word 0x3f,0x06,0x5b,0x4f

---

	ldr r0,[r3,#4]!
**Pre-increment** : It means the value of R0 will be, data stored in (R3+4) memory location because before fetching data it will first increment the value of R3 by 4 and then fetch data from that memory location. 

Example program for Pre-increment :

	.global _start
	_start:
		ldr r1, =my_data ;loades address of my_data
		ldr r3,[r1]      ;fetching data(0x01) from address contained in r1
		mov r0,#0x05     ;moving 0x05 in r0 register
		add r2,r0,r3     ;r2=r0+r3
		str r2,[r1,#4]!  ;first increment address stored in r1 by 4 and store value of r2 in that address
		
	
	.data
	my_data:
			.word 0x01,0x79,0x5b

## Branching Instructions

1. **B** ( Branch ) Unconditional branch

		B target_label
	
		target_label:
			mov r0,#0x69
			
2. **BEQ** ( Branch if equal , Zero Flag = 1 )

		.global _start
		_start:
		mov r2,#3      ; store 3 in r2
		subs r3,r2,#3  ; r3 = r2 - 3
		beq zero_label ; check if operation resulted in zero
		mov r1,#10     ; will get executed if operation did not result in zero
		
		zero_label:
		mov r0,#9      ; assembler jumps here if the subtraction resulted in zero
		
		mov r7,#0x01   ; ends the program
		swi 0

3. **BNE** (Branch if not equal, Zero flag = 0)

		.global _start
		_start:
		mov r2,#3      ; store 3 in r2
		cmp r2,#4      ; comparison of r2 with value 4 
		bne notequal_label ; check if not equal
		mov r1,#10     ; will get executed if assembler did not jump
		
		notequal_label:
		mov r0,#9      ; assembler jumps here if they were not equal
		
		mov r7,#0x01   ; ends the program
		swi 0

4.  **BGT** (Branch if greater than, Z=0 and N=V)

		.global _start
		_start:
		mov r2,#0x45       ; store 0x45 in r2
		cmp r2,#0x59       ; comparison of r2 with value 0x59
		bgt greater_label  ; check if r2 > 0x59
		mov r1,#10         ; will get executed if assembler did not jump
		
		greater_label:
		mov r0,#9          ; assembler jumps here if r2 > 0x59
		
		mov r7,#0x01       ; ends the program
		swi 0
 5. **BLT** (Branch if less than, N≠V) 
    Come on you don't need examples anymore, format is more or less same just keep in mind these branching instructions can be used anywhere, it is not necessary to use them after CMP only. You can use it after ADDS, SUBS anything ( that updates flag bits ) these branching instruction just do the work of checking the flags that I have written in the bracket and if the condition is met they simply jump.
1. **BGE** (Branch if greater than or equal, N=V)
2. **BLE** (Branch if less than or equal, Z=1 or N≠V)











