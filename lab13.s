.text
.global _start
_start:

// Load addresses of arrays x and y into registers x1 and x2
LDR x1, =x
LDR x2, =y

// Initialize loop variables and lengths
MOV x5, #0      // i = 0
MOV x6, #0      // j = 0

ADR x0, N        // Address of length variable
LDUR x11, [x0]   // Load length into x11

// Initialize variables for tracking indices and distances
MOV x12, #10000 // minIndexI
MOV x13, #0     // maxIndexI
MOV x14, #10000 // minIndexJ
MOV x15, #0     // maxIndexJ

// Initialize variables for storing distances
ADR x0, maxDis
LDUR D7, [x0]    // maxDistance
ADR x0, minDis
LDUR D8, [x0]    // minDistance

// Outer loop: Iterate over i values
iLoop:
    CMP x5, x11  // Check if i < length
    bge EndiLoop

// Inner loop: Iterate over j values
jLoop:
    CMP x6, x11  // Check if j < length
    bge EndjLoop

    // Check if i != j
    CMP x5, x6
    beq hop

    // Calculate indices i * 8 in x9 and j * 8 in x10
    MOV x9, #8
    MUL x7, x5, x9
    MUL x8, x6, x9

    // Setup function call to Euclidean distance
    LDR D3, [x1, x7]  // x1
    LDR D4, [x2, x7]  // y1
    LDR D5, [x1, x8]  // x2
    LDR D6, [x2, x8]  // y2
    BL Euclidean

    FCMP D0, D7  // if distance > maxDistance, update
    ble L1

    // Update max indices and distance
    MOV x13, x5
    MOV x15, x6
    FMOV D7, D0

    L1:
    FCMP D0, D8     // Check if distance < minDistance
    bge L2

    // Update min indices and distance
    MOV x12, x5
    MOV x14, x6
    FMOV D8, D0
    L2:

hop:
    ADD x6, x6, #1  // Increment j
    b jLoop

EndjLoop:
    MOV x6, #0          // Reset j to 0
    ADD x5, x5, #1    // Increment i
    b iLoop

EndiLoop:

// Output results
    mov x1, x12
    mov x2, x14
    mov x3, x13
    mov x4, x15
    adr x0, print
    bl printf


    mov x0, #0
    mov w8, #93
    svc #0

    // Euclidean distance function
    .func Euclidean
    Euclidean:
        // Calculate squared differences and sum them up
        FSUB D5, D5, D3
        FSUB D6, D6, D4
        FMUL D5, D5, D5
        FMUL D6, D6, D6
        FADD D0, D6, D5

        // Return result
        br x30
    .endfunc

.data
print : .asciz "Shortest distance is at index (i,j)= (%d,%d). Longest distance is at index (i,j) = (%d,%d).\n"
minDis : .double 1000
maxDis : .double 0

N:
.dword 8
x:
	.double 0.0, 0.4140, 1.4949, 5.0014, 6.5163, 3.9303, 8.4813, 2.6505
y:
	.double 0.0, 3.9862, 6.1488, 1.047, 4.6102, 1.4057, 5.0371, 4.1196
.end
