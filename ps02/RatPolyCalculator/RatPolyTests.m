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

// Declare convenience constructors
RatNum* num(int i) {
  return [[RatNum alloc] initWithInteger:i];
}

RatNum* num2(int i, int j) {
  return [[RatNum alloc] initWithNumer:i Denom:j];
}

RatTerm* term(int coeff, int expt) {
  return [[RatTerm alloc] initWithCoeff:num(coeff) Exp:expt];
}

RatTerm* term3(int numer, int denom, int expt) {
  return [[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt];
}

NSArray* terms2(RatTerm* t1, RatTerm* t2) {
  return [[NSArray alloc]initWithObjects:t1, t2, nil];
}


RatPoly* poly(int numer, int denom, int expt) {
  return [[RatPoly alloc] initWithTerm:[[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt]];
}

RatPoly* poly2(NSArray* polyTerms) {
  return [[RatPoly alloc] initWithTerms: polyTerms];
}

-(void)setUp{
  nanNum = [num(1) div:num(0)];
  nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];	
  nanPoly = poly(1, 0, 3);
}

-(void)tearDown{
}

-(void)testPass{
  STAssertTrue(1==1, @"", @"");
}

// Test various constructors
-(void)testCtor{
  poly(5, 1, 2);
  poly(-2, 1, 3);
  poly(4, 3, 6);
  poly(-2, 7, 3);
}

-(void)testCtorZeroCoeff{
	poly(0, 1, 0);
}

-(void)testCtorNaN{
	poly(0, 0, 0);
}

// Test getTerm method
-(void)testGetTerm{
	STAssertTrue([[poly(3, 1, 2) getTerm:2] isEqual:term3(3, 1, 2)], @"", @"");
	STAssertTrue([[poly(-3, 4, 3) getTerm:3] isEqual:term3(-3, 4, 3)], @"", @"");
  STAssertTrue([[poly(-3, 4, 3) getTerm:1] isEqual:term(0, 1)], @"", @"");
  STAssertTrue([[poly(-3, 4, 3) getTerm:2] isEqual:term(0, 0)], @"", @"");
  STAssertTrue([[poly2(terms2(term(3, 5),term(2, 3)))getTerm:3] isEqual:term(2, 3)], @"", @"");
  STAssertTrue([[poly2(terms2(term(3, 5),term(2, 3)))getTerm:2] isEqual:term(0, 0)], @"", @"");
}

// Test isNaN method
-(void)testIsNaN{
  STAssertTrue([poly(3, 0, 2) isNaN], @"", @"");
  STAssertFalse([poly(3, 3, 2) isNaN], @"", @"");
	STAssertFalse([poly2(terms2(term(3, 5),term(2, 3))) isNaN], @"", @"");
	STAssertTrue([poly2(terms2(term(3, 5),nanTerm)) isNaN], @"", @"");
}

// Test degree method
-(void)testDegree{
  STAssertTrue([poly(3, 1, 2) degree] == 2, @"", @"");
  STAssertTrue([poly(-3, 4, 5) degree] == 5, @"", @"");
  STAssertTrue([poly(-3, 4, 5) degree] == 5, @"", @"");
  STAssertTrue([poly(0, 4, 0) degree] == 0, @"", @"");
  STAssertTrue([poly2(terms2(term3(3, 6, 3),term(2, 2))) degree] == 3, @"", @"");
  STAssertTrue([poly2(terms2(term3(-3, 6, 4),term(-2, 3))) degree] == 4, @"", @"");
}

// Test negate method
-(void)testNegate{
  STAssertTrue([[poly(3, 1, 2) negate] isEqual:poly(-3, 1, 2)], @"", @"");
  STAssertTrue([[poly(-3, 4, 5) negate] isEqual:poly(3, 4, 5)], @"", @"");
  STAssertTrue([[poly(0, 4, 5) negate] isEqual:poly(0, 4, 5)], @"", @"");
  STAssertTrue([[poly(0, 4, 5) negate] isEqual:poly(0, -4, 2)], @"", @"");
  STAssertTrue([[poly2(terms2(term3(3, 6, 3),term(2, 2))) negate] isEqual: poly2(terms2(term3(-3, 6, 3),term(-2, 2)))], @"", @"");
  STAssertTrue([[poly2(terms2(term3(3, 6, 3),term(-2, 2))) negate] isEqual: poly2(terms2(term3(-3, 6, 3),term(2, 2)))], @"", @"");
}

// Test eval method
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

// Test isEquals method
-(void)testEquals{
	STAssertEqualObjects(poly(3, 5, 2), poly(3, 5, 2), @"", @"");
	STAssertEqualObjects(poly2(terms2(term(3, 5),term(2, 3))), poly2(terms2(term(3, 5),term(2, 3))), @"", @"");
  STAssertEqualObjects(poly2(terms2(term3(3, 6, 5),term(2, 3))), poly2(terms2(term3(3, 6, 5),term(2, 3))), @"", @"");
	STAssertEqualObjects(poly2(terms2(term3(3, 6, 5),term(2, 3))), poly2(terms2(term3(2, 4, 5),term(2, 3))), @"", @"");
	STAssertFalse([poly2(terms2(term3(3, 6, 4),term(2, 3)))isEqual:poly2(terms2(term3(2, 4, 5),term(2, 3)))], @"", @"");
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

// Test valueOf methods
-(void)testValueOfSimple{
  [self testValueOf:@"x" :poly(1, 1, 1)];
  [self testValueOf:@"-x^2" :poly(-1, 1, 2)];
}

-(void)testValueOfConst{
  [self testValueOf:@"2" :poly(2, 1, 0)];
  [self testValueOf:@"3/4" :poly(6, 8, 0)];
  [self testValueOf:@"-4"  :poly(-4, 1, 0)];
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

// Test stringValue methods
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

// Test add method using stringValue and valueOf
-(void)testAddUsingStringValue{
	STAssertEqualObjects(@"-3/5*x^4-3/5*x^3+2/3*x^2-1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) add:poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-6/5*x^4+2/3*x^2-1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) add:poly2(terms2(term3(-3, 5, 4),term3(-2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-3/5*x^4-4/5*x^3+1/6*x", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) add:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-3/5*x^4-4/5*x^3-1/2*x+2/3", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) add:poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-3/2", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) add:poly2(terms2(term3(4, 5, 3),term3(2, 4, 0)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-3/2*x", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) add:poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"NaN", [[poly2(terms2(nanTerm,term3(-8, 4, 1))) add: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))] stringValue], @"", @"");
}

-(void)testAddUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf: @"-3/5*x^4-3/5*x^3+2/3*x^2-1/2*x"], [poly2(terms2(term3(-3, 5 ,4),term3(2, 3, 2)))add: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"-6/5*x^4+2/3*x^2-1/2*x"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))add: poly2(terms2(term3(-3, 5, 4),term3(-2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"-3/5*x^4-4/5*x^3+1/6*x"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) add: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"-3/5*x^4-4/5*x^3-1/2*x+2/3"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) add: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"-3/2"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) add: poly2(terms2(term3(4, 5, 3),term3(2, 4, 0)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"-3/2*x"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) add: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf: @"NaN"], [poly2(terms2(nanTerm,term3(-8, 4, 1))) add: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))], @"", @"");
}

// Test sub method using stringValue and valueOf
-(void)testSubUsingStringValue{
	STAssertEqualObjects(@"-3/5*x^4+3/5*x^3+2/3*x^2+1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"2/3*x^2-1/2*x", [[poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"3/5*x^4-4/5*x^3-7/6*x", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"3/5*x^4-4/5*x^3-1/2*x-2/3", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))] stringValue], @"", @"");
  STAssertEqualObjects(@"0", [[poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-5/2", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 0)))] stringValue], @"", @"");
  STAssertEqualObjects(@"-5/2*x", [[poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"NaN", [[poly2(terms2(nanTerm,term3(-8, 4, 1))) sub: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))] stringValue], @"", @"");
}

-(void)testSubUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^4+3/5*x^3+2/3*x^2+1/2*x"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 3),term3(-2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"2/3*x^2-1/2*x"], [poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"3/5*x^4-4/5*x^3-7/6*x"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"3/5*x^4-4/5*x^3-1/2*x-2/3"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 0)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"0"], [poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(-2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"-5/2"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 0))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 0)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"-5/2*x"], [poly2(terms2(term3(-4, 5, 3),term3(-8, 4, 1))) sub: poly2(terms2(term3(-4, 5, 3),term3(2, 4, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"NaN"], [poly2(terms2(nanTerm,term3(-8, 4, 1))) sub: poly2(terms2(term3(4, 5, 3),term3(2, 4, 1)))], @"", @"");
}

// Test mul method using stringValue and valueOf
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

// Test div method using stringValue and valueOf
-(void)testDivUsingStringValue{
	STAssertEqualObjects(@"1/3*x", [[[RatPoly valueOf:@"x^3-2*x+3"] div: poly(3, 1, 2)]stringValue], @"", @"");
  STAssertEqualObjects(@"0", [[[RatPoly valueOf:@"x^2+2*x+15"] div: poly(2, 1, 3)]stringValue], @"", @"");
  STAssertEqualObjects(@"x^2-x+2", [[[RatPoly valueOf:@"x^3+x-1"] div: poly2(terms2(term3(1, 1, 1),term3(1, 1, 0)))]stringValue], @"", @"");
  STAssertEqualObjects(@"-3/5*x^3+1/6*x-1/2", [[[RatPoly valueOf:@"9/25*x^7-1/10*x^5-1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(1, 2, 1)))]stringValue], @"", @"");
  STAssertEqualObjects(@"-3/5*x^4+1/2*x", [[[RatPoly valueOf:@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))]stringValue], @"", @"");
  STAssertEqualObjects(@"3/2*x^2", [[poly(3, 1, 2) div: poly(2, 1, 0)]stringValue], @"", @"");
  STAssertEqualObjects(@"2", [[poly(4, 1, 2) div: poly(2, 1, 2)]stringValue], @"", @"");
  STAssertEqualObjects(@"0", [[poly(0, 2, 0) div: poly2(terms2(term3(-4, 5, 3), term3(-2, 4, 1)))] stringValue], @"", @"");
  STAssertEqualObjects(@"NaN", [[poly2(terms2(term3(4, 5, 3), nanTerm)) div: poly2(terms2(term3(4, 5 ,3),term3(2, 4, 1)))]stringValue], @"", @"");
}

-(void)testDivUsingValueOf{
	STAssertEqualObjects([RatPoly valueOf:@"1/3*x"], [[RatPoly valueOf:@"x^3-2*x+3"] div: poly(3, 1, 2)], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"0"], [[RatPoly valueOf:@"x^2+2*x+15"] div: poly(2, 1, 3)], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"x^2-x+2"], [[RatPoly valueOf:@"x^3+x-1"] div: poly2(terms2(term3(1, 1, 1),term3(1, 1, 0)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^3+1/6*x-1/2"], [[RatPoly valueOf:@"9/25*x^7-1/10*x^5-1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(1, 2, 1)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"-3/5*x^4+1/2*x"], [[RatPoly valueOf:@"9/25*x^8-2/5*x^6-3/10*x^5+1/3*x^3"] div: poly2(terms2(term3(-3, 5, 4),term3(2, 3, 2)))], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"3/2*x^2"], [poly(3, 1, 2) div: poly(2, 1, 0)], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"2"], [poly(4, 1, 2) div: poly(2, 1, 2)], @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"0"], [poly(0, 2, 0) div: poly2(terms2(term3(-4, 5, 3), term3(-2, 4, 1)))] , @"", @"");
  STAssertEqualObjects([RatPoly valueOf:@"NaN"], [poly2(terms2(term3(4, 5, 3), nanTerm)) div: poly2(terms2(term3(4, 5 ,3),term3(2, 4, 1)))], @"", @"");
}

// Test the 4 basic operations on NaN polys
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

// Test the 4 basic operations on zero polys
-(void)testOperationsOnZero{
	RatPoly *p = poly(2, 1, 3);
	RatPoly *zero = poly(0, 1, 0);
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