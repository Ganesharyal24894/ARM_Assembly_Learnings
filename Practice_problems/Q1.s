/*
 *
 * WAP for adding two numbers which are first placed in to some memory
 * location and then fetched from there, after addition store result in some memory location.
 *
 */

ldr r1, =#0x20000000  //load the immediate value 0x20000000
mov r2, #2			      //move value 2 into r2
str r2, [r1]			    //store value of r2(2) in memory location stored in r1

mov r2, #3			      //move value 3 into r2
str r2, [r1,#4]		    //store value of r2(3) into r1+4 memory location (0x20000000+4=0x20000004)

ldr r0,[r1]			      //load data from 0x20000000
ldr r2,[r1,#4]		    //load data from 0x20000004

add r3, r2, r0		    //r3=r2+r0
str r3, [r1]			    //store value of r3 into 0x20000000
