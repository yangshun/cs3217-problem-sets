//
//  Overlaps.m
//  
//  CS3217 || Assignment 1
//  Name: Tay Yang Shun
//	Matric No: A0073063M
//

#import <Foundation/Foundation.h>
// Import PERectangle here

// define structure Rectangle
// <definition for struct Rectangle here>

struct Rectangle {
	int origin_x, origin_y, width, height;
};

int overlaps(struct Rectangle rect1, struct Rectangle rect2) {
  // EFFECTS: returns 1 if rectangles overlap and 0 otherwise
	return !((rect1.origin_x + rect1.width < rect2.origin_x) ||
			 (rect2.origin_x + rect2.width < rect1.origin_x) ||
			 (rect1.origin_y + rect1.height < rect2.origin_y) ||
			 (rect2.origin_y + rect2.height < rect1.origin_y));
}


int main (int argc, const char * argv[]) {
	
	/* Problem 1 code (C only!) */
	// declare rectangle 1 and rectangle 2
	struct Rectangle rect1, rect2;
	// input origin for rectangle 1
	printf("Input <x y> coordinates for the origin of the first rectangle: ");
	scanf("%d %d", &rect1.origin_x, &rect1.origin_y);
	// input size (width and height) for rectangle 1
	printf("Input width and height of the first rectangle: ");
	scanf("%d %d", &rect1.width, &rect1.height);
	
	// input origin for rectangle 2
	printf("Input <x y> coordinates for the origin of the first rectangle: ");
	scanf("%d %d", &rect2.origin_x, &rect2.origin_y);
	// input size (width and height) for rectangle 2
	printf("Input width and height of the first rectangle: ");
	scanf("%d %d", &rect2.width, &rect2.height);
	// check if overlapping and write message
	if(overlaps(rect1, rect2))
		printf("The two rectangles are overlapping!\n");
	else {
		printf("The two rectangles are not overlapping!\n");
	}

	/* Problem 2 code (Objective-C) */
	// declare rectangle 1 and rectangle 2 objects

	// input rotation for rectangle 1

	// input rotation for rectangle 2

	// rotate rectangle objects
	
	// check if rectangle objects overlap and write message

	// clean up

	// exit program
	return 0;
}

// This is where you should put your test cases to test that your implementation is correct. 
int test() {
  // EFFECTS: returns 1 if all test cases are successfully passed and 0 otherwise

}

/* 

Question 2(h)
========

<Your answer here>



Question 2(i): Reflection (Bonus Question)
==========================
(a) How many hours did you spend on each problem of this problem set?

I spent a few hours to read up on the basics of Objective-C to get a good grasp of the fundamentals. The smaller parts took
me lesser time, around half an hour to fully understand what each part required and how different parts of the program linked
with each other. 
 
The major part of this code was the method overlapsWithRect. I spent a few hours solely on this part itself. I had to google
about algorithms on overlapping of rotated rectangles and had to digest them. This itself took up bulk of the time 


(b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?

<Your answer here>

(c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?

<Your answer here>

*/
