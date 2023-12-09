.text
.global _start
.extern printf
_start:
    .global func1
func1:
    adr x19, buf                 // Load address of buf
    adr x23, ten                 // Load address of ten
    ldr x23, [x23, #0]           // load value at address of x23 into x23
    mov x20, #0                  // set x20 to 0

loop:
    mov x0, #0                   // Set x0 to 0 
    mov x1, x19                   // Set x1 to the address stored in x19 (buffer)
    mov x2, #1                    // size of byte to be written
    mov x8, #63                   // system call number for write
    svc 0                       

    ldr x9, [x19, #0]             // Load the byte at the address stored in x19 into x9
    cmp x9, #10               
    bne con                     // Branch to stop if equal
    mul x20, x20, x20             // Square the result (x^2)
    mov x25, #1                   // Initialize x25 to 1
    b find                    

con:
    sub x9, x9, #48                // Convert ASCII to integer
    mul x20, x20, x23             // Multiply the accumulated result by 10
    add x20, x20, x9              // Add the current digit
    b loop     
    
find:
    cmp x25, x20                  // Compare x25 with x20
    ble L1                   // Branch if greater than
    sdiv x25, x25, x23            // Divide x25 by 10
    b print

L1:                       
    mul x25, x25, x23             // Multiply x25 by 10
    b find

print:
    cmp x25, #0                  
    beq exit                     //exit if equal
    sdiv x27, x20, x25            
    add x21, x27, #48             // Convert the digit to ASCII
    str x21, [x19, #0]            // Store the ASCII digit in the buffer
    mov x0, #1                    
    mov x1, x19                    // Set x1 to the address stored in x19 (buffer)
    mov x2, #1                    // Set x2 to 1 (size of byte to be written)
    mov x8, #64                   // Set x8 to 64 (system call number for write)
    svc 0                         
    mul x24, x27, x25             //x25 x digit
    sub x20, x20, x24             // x20 - digit
    sdiv x25, x25, x23            //  x25 / 10
    b print                       // Branch to print

exit:
    mov x27, #10                  // Set x27 to 10 (newline character)
    str x27, [x19, #0]            // Store the newline character in the buffer
    mov x0, #1                    // Set x0 to 1 (file descriptor for standard output)
    mov x1, x19                    // Set x1 to the address stored in x19 (buffer)
    mov x2, #1                    // Set x2 to 1 (size of byte to be written)
    mov x8, #64                   
    svc 0                        

    mov x0, 0                     
    mov w8, 93                
    svc 0                     

.bss
    buf: .space 100               // 100 bytes for the buffer
    arr: .dword                   
.data
in4:
    .asciz "%d\n"                  
ten:
    .dword 10                   
.end
