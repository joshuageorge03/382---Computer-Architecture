.text
.global _start
.extern printf

_start:
    ADR x0, bst          // Address of bst
    ADR x1, inp          //Address of the input values array
    ADR x5, inp_len 
    LDR x2, [x5, #0]     // Length of the  array
    MOV x6, #0           //Current index value
    MOV x7, #0           //Parent index
    SUB SP, SP, #16      // create space in stack
    STUR x30, [SP, #0]   // return address
    BL insertion         // insertion function
    BL IOTrav            //inorder traversal function
    B Done               // go to done

.func insertion
insertion:
    SUB SP, SP, #64      // create space on the stack
    STR x22, [SP, #0]    // Save registers on the stack
    STR x23, [SP, #8]
    STR x24, [SP, #16]
    STR x25, [SP, #24]
    STR x26, [SP, #32]
    STR x27, [SP, #40]
    STUR x30, [SP, #48]  // save return address
    
    MOV x22, x0          // top of stack/root of bst
    MOV x23, x1          // Address of the input array
    MOV x24, x2          // Length of the input array
    MOV x25, x6          // Current index value
    MOV x26, x7          // Parent index
    MOV x27, #3          // x27 = 3
    BL L1                // L1 insertion helper
    MOV x0, x22          // Return with root

    LDR x22, [SP, #0]    // Restore registers from the stack
    LDR x23, [SP, #8]
    LDR x24, [SP, #16]
    LDR x25, [SP, #24]
    LDR x26, [SP, #32]
    LDR x27, [SP, #40]
    LDUR x30, [SP, #48]  // Restore the return address from the stack
    ADD SP, SP, #64      // Deallocate space on the stack
    BR x30               // Return to the caller

L1:
    SUB SP, SP, #32      // Allocate space on the stack
    STR x24, [SP, #0]    // Save registers on the stack
    STR x25, [SP, #8]
    STR x26, [SP, #16]
    STUR x30, [SP, #24]  // Save the return address on the stack

    CMP x24, #0          // length of array = 0?
    BEQ return           // then go to return
    LDR x15, [x23, x25]  // Current value in the input array
    CMP x25, #0          // if it's the root node
    BEQ root             // go to the root case
    LDR x16, [x22, x26]  // Value at the parent node
    CMP x15, x16         // current value = parent value?
    BEQ Ldone            // go to Ldone
    CMP x15, x16         // current value = parent value?
    BGT rightnode        //  if > then go to rightnode
    MOV x17, #8          
    B L2

rightnode:
    MOV x17, #16         // Set the multiplier for right node

L2:
    ADD x18, x26, x17    // find index for child
    LDR x17, [x22, x18]  // Value at the  child index
    CMP x17, -1          // if child is empty,
    BLE continue         // continue with the insertion
    LDR x24, [SP, #0]    // Restore registers from the stack
    LDR x25, [SP, #8]
    LDR x26, [SP, #16]
    LDUR x30, [SP, #24]  // Restore the return address from the stack
    ADD SP, SP, #32      // remove space
    MOV x26, x17         // Move to the left/right child
    B L1

continue:
    MUL x19, x25, x27    // find index of current value
    STR x15, [x22, x19]  // Store the current value in the array
    STR x19, [x22, x18]  // Store the index of child
    MOV x20, -1         
    ADD x19, x19, #8     // +8 for next index of the child 
    STR x20, [x22, x19]  // Set the left child index to -1
    ADD x19, x19, #8     // +8 for the index of next child
    STR x20, [x22, x19]  // Set the right child index to -1
    B Ldone

return:
    LDUR x30, [SP, #24]  // Restore the return address from the stack
    ADD SP, SP, #32
    BR x30

root:
    STR x15, [x22, #0]  // Store the current value at the root of the BST
    MOV x16, -1         // Set the index for non-existent child
    STR x16, [x22, #8]  // Set the left child index to -1
    STR x16, [x22, #16] // Set the right child index to -1

Ldone:
    LDR x24, [SP, #0]   // Restore registers from the stack
    LDR x25, [SP, #8]
    LDR x26, [SP, #16]
    LDUR x30, [SP, #24] // Restore the return address from the stack
    
    ADD SP, SP, #32     
    SUB x24, x24, #1    // -1 length of the array
    ADD x25, x25, #8    // +8 for the index of next child
    MOV x26, #0         // set parent to 0
    B L1                // Branch to the insertion helper function

.endfunc
 
.func IOTrav
IOTrav:
    SUB SP, SP, #32     
    STR x22, [SP, #0]   
    
    STR x23, [SP, #8]
    STUR x30, [SP, #16] 
    
    MOV x22, X0         //Top of the stack (root of the BST)
    MOV x23, #0         // Current index value
    BL Htrav            // Branch to the inorder traversal helper function
    B IOTrav4           // Branch to IOTrav4

Htrav:
    SUB SP, SP, #16     // add space 
    STR x23, [SP, #0]   
    STUR x30, [SP, #8]  // save return address
    
    ADD x16, x23, #8    // find index for left child
    LDR x16, [x22, x16] // Value at the left child index
    CMP x16, -1         // Check if left child is empty
    BLE IOTrav2         // If empty, skip to IOTrav2
    MOV x23, x16         // Move to the left child
    BL Htrav

IOTrav2:
    LDR x23, [SP, #0]   
    ADR x0, output      
    LDR x1, [x22, x23]  //  Value at the current index
    BL printf           
    ADD x16, x23, #16   // find index of right child
    LDR x16, [x22, x16] // Value at the right child index
    CMP x16, -1         // Check if right child is empty
    BLE IOTrav3         // If empty, go to IOTrav3
    MOV x23, x16         // Move to the right child
    BL Htrav

IOTrav3:
    LDR x23, [SP, #0]   
    LDUR x30, [SP, #8]  // load return address 
    ADD SP, SP, #16     // remove space from stack
    BR x30              // Return

IOTrav4:
    LDR x22, [SP, #0]   // Restore registers from the stack
    LDR x23, [SP, #8]
    LDUR x30, [SP, #16] // load return address 
    ADD SP, SP, #32     
    BR x30              // Return

.endfunc
Done:
    LDUR x30,[SP, #0]
    ADD SP, SP, #16
    MOV x0, #0
    MOV w8, #93
    SVC #0
 
.data
inp:
    .dword 4,14,26,1,7,19
inp_len:
    .dword 6
output:
    .ascii "%d\n\0"
.bss
bst:
    .space 1024
.end
