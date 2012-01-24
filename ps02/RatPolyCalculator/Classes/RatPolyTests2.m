//
//  RatPolyTests.m
//  RatPolyCalculator
//
//  Created by LittleApple on 1/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

/* skeleton unit test implementation */

#import "RatPolyTests.h"


@implementation RatPolyTests


RatNum* num(int i) {
	return [[RatNum alloc] initWithInteger:i];
}

RatNum* num2(int i, int j) {
	return [[RatNum alloc] initWithNumer:i Denom:j];
}

RatTerm* term2(int coeff, int expt) {
	return [[RatTerm alloc] initWithCoeff:num(coeff) Exp:expt];
}

RatTerm* term3(int numer, int denom, int expt) {
	return [[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt];
}

RatPoly* polyTerm(int numer, int denom, int expt) {
    return [[RatPoly alloc] initWithTerm:[[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt]];
}

RatPoly* polyArr(NSArray* polyTerms) {
    return [[RatPoly alloc] initWithTerms: polyTerms];
}


-(void)setUp {
    nanNum = [RatNum initNaN];
    nanTerm = [RatTerm initNaN];
    nanPoly = polyTerm(1, 0, 0);
    zeroPoly = [[RatPoly alloc] init];
}

-(void)tearDown {
}

-(void)testPass {
	STAssertTrue(1==1, @"", @"");
}

// Constructor tests

-(void)testCtorSingleTerm {
    // Integer coeff
	polyTerm(5, 1, 2);
	polyTerm(-2, 1, 3);
    
    // Unreduced coeff
	polyTerm(4, 8, 6);
	polyTerm(-2, 4, 3);
    
    // poly with constants
    polyTerm(1, 1, 0);
    polyTerm(-1, 1, 0);
    polyTerm(-2, 1, 0);
    polyTerm(2, 1, 0);
}

-(void)testCtorZeroCoeff {
	polyTerm(0, 1, 0);
    polyTerm(0, 1, 1);
    polyTerm(0, 1, 2);
}

-(void)testCtorNegExpt {
    STAssertThrows(polyTerm(1, 1, -1), @"Representative Invariant violated with negative expt");
}

-(void)testCtorTermArray {
    //Arrays must comply to invariant rep
    NSArray* a1 = [NSArray arrayWithObjects:term3(2, 2, 2), term3(1, 1, 1), nil];
    NSArray* a2 = [NSArray arrayWithObjects:term2(nanNum, 2), term2(nanNum, 1), nil];
    NSArray* a3 = [NSArray arrayWithObjects:term3(3, 1, 4), term3(1, 2, 0), nil];
    
    polyArr(a1);
    polyArr(a2);
    polyArr(a3);
}

-(void)testCtorNaN {
	polyTerm(0, 0, 0);
}

// Method testing

-(void)testDegree{
    // Test long polynomial
    RatPoly *longPoly = [[RatPoly alloc] initWithTerms:
                            [NSArray arrayWithObjects:
                             term2(-143, 10), 
                             term2(-1705, 9), 
                             term2(1133, 8),
                             term2(748, 7), 
                             term2(-1419, 6), 
                             term2(-550, 5), 
                             term2(1155, 4), 
                             term2(22, 3), 
                             term2(-726, 2), 
                             term2(13, 1), 
                             term2(-6, 0), 
                             nil]];
    
    STAssertTrue([longPoly degree] == 2, @"", @"");
    
    // Test single term polynomial
    STAssertTrue([polyTerm(-3, 4, 5) degree] == 5, @"", @"");
    
    // Test zero polynomial degree
    STAssertTrue([zeroPoly degree] == 0, @"", @"");
}

-(void)testGetTerm{
    // Term exists (test for single term, the first, middle and last term)
	STAssertTrue([[polyTerm(3, 1, 2) getTerm:2] isEqual:term3(3, 1, 2)], @"", @"");
    NSArray* termArray = [NSArray arrayWithObjects:term3(3, 2, 3), term3(2, 2, 2), term3(1, 1, 1), nil];
    STAssertTrue([[polyArr(termArray) getTerm:3] isEqual:term3(3, 2, 3)], @"", @"");
    STAssertTrue([[polyArr(termArray) getTerm:2] isEqual:term3(2, 2, 2)], @"", @"");
    STAssertTrue([[polyArr(termArray) getTerm:1] isEqual:term3(1, 1, 1)], @"", @"");
    
    // Term does not exist
    STAssertTrue(polyTerm(-3, 4, 3) getTerm:4] isEqual:zeroPoly], @"", @"");
    STAssertTrue(polyTerm(-3, 4, 3) getTerm:2] isEqual:zeroPoly], @"", @"");
    STAssertTrue([[polyArr(termArray) getTerm:4] isEqual:zeroPoly], @"", @"");
    STAssertTrue([[polyArr(termArray) getTerm:0] isEqual:zeroPoly], @"", @"");
}

-(void)testIsNaN{
    // Poly is NaN
    STAssertTrue(nanPoly isNaN], @"", @"");
    STAssertTrue([polyTerm(3, 0, 2) isNaN], @"", @"");
    NSArray* termArray = [NSArray arrayWithObjects:term3(3, 2, 3), term3(1, 1, 1), nanTerm, nil];
    STAssertTrue([polyArr(termArray) isNaN], @"", @"");
    
    // Poly is not NaN
    STAssertFalse([polyTerm(3, 3, 2) isNaN], @"", @"");
	termArray = [NSArray arrayWithObjects:term3(3, 2, 3), term2(2, 2, 2), term3(1, 1, 1), nil];
    STAssertFalse([polyArr(termArray) isNaN], @"", @"");
}

-(void)testNegate{
    // Negate single term with pos and negative coeff
    STAssertTrue([[polyTerm(3, 2, 1) negate] isEqual:polyTerm(-3, 2, 1)], @"", @"");
    STAssertTrue([[polyTerm(-3, 2, 1) negate] isEqual:polyTerm(3, 2, 1)], @"", @"");
    
    // Negate polynomials with multiple terms
    NSArray* termArray = [NSArray arrayWithObjects:term3(3, 2, 3), term2(-2, 2, 2), term3(1, 1, 1), nil];
    NSArray* termArrayNegated = [NSArray arrayWithObjects:term3(-3, 2, 3), term2(2, 2, 2), term3(-1, 1, 1), nil];
    STAssertTrue([[polyArr(termArray) negate] isEqual: polyArr(termArrayNegated)], @"", @"");
    
    // Negate NaN
    STAssertTrue([[nanPoly negate] isNaN], @"", @"");
}

-(void)testAdd {
    // test NaN addition
    STAssertTrue([[nanPoly add:nanPoly] isNaN], @"", @"");
    STAssertTrue([[nanPoly add:polyTerm(3, 2, 1)] isNaN], @"", @"");
    STAssertTrue([[polyTerm(3, 2, 1) add:nanPoly] isNaN], @"", @"");
    
    // test addition function with same degrees, overlapping degree and separate degrees
    NSArray* a1 = [NSArray arrayWithObjects:term2(2, 2), term2(1, 1) nil];
    NSArray* a2 = [NSArray arrayWithObjects:term2(4, 2), term2(-1, 1) nil];
    NSArray* a3 = [NSArray arrayWithObjects:term2(2, 3), term2(1, 2) nil];
    NSArray* a4 = [NSArray arrayWithObjects:term2(2, 4), term2(1, 3) nil];
    
    NSArray* sum13 = [NSArray arrayWithObjects:term2(2, 3), term2(3, 2), term2(1, 1) nil];
    NSArray* sum14 = [NSArray arrayWithObjects:term2(2, 4), term2(1, 3), term2(2, 2), term2(1, 1) nil];
    
    STAssertTrue([[polyArr(a1) add:polyArr(a2)] isEqual:polyTerm(6, 1, 2)], @"", @"");
    STAssertTrue([[polyArr(a1) add:polyArr(a3)] isEqual:polyArr(sum13)], @"", @"");
    STAssertTrue([[polyArr(a1) add:polyArr(a4)] isEqual:polyArr(sum14)], @"", @"");
}

-(void)testAddUsingStringValue{
    // test NaN addition
    STAssertEqualObjects(@"NaN", [[nanPoly add:nanPoly] stringValue], @"", @"");
    STAssertEqualObjects(@"NaN", [[nanPoly add:polyTerm(3, 2, 1)] stringValue], @"", @"");
    STAssertEqualObjects(@"NaN", [[polyTerm(3, 2, 1) add:nanPoly] stringValue], @"", @"");
    
    // test addition function with same degrees, overlapping degree and separate degrees
    NSArray* a1 = [NSArray arrayWithObjects:term2(2, 2), term2(1, 1) nil];
    NSArray* a2 = [NSArray arrayWithObjects:term2(4, 2), term2(-1, 1) nil];
    NSArray* a3 = [NSArray arrayWithObjects:term2(2, 3), term2(1, 2) nil];
    NSArray* a4 = [NSArray arrayWithObjects:term2(2, 4), term2(1, 3) nil];
    
    NSString* sum13 = @"2*x^3+3*x^2+x";
    NSArray* sum14 = @"2*x^4+x^3+2*x^2+x";
    
    STAssertEqualObjects(@"6*x^2", [[polyArr(a1) add:polyArr(a2)] stringValue], @"", @"");
    STAssertEqualObjects(sum13, [[polyArr(a1) add:polyArr(a3)] stringValue], @"", @"");
    STAssertEqualObjects(sum14, [[polyArr(a1) add:polyArr(a4)] stringValue], @"", @"");
}

 -(void)testAddUsingValueOf{
     // test NaN addition
     STAssertTrue([[RatPoly valueOf:@"NaN"] add:[RatPoly valueOf:@"NaN"] isNaN], @"", @"");
     STAssertTrue([[RatPoly valueOf:@"NaN"] add:[RatPoly valueOf:@"3/2*x"]] isNaN], @"", @"");
     STAssertTrue([[valueOf:@"3/2*x"] add:[RatPoly valueOf:@"NaN"]] isNaN], @"", @"");
     // test addition function with same degrees, overlapping degree and separate degrees
                  
     RatPoly* p1 = [RatPoly valueOf:@"2*x^2+x"];
     RatPoly* p2 = [RatPoly valueOf:@"4*x^2-x"];
     RatPoly* p3 = [RatPoly valueOf:@"2*x^3+x^2"];
     RatPoly* p4 = [RatPoly valueOf:@"2*x^4+x^3"];
     
     RatPoly* sum12 = [RatPoly valueOf:@"6*x^2"];
     RatPoly* sum13 = [RatPoly valueOf:@"2*x^3+3*x^2+x"];
     RatPoly* sum14 = [RatPoly valueOf:@"2*x^4+x^3+2*x^2+x"];
     
     STAssertTrue([[p1 add:p2] isEqual:sum12], @"", @"");
     STAssertTrue([[p1 add:p3] isEqual:sum13], @"", @"");
     STAssertTrue([[p1 add:p4] isEqual:sum14], @"", @"");
 }

-(void)testEval{
	STAssertEqualsWithAccuracy(0.0, [poly(0, 5, 0) eval:1.2], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(2.0, [poly(2, 1, 0) eval:3.1], 0.0000001, @"", @"");
    STAssertEqualsWithAccuracy(6.0, [poly(3, 2, 2) eval:2.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(12.0, [poly2(terms2(term3(3, 6, 3),term(2, 2))) eval:2.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(4.0, [poly2(terms2(term3(-3, 6, 3),term(2, 2))) eval:2.0], 0.0000001, @"", @"");
    STAssertEqualsWithAccuracy(4.0, [poly2(terms2(term3(3, -6, 3),term(2, 2))) eval:2.0], 0.0000001, @"", @"");
    STAssertEqualsWithAccuracy(-12.0, [poly2(terms2(term3(-3, 6, 3),term(-2, 2))) eval:2.0], 0.0000001, @"", @"");
    STAssertEqualsWithAccuracy(0.0, [poly2(terms2(term3(0, 6, 2),term(0, 3))) eval:9.9], 0.0000001, @"", @"");
}

-(void)testEquals{
	STAssertEqualObjects(poly(3, 5, 2), poly(3, 5, 2), @"", @"");
	STAssertEqualObjects(poly2(terms2(term(3, 5),term(2, 3))), poly2(terms2(term(3, 5),term(2, 3))), @"", @"");
    STAssertEqualObjects(poly2(terms2(term3(3, 6, 5),term(2, 3))), poly2(terms2(term3(3, 6, 5),term(2, 3))), @"", @"");
	STAssertEqualObjects(poly2(terms2(term3(3, 6, 5),term(2, 3))), poly2(terms2(term3(2, 4, 5),term(2, 3))), @"", @"");
	STAssertFalse([poly2(terms2(term3(3, 6, 4),term(2, 3)))isEqual:poly2(terms2(term3(2, 4, 5),term(2, 3)))], @"", @"");
}

-(void)testEqualsZeroPoly{
	STAssertEqualObjects(poly(0, 5, 2), poly(0, 4, 4), @"", @"");
	STAssertEqualObjects(poly2(terms2(term(0, 5),term(0, 3))), poly2(terms2(term(0, 5),term(0, 3))), @"", @"");
    STAssertEqualObjects(poly2(terms2(term3(0, 6, 5),term(0, 3))), poly2(terms2(term3(0, 6, 5),term(0, 3))), @"", @"");
	STAssertEqualObjects(poly2(terms2(term3(0, 6, 5),term(0, 3))), poly2(terms2(term3(0, 4, 5),term(0, 3))), @"", @"");
}

-(void)testEqualsNaNPoly{
	STAssertEqualObjects(nanPoly, poly(19, 0, 0), @"", @"");
	STAssertEqualObjects(nanPoly, poly(0, 0, 0), @"", @"");
	STAssertFalse([nanTerm isEqual:poly(3, 5, 2)], @"", @"");
	STAssertFalse([poly(1, 3, 3) isEqual:nanTerm], @"", @"");
    STAssertFalse([poly2(terms2(term3(0, 6, 5),term(0, 3))) isEqual:nanTerm], @"", @"");
}

-(void)testValueOf:(NSString*)actual :(RatPoly*)target{
	STAssertEqualObjects(target, [RatPoly valueOf:actual], @"", @"");
}

-(void)testValueOfSimple{
	[self testValueOf:@"x" :poly(1, 1, 1)];
	[self testValueOf:@"-x^2" :poly(-1, 1, 2)];
}

-(void)testValueOfConst{
	[self testValueOf:@"2" :poly(2, 1, 0)];
	[self testValueOf:@"3/4" :poly(6, 8, 0)];
	[self testValueOf:@"-4" :poly(-4, 1, 0)];
	[self testValueOf:@"-7/5" :poly(-7, 5, 0)];
}

-(void)testValueOfLeadingCoeff{
    [self testValueOf:@"-2/3*x" :poly(-2, 3, 1)];
	[self testValueOf:@"3/7*x" :poly(3, 7, 1)];
	[self testValueOf:@"-4/3*x" :poly(-4, 3, 1)];
}

-(void)testValueOfPow{	
	[self testValueOf:@"x^3" :poly(1, 1, 3)];
	[self testValueOf:@"-x^4" :poly(-1, 1, 4)];
}

-(void)testValueOfSingleTermPoly{
	[self testValueOf:@"4*x^2" :poly(4, 1, 2)];
	[self testValueOf:@"2/5*x^6" :poly(2, 5, 6)];
	[self testValueOf:@"-3/2*x^2" :poly(-3, 2, 2)];
}

-(void)testValueOfDoubleTermPoly{
	[self testValueOf:@"3*x^5+2*x^3" :poly2(terms2(term(3, 5),term(2, 3)))];
	[self testValueOf:@"3/5*x^6-2/3*x^3" :poly2(terms2(term3(3, 5, 6),term3(-2, 3, 3)))];
	[self testValueOf:@"-3/5*x^4-2/3*x^2" :poly2(terms2(term3(-3, 5, 4),term3(-2, 3, 2)))];
}

-(void)testValueOfNaN{
    [self testValueOf:@"NaN" :poly(-3, 0, 2)];
	[self testValueOf:@"NaN" :poly2(terms2(nanTerm,term(2, 3)))]; 
}

-(void)testValueOfZero{
	[self testValueOf:@"0" :poly(0, -3, 2)];
	[self testValueOf:@"0" :poly2(terms2(term(0, 4),term(0, 3)))]; 
}

-(void)testToString:(NSString*)target :(RatPoly*)actual{
	STAssertEqualObjects(target, [actual stringValue], @"", @"");
}

-(void)testToStringSimple{
	[self testToString:@"x" :poly(1, 1, 1)];
	[self testToString:@"-x" :poly(1, -1, 1)];
}

-(void)testToStringConst{
    [self testToString:@"2" :poly(2, 1, 0)];
	[self testToString:@"3/4" :poly(6, 8, 0)];
	[self testToString:@"-4" :poly(-4, 1, 0)];
	[self testToString:@"-7/5" :poly(-7, 5, 0)];
}

-(void)testToStringLeadingCoeff{
	[self testToString:@"-2/3*x" :poly(-2, 3, 1)];
	[self testToString:@"3/7*x" :poly(3, 7, 1)];
	[self testToString:@"-4/3*x" :poly(-4, 3, 1)];
}

-(void)testToStringPow{
	[self testToString:@"x^3" :poly(1, 1, 3)];
	[self testToString:@"-x^4" :poly(-1, 1, 4)];
}

-(void)testToStringSingleTermPoly{
	[self testToString:@"4*x^2" :poly(4, 1, 2)];
	[self testToString:@"2/5*x^6" :poly(2, 5, 6)];
	[self testToString:@"-3/2*x^2" :poly(-3, 2, 2)];
}

-(void)testToStringDoubleTermPoly{
	[self testToString:@"3*x^5+2*x^3" :poly2(terms2(term(3, 5),term(2, 3)))];
	[self testToString:@"3/5*x^6-2/3*x^3" :poly2(terms2(term3(3, 5, 6),term3(-2, 3, 3)))];
	[self testToString:@"-3/5*x^4-2/3*x^2" :poly2(terms2(term3(-3, 5, 4),term3(-2, 3, 2)))];
}

-(void)testToStringNaN{
	[self testToString:@"NaN" :poly(1, 0, 0)];
    [self testToString:@"NaN" :poly(0, 0, 0)];
    [self testToString:@"NaN" :poly2(terms2(nanTerm,term(2, 3)))]; 
}

-(void)testToStringZero{
    [self testToString:@"0" :poly(0, 1, 0)];
    [self testToString:@"0" :poly(0, -3, 2)];
	[self testToString:@"0" :poly2(terms2(term(0, 4),term(0, 3)))]; 
}


-(void)testSubUsingStringValue{
	STAssertEqualObjects(@"-3/5*x^4+3/5*x^3+2/3*x^2+1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"2/3*x^2-1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"3/5*x^4-4/5*x^3-7/6*x", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"3/5*x^4-4/5*x^3-1/2*x-2/3", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))] stringValue], @"", @"");
    STAssertEqualObjects(@"0", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"-5/2", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 0)))] stringValue], @"", @"");
    STAssertEqualObjects(@"-5/2*x", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"NaN", [[poly2(terms2(nanTerm,term3(-8,4,1))) sub: poly2(terms2(term3(4,5,3),term3(2,4,1)))] stringValue], @"", @"");
}

-(void)testSubUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^4+3/5*x^3+2/3*x^2+1/2*x"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"2/3*x^2-1/2*x"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"3/5*x^4-4/5*x^3-7/6*x"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"3/5*x^4-4/5*x^3-1/2*x-2/3"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"0"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-5/2"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 0)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-5/2*x"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"NaN"], [poly2(terms2(nanTerm,term3(-8, 4, 1))) sub: poly2(terms2(term3(4,5,3),term3(2,4,1)))], @"", @"");
}

-(void)testMulUsingStringValue{
	STAssertEqualObjects(@"9/25*x^7-1/10*x^5-1/3*x^3", [[poly2(terms2(term3(-3, 5, 4), term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))]stringValue], @"", @"");
    STAssertEqualObjects(@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3", [[poly2(terms2(term3(-3, 5, 4), term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))]stringValue], @"", @"");
    STAssertEqualObjects(@"-3/5*x^4+2/3*x^2", [[poly2(terms2(term3(-3, 5, 4), term3(2, 3, 2))) mul: poly(1, 1, 0)]stringValue], @"", @"");
    STAssertEqualObjects(@"-6/5*x^4+4/3*x^2", [[poly2(terms2(term3(-3, 5, 4), term3(2, 3, 2))) mul: poly(2, 1, 0)]stringValue], @"", @"");
    STAssertEqualObjects(@"6", [[poly(3,1,0) mul: poly(2,1,0)]stringValue], @"", @"");
    STAssertEqualObjects(@"0", [[poly2(terms2(term3(-4, 5, 3), term3(-2, 4, 1))) mul: poly(0, 2, 0)] stringValue], @"", @"");
    STAssertEqualObjects(@"NaN", [[poly2(terms2(term3(4, 5, 3), nanTerm)) mul: poly2(terms2(term3(4, 5 ,3),term3(2, 4, 1)))]stringValue], @"", @"");
}

-(void)testMulUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf:@"9/25*x^7-1/10*x^5-1/3*x^3"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^4+2/3*x^2"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly(1, 1, 0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-6/5*x^4+4/3*x^2"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly(2, 1, 0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"6"], [poly(3, 1, 0) mul: poly(2, 1, 0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"0"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) mul: poly(0, 1, 3)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"NaN"], [poly2(terms2(nanTerm,term3(-8, 4, 1))) mul: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))], @"", @"");
}

-(void)testDivUsingStringValue{
	STAssertEqualObjects(@"1/3*x", [[[RatPoly valueOf:@"x^3-2*x+3"] div: poly(3, 1, 2)]stringValue], @"", @"");
    STAssertEqualObjects(@"0", [[[RatPoly valueOf:@"x^2+2*x+15"] div: poly(2, 1, 3)]stringValue], @"", @"");
    STAssertEqualObjects(@"x^2-x+2", [[[RatPoly valueOf:@"x^3+x-1"] div: poly2(terms2(term3(1, 1, 1),term3(1, 1, 0)))]stringValue], @"", @"");
    STAssertEqualObjects(@"-3/5*x^3+1/6*x-1/2", [[[RatPoly valueOf:@"9/25*x^7-1/10*x^5-1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(1, 2, 1)))]stringValue], @"", @"");
    STAssertEqualObjects(@"-3/5*x^4+1/2*x", [[[RatPoly valueOf:@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))]stringValue], @"", @"");
    STAssertEqualObjects(@"3/2*x^2", [[poly(3,1,2) div: poly(2, 1, 0)]stringValue], @"", @"");
    STAssertEqualObjects(@"2", [[poly(4,1,2) div: poly(2, 1, 2)]stringValue], @"", @"");
    STAssertEqualObjects(@"0", [[poly(0, 2, 0) div: poly2(terms2(term3(-4, 5, 3), term3(-2, 4, 1)))] stringValue], @"", @"");
    STAssertEqualObjects(@"NaN", [[poly2(terms2(term3(4, 5, 3), nanTerm)) div: poly2(terms2(term3(4, 5 ,3),term3(2, 4, 1)))]stringValue], @"", @"");
}

-(void)testDivUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf:@"9/25*x^7-1/10*x^5-1/3*x^3"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^4+2/3*x^2"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly(1,1,0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"-6/5*x^4+4/3*x^2"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul: poly(2,1,0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"6"], [poly(3, 1, 0) mul: poly(2, 1, 0)], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"0"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) mul: poly2(terms2(term3(0, 5, 3),term3(0, 4, 1)))], @"", @"");
    STAssertEqualObjects([RatPoly valueOf:@"NaN"], [poly2(terms2(nanTerm,term3(-8,4,1))) mul: poly2(terms2(term3(4,5,3),term3(2,4,1)))], @"", @"");
}

-(void)testOperationsOnNaN{
    STAssertEqualObjects(nanPoly, [nanPoly add:poly(2, 1, 3)], @"", @"");
	STAssertEqualObjects(nanPoly, [poly(2, 1, 3) add:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly sub:poly(2, 1, 3)], @"", @"");
	STAssertEqualObjects(nanPoly, [poly(2, 1, 3) sub:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly mul:poly(2, 1, 3)], @"", @"");
	STAssertEqualObjects(nanPoly, [poly(2, 1, 3) mul:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly div:poly(2, 1, 3)], @"", @"");
	STAssertEqualObjects(nanPoly, [poly(2, 1, 3) div:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly add:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))], @"", @"");
	STAssertEqualObjects(nanPoly, [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) add:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly sub:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))], @"", @"");
	STAssertEqualObjects(nanPoly, [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly mul:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))], @"", @"");
	STAssertEqualObjects(nanPoly, [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) mul:nanPoly], @"", @"");
	STAssertEqualObjects(nanPoly, [nanPoly div:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))], @"", @"");
	STAssertEqualObjects(nanPoly, [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) div:nanPoly], @"", @"");
}

-(void)testOperationsOnZero{
	RatPoly *p = poly(2, 1, 3);
	RatPoly *zero = poly(0, 1, 3);
	STAssertEqualObjects(p, [zero add:p], @"", @"");
	STAssertEqualObjects(p, [p add:zero], @"", @"");
	STAssertEqualObjects(poly(-2, 1, 3), [zero sub:p], @"", @"");
	STAssertEqualObjects(p, [p sub:zero], @"", @"");
	STAssertEqualObjects(zero, [zero mul:p], @"", @"");
	STAssertEqualObjects(zero, [p mul:zero], @"", @"");
	STAssertEqualObjects(zero, [zero div:p], @"", @"");
	STAssertEqualObjects(nanPoly, [p div:zero], @"", @"");
}

@end