#import "RatTermTests.h"


@implementation RatTermTests

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

-(void)setUp{
    nanNum = [num(1) div:num(0)];
    nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];	
}

-(void)tearDown{
}

-(void)testPass{
	STAssertTrue(1==1, @"", @"");
}

-(void)testCtor{
	term(1, 0);
	term(2, 3);
	term3(4, 3, 6);
	term3(-2, 7, 3);
}

-(void)testCtorZeroCoeff{
	term(0, 0);
	term(0, 1);
}

-(void)testCtorNaN{
	term3(3, 0, 0);
}

-(void)testGetCoeff{
	STAssertTrue([term(3, 1).coeff isEqual:num(3)], @"", @"");
	STAssertTrue([term3(2, 5, 2).coeff isEqual:num2(2, 5)], @"", @"");
	STAssertTrue([term(0, 0).coeff isEqual:num(0)], @"", @"");
	STAssertTrue([term3(-2, 3, 2).coeff isEqual:num2(-2, 3)], @"", @"");
	STAssertTrue([term3(3, 0, 4).coeff isEqual:nanNum], @"", @"");
}

-(void)testGetExpt{
	STAssertTrue(term(2, 4).expt == 4, @"", @"");
	STAssertTrue(term(0, 0).expt == 0, @"", @"");
	STAssertTrue(term(0, 1).expt == 0, @"", @"");
}

-(void)testIsNaN{
	STAssertTrue([term3(5, 0, 0) isNaN], @"", @"");
	STAssertTrue([term3(0, 0, 4) isNaN], @"", @"");
	STAssertFalse([term3(2, 3, 2) isNaN], @"", @"");
}

-(void)testIsZero{
	STAssertTrue([term(0, 0) isZero], @"", @"");
	STAssertTrue([term(0, 1) isZero], @"", @"");
	STAssertTrue([term3(0, 4, 3) isZero], @"", @"");
	STAssertTrue([term3(0, -2, 2) isZero], @"", @"");
	STAssertFalse([term3(1, 3, 0) isZero], @"", @"");
	STAssertFalse([term3(0, 0, 4) isZero], @"", @"");
}

-(void)testEval{
	STAssertEqualsWithAccuracy(0.0, [term(0, 0) eval:5.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(0.0, [term(0, 5) eval:1.2], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(2.0, [term(2, 0) eval:3.1], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(1.0, [term(1, 0) eval:100.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(35.0, [term(5, 1) eval:7.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(12.0, [term(3, 2) eval:2.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(-16.0, [term(-2, 3) eval:2.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(-3.0, [term(3, 3) eval:-1.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(1.0, [term(-1, 1) eval:-1.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(2.0, [term3(1, 2, 2) eval:2.0], 0.0000001, @"", @"");
	STAssertEqualsWithAccuracy(.125, [term3(1, 2, 2) eval:.5] , 0.0000001, @"", @"");
}

-(void)testEquals{
	STAssertEqualObjects(term(3, 5), term(3, 5), @"", @"");
	STAssertEqualObjects(term3(1, 2, 4), term3(1, 2, 4), @"", @"");
	STAssertEqualObjects(term3(-2, 4, 2), term3(1, -2, 2), @"", @"");
	STAssertFalse([term(4, 6) isEqual:term(7, 8)], @"", @"");;
}

-(void)testEqualsZeroCoeff{
	STAssertEqualObjects(term(0, 0), term(0, 0), @"", @"");
    STAssertEqualObjects(term(0, 1), term(0, 0), @"", @"");
    STAssertFalse([term(0, 0) isEqual:term(3, 5)], @"", @"");
}

-(void)testEqualsNaNCoeff{
	STAssertEqualObjects(nanTerm, term3(19, 0, 0), @"", @"");
	STAssertEqualObjects(nanTerm, term3(0, 0, 0), @"", @"");
	STAssertFalse([nanTerm isEqual:term(3, 5)], @"", @"");
	STAssertFalse([term(0, 3) isEqual:nanTerm], @"", @"");
}
				   
-(void)testValueOf:(NSString*)actual :(RatTerm*)target{
	STAssertEqualObjects(target, [RatTerm valueOf:actual], @"", @"");
}
				   
-(void)testValueOfSimple{
	[self testValueOf:@"x" :term(1, 1)];
	[self testValueOf:@"-x" :term(-1, 1)];
}

-(void)testValueOfConst{
	[self testValueOf:@"2" :term(2, 0)];
	[self testValueOf:@"3/4" :term3(3, 4, 0)];
	[self testValueOf:@"-4" :term(-4, 0)];
	[self testValueOf:@"-7/5" :term3(-7, 5, 0)];
}

-(void)testValueOfLeadingCoeff{
	[self testValueOf:@"2*x" :term(2, 1)];
	[self testValueOf:@"3/7*x" :term3(3, 7, 1)];
	[self testValueOf:@"-4/3*x" :term3(-4, 3, 1)];
}

-(void)testValueOfPow{	
	[self testValueOf:@"x^3" :term(1, 3)];
	[self testValueOf:@"-x^4" :term(-1, 4)];
}

-(void)testValueOfFull{
	[self testValueOf:@"4*x^2" :term(4, 2)];
	[self testValueOf:@"2/5*x^6" :term3(2, 5, 6)];
	[self testValueOf:@"-3/2*x^2" :term3(-3, 2, 2)];
}

-(void)testValueOfNaN{
	[self testValueOf:@"NaN" :term3(1, 0, 0)];    
}
-(void)testValueOfZero{
	[self testValueOf:@"0" :term(0, 0)];
}
-(void)testToString:(NSString*)target :(RatTerm*)actual{
	STAssertEqualObjects(target, [actual stringValue], @"", @"");
}

-(void)testToStringSimple{
	[self testToString:@"x" :term(1, 1)];
	[self testToString:@"-x" :term(-1, 1)];
}

-(void)testToStringConst{
	[self testToString:@"2" :term(2, 0)];
	[self testToString:@"3/4" :term3(3, 4, 0)];
	[self testToString:@"-4" :term(-4, 0)];
	[self testToString:@"-7/5" :term3(-7, 5, 0)];
}

-(void)testToStringLeadingCoeff{
	[self testToString:@"2*x" :term(2, 1)];
	[self testToString:@"3/7*x" :term3(3, 7, 1)];
	[self testToString:@"-4/3*x" :term3(-4, 3, 1)];
}

-(void)testToStringPow{
	[self testToString:@"x^3" :term(1, 3)];
	[self testToString:@"-x^4" :term(-1, 4)];
}

-(void)testToStringFull{
	[self testToString:@"4*x^2" :term(4, 2)];
	[self testToString:@"2/5*x^6" :term3(2, 5, 6)];
	[self testToString:@"-3/2*x^2" :term3(-3, 2, 2)];
}

-(void) testToStringNaN{
	[self testToString:@"NaN" :term3(1, 0, 0)];
}

-(void)testToStringZero{
	[self testToString:@"0" :term(0, 0)];
}

-(void)testAdd{
	STAssertEqualObjects(term(3, 0), [term(1, 0) add:term(2, 0)], @"", @"");
	STAssertEqualObjects(term(4, 2), [term(3, 2) add:term(1, 2)], @"", @"");
	STAssertEqualObjects(term3(1, 2, 3), [term3(1, 6, 3) add:term3(1, 3, 3)], @"", @"");
	STAssertEqualObjects(term3(1, 8, 1), [term3(1, 4, 1) add:term3(-1, 8, 1)], @"", @"");
	STAssertEqualObjects(term3(-1, 8, 1), [term3(-1, 4, 1) add:term3(1, 8, 1)], @"", @"");
}

-(void)testSub{
	STAssertEqualObjects(term(1, 0), [term(2, 0) sub:term(1, 0)], @"", @"");
	STAssertEqualObjects(term(-1, 0), [term(1, 0) sub:term(2, 0)], @"", @"");
	STAssertEqualObjects(term(2, 2), [term(3, 2) sub:term(1, 2)], @"", @"");
	STAssertEqualObjects(term3(-1, 6, 3), [term3(1, 6, 3) sub:term3(1, 3, 3)], @"", @"");
	STAssertEqualObjects(term3(3, 8, 1), [term3(1, 4, 1) sub:term3(-1, 8, 1)], @"", @"");
	STAssertEqualObjects(term3(-3, 8, 1), [term3(-1, 4, 1) sub:term3(1, 8, 1)], @"", @"");
}

-(void)testMul{
	STAssertEqualObjects(term(2, 0), [term(1, 0) mul:term(2, 0)], @"", @"");
	STAssertEqualObjects(term(3, 4), [term(3, 2) mul:term(1, 2)], @"", @"");
	STAssertEqualObjects(term3(1, 18, 6), [term3(1, 6, 3) mul:term3(1, 3, 3)], @"", @"");
	STAssertEqualObjects(term3(-1, 32, 2), [term3(1, 4, 1) mul:term3(-1, 8, 1)], @"", @"");
	STAssertEqualObjects(term(2, 1), [term(2, 1) mul:term(1, 0)], @"", @"");
}

-(void)testDiv{
	STAssertEqualObjects(term3(1, 2, 0), [term(1, 0) div:term(2, 0)], @"", @"");
	STAssertEqualObjects(term(3, 0), [term(3, 2) div:term(1, 2)], @"", @"");
	STAssertEqualObjects(term3(1, 2, 0), [term3(1, 6, 3) div:term3(1, 3, 3)], @"", @"");
	STAssertEqualObjects(term(-2, 0), [term3(1, 4, 1) div:term3(-1, 8, 1)], @"", @"");
	STAssertEqualObjects(term(2, 1), [term(2, 1) div:term(1, 0)], @"", @"");
	STAssertEqualObjects(term(8, 3), [term(-16, 5) div:term(-2, 2)], @"", @"");
}

-(void)testOperationsOnNaN{
	STAssertEqualObjects(nanTerm, [nanTerm add:term(3, 4)], @"", @"");
	STAssertEqualObjects(nanTerm, [term(3, 4) add:nanTerm], @"", @"");
	STAssertEqualObjects(nanTerm, [nanTerm sub:term(3, 4)], @"", @"");
	STAssertEqualObjects(nanTerm, [term(3, 4) sub:nanTerm], @"", @"");
	STAssertEqualObjects(nanTerm, [nanTerm mul:term(3, 4)], @"", @"");
	STAssertEqualObjects(nanTerm, [term(3, 4) mul:nanTerm], @"", @"");
	STAssertEqualObjects(nanTerm, [nanTerm div:term(3, 4)], @"", @"");
	STAssertEqualObjects(nanTerm, [term(3, 4) div:nanTerm], @"", @"");
}
								
-(void)testOperationsOnZero{
	RatTerm *t = term(-2, 3);
	RatTerm *zero = term(0, 0);
	STAssertEqualObjects(t, [zero add:t], @"", @"");
	STAssertEqualObjects(t, [t add:zero], @"", @"");
	STAssertEqualObjects(term(2, 3), [zero sub:t], @"", @"");
	STAssertEqualObjects(t, [t sub:zero], @"", @"");
	STAssertEqualObjects(zero, [zero mul:t], @"", @"");
	STAssertEqualObjects(zero, [t mul:zero], @"", @"");
	STAssertEqualObjects(zero, [zero div:t], @"", @"");
	STAssertEqualObjects(nanTerm, [t div:zero], @"", @"");
	STAssertEquals(0, [t sub:t].expt, @"", @"");
}

BOOL addDifferentExpts(RatTerm *arg1, RatTerm *arg2) {
	NSLog(@"on it");
	@try {
		[arg1 add:arg2];
		NSLog(@"muahahaha");
		return NO;
	}@catch (id e) {
		return YES;
	}
}

BOOL subDifferentExpts(RatTerm *arg1, RatTerm *arg2) {
	@try {
		[arg1 sub:arg2];
		return NO;
	} @catch (id e) {
		return YES;
	}
}

-(void)testDifferentExptArgs{
	STAssertTrue(addDifferentExpts(term(1, 2), term(1, 4)), @"", @"");
	STAssertTrue(addDifferentExpts(term3(3, 2, 0), term3(7, 3, 1)), @"", @"");
	STAssertTrue(subDifferentExpts(term(1, 2), term(1, 4)), @"", @"");
	STAssertTrue(subDifferentExpts(term3(3, 2, 0), term3(7, 3, 1)), @"", @"");
}

@end
