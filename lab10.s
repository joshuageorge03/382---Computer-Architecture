.text
.global _start
_start:

ADR X0, a // Initialize lower bound
LDUR D20, [X0] // Load lower bound into D20
ADR X0, b   // Initialize upper bound
LDUR D21, [X0] // Load upper bound into D21
ADR X0, n   // Initialize number of rectangles
LDUR D22, [X0] // Load number of rectangles into D22

// Get width of the rectangles
fsub D23, D21, D20
fdiv D23, D23, D22
ADR X0, zero
LDUR D24, [X0] // Initialize loop counter to zero
LDUR D28, [x0] // Initialize sum to zero
ADR X0, half
LDUR D25, [X0] // Load 0.5 into D25

loop:
fcmp D24, D22  // If current index >= # rectangles, done
bge Done

// Get midpoint
fadd D26, D24, D25 // counter + 0.5
fmul D26, D26, D23  // D26 * width = D26
fadd D26, D26, D20 // D26 + lowerbound = D26
fmov D5, D26
bl L1

// Calculate rectangle area and update the sum
fmul D27, D23, D10 // width * L1(D26)
fadd D28, D28, D27 //  D26 * L1(D26)
fadd D24, D24, D25 // .5+ to D24
fadd D24, D24, D25 // .5+ to D24
b loop

Done:
// Print results
fmov D0, D20
adr x0, LL
bl printf
fmov D0, D21
adr x0, RL
bl printf
fmov D0, D22
adr x0, rect
bl printf
fmov D0, D28
adr x0, final
bl printf
mov x0, #0
mov w8, #93
svc #0

// Function to compute the value of the polynomial
.func L1
L1:
ADR X0, zero
LDUR D10, [X0] // D10 is the sum

ADR X0, co1   
LDUR D12, [X0]    //load co1
fmul D11, D5, D5
fmul D11, D11, D11
fmul D11, D11, D12
fadd D10, D10, D11 // 8.32x^4

ADR X0, co2     
LDUR D12, [X0]  // load co2 
fmul D11, D5, D5
fmul D11, D11, D12
fsub D10, D10, D11 // -6.53x^2

ADR X0, co3
LDUR D12, [X0]  // load co3
fmul D11, D5, D12
fadd D10, D10, D11 // 9.34x

ADR X0, co4
LDUR D12, [X0]  // load co4
fadd D10, D10, D12 // 12.32

// Store result in D10
fmov D10, D10
br x30
.endfunc
.data

a: .double -1
b: .double 1
n: .double 10


// Coefficients
co1: .double 8.32
co2: .double 6.53
co3: .double 9.34
co4: .double 12.32
zero: .double 0.0
half: .double 0.5

final: .asciz "Result is %f\n"
LL: .asciz "Left limit is %f\n"
RL: .asciz "Right limit is %f\n"
rect: .asciz "Number of Rectangles is %f\n"

.bss
result: .skip 8 
