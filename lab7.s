//I pledge my honor that I have abided by the Stevens Honor System. - Joshua George
.text
.global _start

.data
option: .word 1
k: .word 3
print_num: .asciz "VALUE: %d\n\0"  // Define the format string

_start:
    .global max
    .global Sum
    // Initialize pointers and variables
    ADR x22, P         // Takes in data for x22 (array)
    LDR x23, =option   // Load the address of 'option' into x23
    LDR x15, =k        // Load the address of 'k' into X15
    MOV x0, #5         // Length of the array in x0
    MOV x3, #0         // Initialize the variable sum = 0

    // Check the value of 'option'
    
//    CBNZ x23, nono        // If option == 0, call the sum function
//    BL Sum 
//nono:
//    sub x25, x23, #1
//   CBNZ x25, none              // If option == 1, call the max function
//  BL max
//  B end
    BL max
    B end
none:
    B end

max:
    // Function to find the maximum element in an array
    SUB SP, SP, #16    // Shift SP by 16 bytes
    STUR x30, [SP, #8] // Store X30 in SP
    STUR x0, [SP, #0]  // Store X0 in SP
    SUBS x10, x0, #1   // Check if there are more numbers in the array to compare
    BGT L1             // Go to L1 if there are more numbers in the array to compare
    LDUR x1, [x22, #0] // X1 = ARRAY[0]
    ADD SP, SP, #16    // Remove SP
    BR x30             // Return

L1:
    SUB X0, X0, #1      // Decrement X0
    BL max             // Call max function recursively
    LDR x0, [SP, #0]   // Load SP value into x0
    LDR x30, [SP, #8]  // Load SP value into x30
    ADD SP, SP, #16    // Remove SP
    ADD x22, x22, #8   // Increment iterator I
    LDR x2, [x22]      // x2 = ARRAY[I+1]
    SUBS x10, x2, x1   // Compare adjacent values
    BGT L2             // If x2 > x1, go to L2
    BR x30             // Return

L2:
    MOV x1, x2         // Set x1 = x2
    BR x30             // Return

Sum:
    // Function to calculate the sum of elements in an array
    LDR X0, [X15]    // Load the value of k into X0
    SUB X0, X0, #1   // Initialize a loop counter (k - 1)
    MOV X3, #0       // Initialize the variable sum = 0

loop:
    // Load the value from the array at X22 into X1
    LDR X1, [X22], #8 

    // Add X1 to the sum (X3)
    ADD X3, X3, X1

    // Decrement the loop counter
    SUBS X0, X0, #1

    // Check if the loop counter is greater than or equal to zero
    B.GE loop
    

end:
    // Print the result using printf
    LDR x0, =print_num
    BL printf

    // Exit the program
    MOV x0, #0
    MOV W8, #93
    SVC #0

P:
    .quad 92,64,212,99,4
