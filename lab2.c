#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void display(int8_t bit) {
    putchar(bit + 48);
}

void display_32(int32_t num) {

    for (int i = 31; i >= 0; i--) {
        int8_t bit = (num >> i) & 1;
        display(bit);
    }
}

int main(int argc, char const *argv[]) {
    for(int i = 1; i<=10; i++){
        int add = add + i;
        
    }
    print(add)
    int32_t x = 382;
    display_32(x);

   
    return 0;


     
}


// Joshua George
//I pledge my honor that I have abided by the Stevens Honor System. 