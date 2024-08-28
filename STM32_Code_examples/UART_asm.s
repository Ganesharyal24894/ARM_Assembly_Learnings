
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.equ RCC_BASE_ADD,0x40023800
.equ GPIOA_BASE_ADD,0x40020000
.equ USART1_BASE_ADD,0x40011000

.equ APB2ENR_OFF,0x44
.equ AHB1ENR_OFF,0x30
.equ MODER_OFF,0x00
.equ AFRH_OFF,0x24
.equ USART_CR1_OFF,0x0C
.equ USART_BRR_OFF,0x08
.equ USART_SR_OFF,0x00
.equ USART_DR_OFF,0x04

.equ USART1_EN_BIT,0x16
.equ GPIOA_EN_BIT,0x01
.equ USART_TE_BIT,3
.equ USART_UE_BIT,13
.equ USART_TXE_BIT,7

.equ USART_DR_ADD,USART1_BASE_ADD+USART_DR_OFF
.equ USART_SR_ADD,USART1_BASE_ADD+USART_SR_OFF

.global main
main:

	//enable USART1
	ldr r0,=RCC_BASE_ADD
	ldr r1,[r0,#APB2ENR_OFF]
	orr r1,r1,#USART1_EN_BIT
	str r1,[r0,#APB2ENR_OFF]

	//enable GPIOA for USART1
	ldr r0,=RCC_BASE_ADD
	ldr r1,[r0,#AHB1ENR_OFF]
	orr r1,r1,#GPIOA_EN_BIT
	str r1,[r0,#AHB1ENR_OFF]

	/*set GPIO A9 & A10 as Alternate function mode*/

	//PA9 -> USART1_TX
	ldr r0,=GPIOA_BASE_ADD
	ldr r1,[r0,#MODER_OFF]
	mov r2, #1
   	lsl r3, r2, #19
    orr r1, r1, r3
    lsl r2, r2, #18
    bic r1, r1, r2
	str r1,[r0,#MODER_OFF]

	//PA10 -> USART1_RX
	ldr r0,=GPIOA_BASE_ADD
	ldr r1,[r0,#MODER_OFF]
	mov r2, #1
   	lsl r3, r2, #21
    orr r1, r1, r3
    lsl r2, r2, #20
    bic r1, r1, r2
	str r1,[r0,#MODER_OFF]

	//set AF7 for both PA9 and PA10 for using USART1
	ldr r0,=GPIOA_BASE_ADD
	ldr r1,[r0,#AFRH_OFF]
	mov r2, #7
   	lsl r3, r2, #4
   	lsl r2, r2, #8
    orr r1, r1, r3
    orr r1, r1, r2
	str r1,[r0,#AFRH_OFF]

	//setup USART1_CR1 register enable TE bit and UE bit
	ldr r0,=USART1_BASE_ADD
	ldr r1,[r0,#USART_CR1_OFF]
	mov r2, #1
	lsl r3,r2,#USART_TE_BIT
	lsl r2,r2,#USART_UE_BIT
    orr r1, r1, r2
    orr r1, r1, r3
    str r1,[r0,#USART_CR1_OFF]

    //setup baud rate
    ldr r0,=USART1_BASE_ADD+USART_BRR_OFF
	ldr r1,=0x683
	str r1,[r0]

loop:

	bl check_status

	//if TXDR is empty, load data
	ldr r0,=USART_DR_ADD
	mov r1,#0x41		//'A'
	str r1,[r0]

	bl check_status

	//if TXDR is empty, load data
	ldr r0,=USART_DR_ADD
	mov r1,#0x52		//'R'
	str r1,[r0]

	bl check_status

	//if TXDR is empty, load data
	ldr r0,=USART_DR_ADD
	mov r1,#0x4D		//'M'
	str r1,[r0]

	bl check_status

	//if TXDR is empty, load data
	ldr r0,=USART_DR_ADD
	mov r1,#0x0A		//newline
	str r1,[r0]


	b loop


check_status:
	//check for TXDR status
	ldr r0,=USART_SR_ADD
	mov r2,#1
	lsl r2,r2,#USART_TXE_BIT
txdr_wait:
	ldr r1,[r0]
	ands r1,r2
	beq txdr_wait
	bx lr


	b .
