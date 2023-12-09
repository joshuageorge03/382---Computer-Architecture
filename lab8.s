.text
.global _start
.extern printf

    print_num: .asciz "VALUE: %d\n\0"  // Define the format string

_start:

    ADR x0, P // address of P in x0
    ADR x1, C // address of C in x1
    LDR x2, =R // loads value of R into x2
    MUL x3, x2, x2  // x3 = to r squared

    LDUR x5, [x0, #0] // x5 = ARRAY[0]  // x1
    LDUR x6, [x0, #8] // x6 = ARRAY[1]    //y1

    LDUR x7, [x1, #0] // x7 = ARRAY[0]   //x2
    LDUR x8, [x1, #8] // x8 = ARRAY[1]    //y2

    SUB x10, x5, x7   // x1 - x2
    MUL x10, x10, x10   //squared

    SUB x11, x6, x8  // y1 - y2
    MUL x11, x11, x11  //squared

    ADD x12, x11, x10 

    SUB x13, x12, x3 // sum - r^2
    B.GE printno
    B printyes
printyes:
    ldr x0, =yes
    mov x1, #0
    mov x2, #0
    BL printf
    B end

printno:
    ldr x0, =no
    mov x1, #0
    mov x2, #0
    BL printf

end:
    MOV x0, #0
    MOV W8, #93
    SVC #0

.data
    P: .quad 0, 0
    C: .quad 1, 2
    R: .quad 2
    yes: .string "P is inside the circle."
    no: .string "P is outside the circle."

.end

