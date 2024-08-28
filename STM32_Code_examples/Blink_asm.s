.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.equ RCC_BASE_ADD,0x40023800
.equ GPIOC_BASE_ADD,0x40020800

.equ AHB1ENR_OFF,0x30
.equ MODER_OFF,0x00
.equ BSRR_OFF,0x18

.equ GPIOC_EN_BIT,0x04
.equ BSRR_RST_BIT,29
.equ BSRR_SET_BIT,13

.equ DELAY,800000


.global main
main:

	//enable GPIOC port
	ldr r0,=RCC_BASE_ADD
	ldr r1,[r0,#AHB1ENR_OFF]
	orr r1,r1,#GPIOC_EN_BIT
	str r1,[r0,#AHB1ENR_OFF]

	//set PC13 as Output
	ldr r0,=GPIOC_BASE_ADD
	ldr r1,[r0,#MODER_OFF]
	mov r2, #1
   	lsl r2, r2, #26
    orr r1, r1, r2
    mov r2, #1
    lsl r2, r2, #27
    bic r1, r1, r2
	str r1,[r0,#MODER_OFF]

loop:
	//turn ON PC13
	mov r2, #1
   	lsl r2, r2, #BSRR_RST_BIT
	str r2,[r0,#BSRR_OFF]

	//add some delay here
	bl delay


	//turn OFF PC13
	mov r2, #1
   	lsl r2, r2, #BSRR_SET_BIT
	str r2,[r0,#BSRR_OFF]

	//add some delay here
	bl delay

	b loop


delay:
	ldr r2,=DELAY
delay_cont:
	subs r2,r2,#1
	bne delay_cont
	bx lr



	b .


