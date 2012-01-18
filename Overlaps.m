//
//  Overlaps.m
//  
//  CS3217 || Assignment 1
//  Name: Tay Yang Shun
//

#import <Foundation/Foundation.h>
#import "PERectangle.h"

// Import PERectangle here

// define structure Rectangle
struct Rectangle {
	int origin_x, origin_y, width, height;
};

int test(void);

static int overlaps(struct Rectangle rect1, struct Rectangle rect2) {
	// EFFECTS: returns 1 if rectangles overlap and 0 otherwise
	// If the left edge of a particular rectangle is to the right of the right edge of another 
	// rectangle, then there is no way they can overlap. Same logic applies for the top and bottom edges.
	// Four conditions are used to test for overlapping as shown below:
	if(!((rect1.origin_x + rect1.width < rect2.origin_x) ||
			 (rect2.origin_x + rect2.width < rect1.origin_x) ||
			 (rect1.origin_y + rect1.height < rect2.origin_y) ||
			 (rect2.origin_y + rect2.height < rect1.origin_y)))
		return 1;
	else
		return 0;
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
	printf("Input <x y> coordinates for the origin of the second rectangle: ");
	scanf("%d %d", &rect2.origin_x, &rect2.origin_y);
	
	// input size (width and height) for rectangle 2
	printf("Input width and height of the second rectangle: ");
	scanf("%d %d", &rect2.width, &rect2.height);
	
	// check if overlapping and write message
	if(overlaps(rect1, rect2))
		printf("The two rectangles are overlapping!\n");
	else 
		printf("The two rectangles are not overlapping!\n");

	/* Problem 2 code (Objective-C) */
	// declare rectangle 1 and rectangle 2 objects
	PERectangle *peRect1;
	PERectangle *peRect2;
	double rotation1, rotation2;
	
	// input rotation for rectangle 1
	NSLog(@"Input rotation angle for the first rectangle: ");
	scanf("%lf", &rotation1);
    
	// input rotation for rectangle 2
	NSLog(@"Input rotation angle for the second rectangle: ");
	scanf("%lf", &rotation2);
    
	// rotate rectangle objects
	CGPoint origin1 = CGPointMake((CGFloat)(rect1.origin_x),(CGFloat)(rect1.origin_y));
	CGPoint origin2 = CGPointMake((CGFloat)(rect2.origin_x),(CGFloat)(rect2.origin_y));
    
	peRect1 = [[PERectangle alloc] initWithOrigin:origin1 
                                            width:(CGFloat)rect1.width 
                                           height:(CGFloat)rect1.height 
                                         rotation:(CGFloat)0];
    
	peRect2 = [[PERectangle alloc] initWithOrigin:origin2 
                                            width:(CGFloat)rect2.width 
                                           height:(CGFloat)rect2.height 
                                         rotation:(CGFloat)0];
    
	[peRect1 rotate: rotation1];
	[peRect2 rotate: rotation2];
	
	// check if rectangle objects overlap and write message
	if([peRect1 overlapsWithRect: peRect2])
		NSLog(@"The two rectangles are overlapping!\n");
	else 
		NSLog(@"The two rectangles are not overlapping!\n");
	
    
    test();
    
    // clean up
    
	// exit program
	return 0;
}

// This is where you should put your test cases to test that your implementation is correct. 
int test(void) {
  // EFFECTS: returns 1 if all test cases are successfully passed and 0 otherwise
	
	BOOL overlap = NO, overlapAfterRotation = NO, allTestCasesPassed = YES;
	
	// Test Case 1: Rectangles are not overlapping initially, overlap after rotated.
	
	struct Rectangle rect1_1, rect2_1;
	rect1_1.origin_x = 0;
	rect1_1.origin_y = 100;
	rect1_1.width = 100;
	rect1_1.height = 200;
	
	rect2_1.origin_x = 150;
	rect2_1.origin_y = 100;
	rect2_1.width = 100;
	rect2_1.height = 100;
	
	overlap = overlaps(rect1_1, rect2_1);
	
	CGRect tempRect1_1 = CGRectMake(0, 100, 100, 200);
	PERectangle* peRect1_1 = [[PERectangle alloc]initWithRect: tempRect1_1];
	CGRect tempRect2_1 = CGRectMake(150, 100, 100, 100);
	PERectangle* peRect2_1 = [[PERectangle alloc]initWithRect: tempRect2_1];
	
	[peRect1_1 rotate: 90];
	[peRect2_1 rotate: 0];
	
	overlapAfterRotation = [peRect1_1 overlapsWithRect: peRect2_1];
	
	if(overlap == NO && overlapAfterRotation == YES) {
		NSLog(@"Test case 1 passed!\n");
	} else {
		allTestCasesPassed = NO;
		NSLog(@"Test case 1 failed!\n");
	}

    // Test Case 2: Rectangles are not overlapping initially, still not overlapping after rotated.

	struct Rectangle rect1_2, rect2_2;
	rect1_2.origin_x = 0;
	rect1_2.origin_y = 0;
	rect1_2.width = 100;
	rect1_2.height = 100;
	
	rect2_2.origin_x = 400;
	rect2_2.origin_y = 400;
	rect2_2.width = 200;
	rect2_2.height = 200;
	
	overlap = overlaps(rect1_2, rect2_2);
	
	CGRect tempRect1_2 = CGRectMake(0, 0, 100, 100);
	PERectangle* peRect1_2 = [[PERectangle alloc]initWithRect: tempRect1_2];
	CGRect tempRect2_2 = CGRectMake(400, 400, 200, 200);
	PERectangle* peRect2_2 = [[PERectangle alloc]initWithRect: tempRect2_2];
	
	[peRect1_2 rotate: 90];
	[peRect2_2 rotate: 180];
	
	overlapAfterRotation = [peRect1_2 overlapsWithRect: peRect2_2];
	
	if(overlap == NO && overlapAfterRotation == NO) {
		NSLog(@"Test case 2 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 2 failed!\n");
	}
	
    //Test Case 3: Rectangles are overlapping initially, not overlapping after rotated.
    
    struct Rectangle rect1_3, rect2_3;
	rect1_3.origin_x = 0;
	rect1_3.origin_y = 0;
	rect1_3.width = 15;
	rect1_3.height = 10;
	
	rect2_3.origin_x = 14;
	rect2_3.origin_y = 9;
	rect2_3.width = 10;
	rect2_3.height = 15;
	
	overlap = overlaps(rect1_3, rect2_3);
	
	CGRect tempRect1_3 = CGRectMake(0, 0, 15, 10);
	PERectangle* peRect1_3 = [[PERectangle alloc]initWithRect: tempRect1_3];
	CGRect tempRect2_3 = CGRectMake(14, 9, 10, 15);
	PERectangle* peRect2_3 = [[PERectangle alloc]initWithRect: tempRect2_3];
	
	[peRect1_3 rotate: 90];
	[peRect2_3 rotate: 0];
	
	overlapAfterRotation = [peRect1_3 overlapsWithRect: peRect2_3];
	
	if(overlap == YES && overlapAfterRotation == NO) {
		NSLog(@"Test case 3 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 3 failed!\n");
	}
    
    //Test Case 4: Rectangles are overlapping initially, not overlapping after rotated, negative rotation angles used.
    
    struct Rectangle rect1_4, rect2_4;
	rect1_4.origin_x = 0;
	rect1_4.origin_y = 0;
	rect1_4.width = 15;
	rect1_4.height = 10;
	
	rect2_4.origin_x = 14;
	rect2_4.origin_y = 9;
	rect2_4.width = 10;
	rect2_4.height = 15;
	
	overlap = overlaps(rect1_4, rect2_4);
	
	CGRect tempRect1_4 = CGRectMake(0, 0, 15, 10);
	PERectangle* peRect1_4 = [[PERectangle alloc]initWithRect: tempRect1_4];
	CGRect tempRect2_4 = CGRectMake(14, 9, 10, 15);
	PERectangle* peRect2_4 = [[PERectangle alloc]initWithRect: tempRect2_4];
	
	[peRect1_4 rotate: 45];
	[peRect2_4 rotate: -45];
	
	overlapAfterRotation = [peRect1_4 overlapsWithRect: peRect2_4];
	
	if(overlap == YES && overlapAfterRotation == NO) {
		NSLog(@"Test case 4 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 4 failed!\n");
	}
	
    //Test Case 5: First rectangle inside second rectangle. Negative rotation angles tested.
    
    struct Rectangle rect1_5, rect2_5;
	rect1_5.origin_x = 0;
	rect1_5.origin_y = 0;
	rect1_5.width = 1000;
	rect1_5.height = 1000;
	
	rect2_5.origin_x = 400;
	rect2_5.origin_y = 400;
	rect2_5.width = 200;
	rect2_5.height = 200;
	
	overlap = overlaps(rect1_5, rect2_5);
	
	CGRect tempRect1_5 = CGRectMake(0, 0, 1000, 1000);
	PERectangle* peRect1_5 = [[PERectangle alloc]initWithRect: tempRect1_5];
	CGRect tempRect2_5 = CGRectMake(400, 400, 200, 200);
	PERectangle* peRect2_5 = [[PERectangle alloc]initWithRect: tempRect2_5];
	
	[peRect1_5 rotate: -45];
	[peRect2_5 rotate: -45];
	
	overlapAfterRotation = [peRect1_5 overlapsWithRect: peRect2_5];
	
	if(overlap == YES && overlapAfterRotation == YES) {
		NSLog(@"Test case 5 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 5 failed!\n");
	}
    
    //Test Case 6: First rectangle inside second rectangle. Negative coordinates tested.
    
    struct Rectangle rect1_6, rect2_6;
	rect1_6.origin_x = -400;
	rect1_6.origin_y = -400;
	rect1_6.width = 200;
	rect1_6.height = 200;
	
	rect2_6.origin_x = -1000;
	rect2_6.origin_y = -1000;
	rect2_6.width = 1000;
	rect2_6.height = 1000;
	
	overlap = overlaps(rect1_6, rect2_6);
	
	CGRect tempRect1_6 = CGRectMake(-400, -400, 200, 200);
	PERectangle* peRect1_6 = [[PERectangle alloc]initWithRect: tempRect1_6];
	CGRect tempRect2_6 = CGRectMake(-1000, -1000, 1000, 1000);
	PERectangle* peRect2_6 = [[PERectangle alloc]initWithRect: tempRect2_6];
	
	[peRect1_6 rotate: 90];
	[peRect2_6 rotate: 270];
	
	overlapAfterRotation = [peRect1_6 overlapsWithRect: peRect2_6];
	
	if(overlap == YES && overlapAfterRotation == YES) {
		NSLog(@"Test case 6 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 6 failed!\n");
	}
	
    
    //Test Case 7: Second rectangle inside first rectangle. Negative coordinates and rotation angles tested.
    
    struct Rectangle rect1_7, rect2_7;
	rect1_7.origin_x = -1000;
	rect1_7.origin_y = -1000;
	rect1_7.width = 1000;
	rect1_7.height = 1000;
	
	rect2_7.origin_x = -400;
	rect2_7.origin_y = -400;
	rect2_7.width = 200;
	rect2_7.height = 200;
	
	overlap = overlaps(rect1_7, rect2_7);
	
    CGRect tempRect1_7 = CGRectMake(-1000, -1000, 1000, 1000);
	PERectangle* peRect1_7 = [[PERectangle alloc]initWithRect: tempRect1_7];
	CGRect tempRect2_7 = CGRectMake(-400, -400, 200, 200);
	PERectangle* peRect2_7 = [[PERectangle alloc]initWithRect: tempRect2_7];
	
	[peRect1_7 rotate: -90];
	[peRect2_7 rotate: -270];
	
	overlapAfterRotation = [peRect1_7 overlapsWithRect: peRect2_7];
	
	if(overlap == YES && overlapAfterRotation == YES) {
		NSLog(@"Test case 7 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 7 failed!\n");
	}
    
    //Test Case 8: Rectangles not overlapping initially. Angles bigger than 360 deg tested
    
    struct Rectangle rect1_8, rect2_8;
	rect1_8.origin_x = -150;
	rect1_8.origin_y = 100;
	rect1_8.width = 50;
	rect1_8.height = 50;
	
	rect2_8.origin_x = 0;
	rect2_8.origin_y = 0;
	rect2_8.width = 200;
	rect2_8.height = 100;
	
	overlap = overlaps(rect1_8, rect2_8);
	
    CGRect tempRect1_8 = CGRectMake(-150, 100, 50, 50);
	PERectangle* peRect1_8 = [[PERectangle alloc]initWithRect: tempRect1_8];
	CGRect tempRect2_8 = CGRectMake(0, 0, 200, 100);
	PERectangle* peRect2_8 = [[PERectangle alloc]initWithRect: tempRect2_8];
	
	[peRect1_8 rotate: 720];
	[peRect2_8 rotate: 540];
	
	overlapAfterRotation = [peRect1_8 overlapsWithRect: peRect2_8];
	
	if(overlap == NO && overlapAfterRotation == NO) {
		NSLog(@"Test case 8 passed!\n");
	} else {
        allTestCasesPassed = NO;
		NSLog(@"Test case 8 failed!\n");
	}
    
	if(allTestCasesPassed)
        return 1;
    else
        return 0;
}

/* 

Question 2(h)
========

Alternative representation:
 - Store the coordinates of two opposite corners of the rectangle.
 Advantages: The other two corner values can be easily calculated.
 Disadvantages: Can be a hassle to calculate the center point, width and height.



Question 2(i): Reflection (Bonus Question)
==========================
(a) How many hours did you spend on each problem of this problem set?

 I spent a few hours to read up on the basics of Objective-C to get a good grasp of the fundamentals. The smaller parts took
 me lesser time, around half an hour to fully understand what each part required and how different parts of the program linked
 with each other. 
 
 The major part of this code was the method overlapsWithRect. I spent a few hours solely on this part itself. I had to google
 about algorithms on overlapping of rotated rectangles and had to digest them. This itself took up bulk of the time as I had
 to understand it and come up with an implementation for it.

(b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?

 I think I could have looked up more examples of Objective-C code and learnt how they were written so that I wouldn't have a
 problem with the syntax and the usage of the methods and properties.

(c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?

 It could have been made clear that the positive y-axis points southwards to reduce ambiguity.
 They could have gave a rough outline of the approach to the question.
 This problem feels like a mathematics problem rather than a programming one. The toughest part 
 was coming up with the algorithm to check for the overlapping.

*/
