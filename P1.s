.text
.global _start
.extern printf
_start:
   .global proj1
proj1:
   mov x5, #0        // set the counter L to 0
   adr x22, inplen    // set x22 to the address of the length of input
   ldr x22, [x22, #0] // set x22 to the actual value of input length
   adr x21, inpdata   // set x21 to the address of the input
   Loop: subs x3, x5, x22  // compare L and x22 and put it into x3
   b.eq nextstep             // if equal to zero, then go to next step
   lsl x25, x5, #3         // otherwise, multiply the counter by 4 and put into N
   ldr x16, [x21, x25]       // load the array element with the correct offset into K
   bl ADDCount                // adds the # of occurences to the array 
   add x5, x5, #1          // increment the counter by 1
   B Loop
 
 
ADDCount:
  mov x24, x30   //  store return address into x24
  adr x12, storarray // address of the storage array
  lsl x13, x16, #3   // register holds offset
  mov x14, #0        // clear out x14
  ldr x14, [x12, x13]  // load the current value in the array
  add x14, x14, #1    // update the count by one to reflect new count
  str x14, [x12, x13]  // now put the updated count back into the array at the right offset
  mov x30, x24  // move value of x24 back into x30
  br x30        // go back to caller
nextstep:
   bl maxarray
   bl printhistogram
   bl printrank
 
 
 
printhistogram:
   mov x28, x30 // stores return address in x28
   adr x17, storarray  // stores address of storarray in C
   mov x18, #0         // counter in E
   add x16, x16, #1
   mov x25, x16
   mov x3, #0
   HistoLoop: subs x3, x18, x25  // loops through variables in histogram
   b.eq exitprinthistogram        // if counter equals length break
   lsl x24, x18, #3               // left shift counter for right offset, put in D
   ldr x24, [x17, x24]            // load count of that index
   ldr x0, =in4                 // load output formatter
   mov x1, x18                // move index to x1
   mov x2, x24                // move value to x2
   bl printf                  // print
   add x18, x18, #1          // increment offset
   mov x3, #0               // reset x3
   B HistoLoop             // branch to loop
exitprinthistogram:
   mov x30, x28    // move proper return address back to x30
   br x30          // return
 
 
maxarray:
  mov x24, x30   // put return address in D
  bl printheader
  adr x10, inplen // address of length of array
  ldr x10, [x10, #0]  // load value into x10
  adr x12, inpdata   // load address of array into max
  ldr x16, [x12, #0] // K holds the answer, right now x12 first element
  mov x11, #0 // x11 is the counter
  mov x22, #0 // x22 is a temp variable
  MaxLoop: subs x22, x11, x10 // loop while there are still elements to look at
  b.eq maxexit               // if there are no more elements in array go to exit
  lsl x22, x11, #3           // left shift the counter to find the offset
  ldr x22, [x12, x22]         // load the value
  cmp x16, x22               // compare
  b.le lesser                //  if the current val is lesser go to lesser
  mov x22, #1                // else put 1 into x22
  add x11, x11, x22          // increment the counter
  mov x22, #0                // reset x22
  B MaxLoop                  // go back to loop
  lesser:                    // lesser
      mov x16, x22           // the max into the answer register
      mov x22, #1            // move 1 into x22
      add x11, x11, x22      // increment the counter
      mov x22, #0            // reset x22 to #0
      B MaxLoop              // branch back to loop
maxexit:
  mov x30, x24 // move return address back into x30
  mov x29, x16 // put the final max into x29
  br x30       // branch to exit
printheader:
   mov x28, x30
   ldr x0, =header
   bl printf
   mov x30, x28
   br x30
printrank:
   mov x28, x30  // put return address of function into D
   mov x5, #101 // x5 is max value of loop which is storarray length
   mov x22, #0          // move counter into G
   adr x12, rank        // move address rank into V
   ldr x21, [x21, #0]   // move rank into V
   adr x16, storarray   // move address of storarray to use to find values
   FindRankLoop: subs x18, x5, x22   // start a loop for counter and input length
   b.eq badexitprintrank  // if the counter is equal to inputlength whole array traversed but rank not found so bad
   mov x25, x22           // move the counter into N
   lsl x25, x25, #3       // calculate right offset and put into N
   ldr x25, [x16, x25]    // load the value from storarray into N
   sub x21, x21, x25      // subtract the value from the rank
   cmp x21, #0            // if the rank is equal to 0 then we found value, good exit
   b.eq goodexitprintrank
   mov x12, #0
   subs x12, x12, #1        // store into x12 the value of -1
   cmp x21, x12            // if V is equal to -1 than we found value, good exit
   b.eq goodexitprintrank
   add x22, x22, #1       // if not then increment the counter for the loop
   B FindRankLoop         // branch back to the loop
goodexitprintrank:
    ldr x0, =rankstring
    adr x1, rank
    ldr x1, [x1, #0]
    mov x2, x22
    bl printf
    b Exit
badexitprintrank:
    ldr x0, =rankstring
    adr x1, rank
    ldr x1, [x1, #0]
    mov x2, #0
    sub x2, x2, #1
    bl printf
    b Exit
Exit:
   mov x8, #93  // exit
   svc #0
.data
   inpdata:
       .dword 2, 0, 2, 3, 4, 6
   inplen:
       .dword 6
   rank:
       .dword 4
   storarray:
       .dword 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   in4:
       .asciz "%d\t%d\n" // string operand
   header:
       .asciz "Number\tCount\n"
   rankstring:
       .asciz "Element at rank %d:%d\n"
.end
 