#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Helper function used to represent y = 1.5x^3 3.2x^2 − 4x + 13
double Fofx(double x) {
    return 1.5 * pow(x, 3) + 3.2 * pow(x, 2) - 4 * x + 13;
}

//a is lower bound b is upper bound n is # of rectangles given by user
double mid(double a, double b, int n) {
    double width = (b - a) / (double)n;  //calculates the width of each subinterval
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
        double x = a + (i + 0.5) * width;  //provides the midpoint of current subinterval 
        sum += Fofx(x) * width; // Calculate the area of the rectangle and add to sum
    }

    return sum;  // represents the approximate integral value
}

int main(int argc, char *argv[]) {
    if (argc != 4) { //checks the amount of arguments; returns 1 if false
        printf("Usage: %s lowerbound : upperbound : initial # rectangles\n", argv[0]);
        return 1;
    }

    double a = atof(argv[1]); //converts string to float
    double b = atof(argv[2]); //converts string to float
    int initial = atoi(argv[3]); //converts string to int


    if (a >= b || initial <= 0) {  //lowerbounds cant be higher than upperbounds;
        printf("Invalid input values.\n");

    }

    int n = initial;
    double prev = 0.0;
    double result = mid(a, b, n);
    int rec = mid(a, b, n);
    printf("Approximation when given initial # of rectangles : %d\n", rec);
    while ((result - prev) > 0.0001) {
        n = (n*2);
        prev = result;
        result = mid(a, b, n);
        

    }
    
    printf("Needed # of rectangles: %d\n", n);
    printf("Last two approximate values: %.6f and %.6f\n", prev, result);

    return 0;
}



// Joshua George
//I pledge my honor that I have abided by the Stevens Honor System.