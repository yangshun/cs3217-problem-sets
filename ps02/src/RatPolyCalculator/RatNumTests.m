#import "RatNumTests.h"

#define IntMax 2147483647
#define IntMin -2147483648

@implementation RatNumTests

-(void)setUp{
    zero = [[RatNum alloc] initWithInteger:0];
    one = [[RatNum alloc] initWithInteger:1];
    negOne = [[RatNum alloc] initWithInteger:-1];
    two = [[RatNum alloc] initWithInteger:2];
    three = [[RatNum alloc] initWithInteger:3];
    one_I_two = [[RatNum alloc] initWithNumer:1 Denom:2];
	one_I_three = [[RatNum alloc] initWithNumer:1 Denom:3];
    one_I_four = [[RatNum alloc] initWithNumer:1 Denom:4];
    two_I_three = [[RatNum alloc] initWithNumer:2 Denom:3];
    three_I_four = [[RatNum alloc] initWithNumer:3 Denom:4];
    negOne_I_two = [[RatNum alloc] initWithNumer:-1 Denom:2];
    three_I_two = [[RatNum alloc] initWithNumer:3 Denom:2];
    one_I_zero = [[RatNum alloc] initWithNumer:1 Denom:0];
	negOne_I_zero = [[RatNum alloc] initWithNumer:-1 Denom:0];
    hundred_I_zero = [[RatNum alloc] initWithNumer:100 Denom:0];
    ratNums = [NSArray arrayWithObjects:zero, one, negOne, two,
		one_I_two, negOne_I_two, three_I_two, one_I_zero, negOne_I_zero, hundred_I_zero, nil];
    ratNaNs = [NSArray arrayWithObjects:one_I_zero, negOne_I_zero, hundred_I_zero, nil];
    ratNonNaNs = [NSArray arrayWithObjects:zero, one, negOne, two, one_I_two, three_I_two, nil];	
}

-(void)eq:(RatNum*)ratNum :(NSString*)rep{
	STAssertTrue([rep isEqual:[ratNum stringValue]], @"", @"");
}

-(void)testOneArgConstructor{
	STAssertNoThrow([[RatNum alloc] initWithInteger:0], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithInteger:1], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithInteger:-1], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithInteger:2], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithInteger:3], @"", @"");
}

-(void)testTwoArgConstructor{
	STAssertNoThrow([[RatNum alloc] initWithNumer:1 Denom:2], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:1 Denom:3], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:1 Denom:4], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:2 Denom:3], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:3 Denom:4], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:-1 Denom:2], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:3 Denom:2], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:1 Denom:0], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:-1 Denom:0], @"", @"");
	STAssertNoThrow([[RatNum alloc] initWithNumer:100 Denom:0], @"", @"");
}

-(void)testIsNaN{
	for (int i = 0; i < [ratNaNs count]; i++) {
		STAssertTrue([[ratNaNs objectAtIndex:i] isNaN], @"", @"");
	}
	for (int i = 0; i < [ratNonNaNs count]; i++) {
		STAssertFalse([[ratNonNaNs objectAtIndex:i] isNaN], @"", @"");
	}
}

-(NSString*)strrep:(RatNum*)n{
	return [[[NSNumber numberWithInt:n.numer] stringValue] stringByAppendingFormat:@", %d", (n.denom)];
}

-(void)assertPos:(RatNum*)n{
	STAssertTrue([n isPositive], [self strrep:n], @"1");
	STAssertFalse([n isNegative], [self strrep:n], @"2");
}

-(void)assertNeg:(RatNum*)n{
	STAssertTrue([n isNegative], [self strrep:n], @"3");
	STAssertFalse([n isPositive], [self strrep:n], @"4");
}

-(void)testIsPosAndIsNeg{
	STAssertFalse([zero isPositive], [self strrep:zero], @"5");
	STAssertFalse([zero isNegative], [self strrep:zero], @"6");
	[self assertPos:one];
	[self assertNeg:negOne];
	[self assertPos:two];
	[self assertPos:three];
	[self assertPos:one_I_two];
	[self assertPos:one_I_three];
	[self assertPos:one_I_four];
	[self assertPos:two_I_three];
	[self assertPos:three_I_four];
	[self assertNeg:negOne_I_two];
	[self assertPos:three_I_two];
	[self assertPos:one_I_zero];
	[self assertPos:negOne_I_zero];
	[self assertPos:hundred_I_zero];
}

-(void)approxEq:(double)d1 :(double)d2{
	STAssertTrue(fabs(d1 - d2) < .0000001, @"", @"");
}


-(void)testDoubleValue{
	[self approxEq:[zero doubleValue] :0.0];
	[self approxEq:[one doubleValue] :1.0];
	[self approxEq:[negOne doubleValue] :-1.0];
	[self approxEq:[two doubleValue] :2.0];
	[self approxEq:[one_I_two doubleValue] :0.5];
	[self approxEq:[two_I_three doubleValue] :2. / 3.];
	[self approxEq:[three_I_four doubleValue] :0.75];
	STAssertTrue(isnan([one_I_zero doubleValue]), @"", @"");
	RatNum *one_I_twoToThirty = [[RatNum alloc] initWithNumer:1 Denom:(1 << 30)];
	double quiteSmall = 1. / pow(2, 30);
	[self approxEq:[one_I_twoToThirty doubleValue] :quiteSmall];
}

-(void)testIntValue{
	STAssertTrue([zero intValue] == 0, @"0 should round to 0", @"");
	STAssertTrue([one intValue] == 1, @"1 should round to 1", @"");
	STAssertTrue([negOne intValue] == -1, @"-1 should round to -1", @"");
	STAssertTrue([one_I_two intValue] == 1, @"1/2 should round to 1", @"");
	STAssertTrue([two_I_three intValue] == 1, @"2/3 should round to 1", @"");
	STAssertTrue([three_I_four intValue] == 1, @"3/4 should round to 1", @"");
	STAssertTrue([[one_I_two negate] intValue] == -1, @"-1/2 should round to -1", @"");
	STAssertTrue([[two_I_three negate] intValue] == -1, @"-2/3 should round to -1", @"");
	STAssertTrue([[three_I_four negate] intValue] == -1, @"-3/4 should round to -1", @"");
	RatNum *rnmax = [[RatNum alloc] initWithInteger:IntMax];
	RatNum *rnmin = [[RatNum alloc] initWithInteger:IntMin];
	RatNum *rnmaxd2 = [[RatNum alloc] initWithNumer:IntMax Denom:2];
	RatNum *rnmind2 = [[RatNum alloc] initWithNumer:IntMin Denom:2];
	RatNum *rnmaxmax = [[RatNum alloc] initWithNumer:IntMax Denom:IntMax];
	RatNum *rnminmin = [[RatNum alloc] initWithNumer:IntMin Denom:IntMin];
	RatNum *rn1max = [[RatNum alloc] initWithNumer:1 Denom:IntMax];
	RatNum *rnmax1max = [[RatNum alloc] initWithNumer:IntMax-1 Denom:IntMax];
	STAssertTrue([rnmax intValue] == IntMax, @"MAX_VALUE should round to MAX_VALUE", @"");
	STAssertTrue([rnmin intValue] == IntMin, @"MIN_VALUE should round to MIN_VALUE", @"");
	STAssertTrue([rnmaxd2 intValue] == IntMax/2+1, @"MAX_VALUE/2 should round to (MAX_VALUE/2)+1", @"");
	STAssertTrue([rnmind2 intValue] == IntMin/2, @"MIN_VALUE/2 should round to (MIN_VALUE/2)", @"");
	STAssertTrue([rnmaxmax intValue] == 1, @"MAX_VALUE/MAX_VALUE should round to 1", @"");
	STAssertTrue([rnminmin intValue] == 1, @"MIN_VALUE/MIN_VALUE should round to 1", @"");
	STAssertTrue([rnmax1max intValue] == 1, @"(MAX_VALUE-1)/MAX_VALUE should round to 1", @"");
	STAssertTrue([rn1max intValue] == 0, @"1/MAX_VALUE should round to 0", @"");
}

-(void)testEqualsReflexive{
	for (int i = 0; i < [ratNums count]; i++) {
		RatNum *rn = [ratNums objectAtIndex:i];
		STAssertTrue([rn isEqual:rn], @"", @"");
	}
}

-(void)testEquals{
	STAssertTrue([one isEqual:one], @"", @"");
	STAssertTrue([[one add:one] isEqual:two], @"", @"");
	STAssertTrue([negOne isEqual:negOne], @"", @"");
	RatNum *rn = [[RatNum alloc] initWithNumer:1 Denom:1];
	STAssertTrue([rn isEqual:rn], @"", @"");
	rn = [[RatNum alloc] initWithNumer:1 Denom:2];
	STAssertTrue([rn isEqual:rn], @"", @"");
	rn = [[RatNum alloc] initWithNumer:2 Denom:2];
	STAssertTrue([rn isEqual:rn], @"", @"");
	STAssertTrue([rn isEqual:one], @"", @"");
	rn = [[RatNum alloc] initWithNumer:-9 Denom:9];
	STAssertTrue([rn isEqual:negOne], @"", @"");
	STAssertTrue([negOne isEqual:rn], @"", @"");
	rn = [[RatNum alloc] initWithNumer:-13 Denom:-26];
	STAssertTrue([rn isEqual:one_I_two], @"", @"");
	STAssertTrue([one_I_two isEqual:rn], @"", @"");
	STAssertTrue([one_I_zero isEqual:one_I_zero], @"", @"");
	STAssertTrue([one_I_zero isEqual:negOne_I_zero], @"", @"");
	STAssertTrue([one_I_zero isEqual:hundred_I_zero], @"", @"");
	STAssertFalse([one isEqual:zero], @"", @"");
	STAssertFalse([zero isEqual:one], @"", @"");
	STAssertFalse([one isEqual:two], @"", @"");
	STAssertFalse([two isEqual:one], @"", @"");
	STAssertFalse([one isEqual:negOne], @"", @"");
	STAssertFalse([negOne isEqual:one], @"", @"");
	STAssertFalse([one isEqual:one_I_two], @"", @"");
	STAssertFalse([one_I_two isEqual:one], @"", @"");
	STAssertFalse([one isEqual:three_I_two], @"", @"");
	STAssertFalse([three_I_two isEqual:one], @"", @"");
}


-(void)testToStringSimple{
	RatNum *four = [[RatNum alloc] initWithInteger:4];
	RatNum *negFive = [[RatNum alloc] initWithInteger:-5];
	RatNum *negZero = [[RatNum alloc] initWithInteger:-0];
	
	[self eq:zero : @"0"];
	[self eq:one : @"1"];
	[self eq:four : @"4"];
	[self eq:negOne : @"-1"];
	[self eq:negFive : @"-5"];
	[self eq:negZero : @"0"];
}

-(void)testToStringFractions{
	RatNum *negOne_I_thirteen = [[RatNum alloc] initWithNumer:-1 Denom: 13];
	RatNum *fiftyThree_I_seven = [[RatNum alloc] initWithNumer:53 Denom: 7];
	[self eq:one_I_two : @"1/2"];
	
	[self eq:three_I_two : @"3/2"];
	
	[self eq:negOne_I_thirteen : @"-1/13"];
	
	[self eq:fiftyThree_I_seven : @"53/7"];
}

-(void)testToStringNaN{
	RatNum *two_I_zero = [[RatNum alloc] initWithNumer:2 Denom: 0];
	RatNum *zero_I_zero = [[RatNum alloc] initWithNumer:0 Denom: 0];
	RatNum *negHundred_I_zero = [[RatNum alloc] initWithNumer:-100 Denom: 0];
	RatNum *two_I_one = [[RatNum alloc] initWithNumer:2 Denom: 1];
	RatNum *zero_I_one = [[RatNum alloc] initWithNumer:0 Denom: 1];
	RatNum *negOne_I_negTwo = [[RatNum alloc] initWithNumer:-1 Denom: -2];
	RatNum *two_I_four = [[RatNum alloc] initWithNumer:2 Denom: 4];
	RatNum *six_I_four = [[RatNum alloc] initWithNumer:6 Denom: 4];
	RatNum *twentySeven_I_thirteen = [[RatNum alloc] initWithNumer:27 Denom: 13];
	RatNum *negHundred_I_negHundred = [[RatNum alloc] initWithNumer:-100 Denom: -100];
	
	[self eq:one_I_zero : @"NaN"];
	
	[self eq:two_I_zero : @"NaN"];
	
	[self eq:negOne_I_zero : @"NaN"];
	
	[self eq:zero_I_zero : @"NaN"];
	
	[self eq:negHundred_I_zero : @"NaN"];
	
	[self eq:two_I_one : @"2"];
	
	[self eq:zero_I_one : @"0"];
	
	[self eq:negOne_I_negTwo : @"1/2"];
	
	[self eq:two_I_four : @"1/2"];
	
	[self eq:six_I_four : @"3/2"];
	
	[self eq:twentySeven_I_thirteen : @"27/13"];
	
	[self eq:negHundred_I_negHundred : @"1"];	
}

-(void)decChk:(NSString*)s :(RatNum*)expected{
	STAssertTrue([[RatNum valueOf:s] isEqual:expected], @"", @"");
}

-(void)testValueOf{
	[self decChk:@"0" : zero];
	[self decChk:@"1" : one];
	[self decChk:@"1/1" : one];
	[self decChk:@"2/2" : one];
	[self decChk:@"-1/-1" : one];
	[self decChk:@"-1" : negOne];
	[self decChk:@"1/-1" : negOne];
	[self decChk:@"-3/3" : negOne];
	[self decChk:@"2" : two];
	[self decChk:@"2/1" : two];
	[self decChk:@"-4/-2" : two];
	[self decChk:@"1/2" : one_I_two];
	[self decChk:@"2/4" : one_I_two];
	[self decChk:@"3/2" : three_I_two];
	[self decChk:@"-6/-4" : three_I_two];
	[self decChk:@"NaN" : one_I_zero];
	[self decChk:@"NaN" : negOne_I_zero];	
}

-(void)testNegate{
	[self eq:[zero negate] :@"0"];
	[self eq:[one negate] :@"-1"];
	[self eq:[negOne negate] :@"1"];
	[self eq:[two negate] :@"-2"];
	[self eq:[three negate] :@"-3"];
	[self eq:[one_I_two negate] :@"-1/2"];
	[self eq:[one_I_three negate] :@"-1/3"];
	[self eq:[one_I_four negate] :@"-1/4"];
	[self eq:[two_I_three negate] :@"-2/3"];
	[self eq:[three_I_four negate] :@"-3/4"];
	[self eq:[three_I_two negate] :@"-3/2"];
	[self eq:[one_I_zero negate] :@"NaN"];
	[self eq:[negOne_I_zero negate] :@"NaN"];
	[self eq:[hundred_I_zero negate] :@"NaN"];
}

-(void)testAddSimple{
	[self eq:[zero add:zero] :@"0"];
	[self eq:[zero add:one] :@"1"];
	[self eq:[one add:zero] :@"1"];
	[self eq:[one add:one] :@"2"];
	[self eq:[one add:negOne] :@"0"];
	[self eq:[one add:two] :@"3"];
	[self eq:[two add:two] :@"4"];
}

-(void)testAddComplex{
	[self eq:[one_I_two add:zero] :@"1/2"];
	[self eq:[one_I_two add:one] :@"3/2"];
	[self eq:[one_I_two add:one_I_two] :@"1"];
	[self eq:[one_I_two add:one_I_three] :@"5/6"];
	[self eq:[one_I_two add:negOne] :@"-1/2"];
	[self eq:[one_I_two add:two] :@"5/2"];
	[self eq:[one_I_two add:two_I_three] :@"7/6"];
	[self eq:[one_I_two add:three_I_four] :@"5/4"];
	[self eq:[one_I_three add:zero] :@"1/3"];
	[self eq:[one_I_three add:two_I_three] :@"1"];
	[self eq:[one_I_three add:three_I_four] :@"13/12"];
}

-(void)testAddImproper{
	[self eq:[three_I_two add:one_I_two] :@"2"];
	[self eq:[three_I_two add:one_I_three] :@"11/6"];
	[self eq:[three_I_four add:three_I_four] :@"3/2"];
	[self eq:[three_I_two add:three_I_two] :@"3"];
}

-(void)testAddOnNaN{
	for (int i = 0; i < [ratNums count]; i++) {
		for (int j = 0; j < [ratNaNs count]; j++) {
			RatNum *rni = [ratNums objectAtIndex:i];
			RatNum *rnj = [ratNaNs objectAtIndex:j];
			[self eq:[rni add:rnj] :@"NaN"];
			[self eq:[rnj add:rni] :@"NaN"];
		}
	}
}

-(void)testAddTransitively{
	[self eq:[[one add:one] add:one] :@"3"];
	[self eq:[[zero add:zero] add:zero] :@"0"];
	[self eq:[zero add:[zero add:zero]] :@"0"];
	[self eq:[[one add:two] add:three] :@"6"];
	[self eq:[one add:[two add:three]] :@"6"];
	[self eq:[[one_I_three add:one_I_three] add:one_I_three] :@"1"];
	[self eq:[one_I_three add:[one_I_three add:one_I_three]] :@"1"];
	[self eq:[[one_I_zero add:one_I_zero] add:one_I_zero] :@"NaN"];
	[self eq:[one_I_zero add:[one_I_zero add:one_I_zero]] :@"NaN"];	
	[self eq:[[one_I_two add:one_I_three] add:one_I_four] :@"13/12"];
	[self eq:[one_I_two add:[one_I_three add:one_I_four]] :@"13/12"];	
}

-(void)testSubSimple{
	[self eq:[zero sub:one] :@"-1"];
	[self eq:[zero sub:zero] :@"0"];
	[self eq:[one sub:zero] :@"1"];
	[self eq:[one sub:one] :@"0"];
	[self eq:[two sub:one] :@"1"];
	[self eq:[one sub:negOne] :@"2"];
	[self eq:[one sub:two] :@"-1"];
	[self eq:[one sub:three] :@"-2"];
}

-(void)testSubComplex{
	[self eq:[one sub:one_I_two] :@"1/2"];
	[self eq:[one_I_two sub:one] :@"-1/2"];
	[self eq:[one_I_two sub:zero] :@"1/2"];
	[self eq:[one_I_two sub:two_I_three] :@"-1/6"];
	[self eq:[one_I_two sub:three_I_four] :@"-1/4"];
}

-(void)testSubImproper{
	[self eq:[three_I_two sub:one_I_two] :@"1"];
	[self eq:[three_I_two sub:one_I_three] :@"7/6"];
}

-(void)testSubOnNaN{
	for (int i = 0; i < [ratNums count]; i++) {
		for (int j = 0; j < [ratNaNs count]; j++) {
			RatNum *rni = [ratNums objectAtIndex:i];
			RatNum *rnj = [ratNaNs objectAtIndex:j];
			[self eq:[rni sub:rnj] :@"NaN"];
			[self eq:[rnj sub:rni] :@"NaN"];
		}
	}
}

-(void)testSubTransitively{
	[self eq:[[one sub:one] sub:one] :@"-1"];
	[self eq:[one sub:[one sub:one]] :@"1"];
	[self eq:[[zero sub:zero] sub:zero] :@"0"];
	[self eq:[zero sub:[zero sub:zero]] :@"0"];
	[self eq:[[one sub:two] sub:three] :@"-4"];
	[self eq:[one sub:[two sub:three]] :@"2"];
	[self eq:[[one_I_three sub:one_I_three] sub:one_I_three] :@"-1/3"];
	[self eq:[one_I_three sub:[one_I_three sub:one_I_three]] :@"1/3"];
	[self eq:[[one_I_zero sub:one_I_zero] sub:one_I_zero] :@"NaN"];
	[self eq:[one_I_zero sub:[one_I_zero sub:one_I_zero]] :@"NaN"];	
	[self eq:[[one_I_two sub:one_I_three] sub:one_I_four] :@"-1/12"];
	[self eq:[one_I_two sub:[one_I_three sub:one_I_four]] :@"5/12"];	
}


-(void)testMulProperties{
	RatNum *rn;
	for (int i = 0; i < [ratNonNaNs count]; i++) {
		rn = [ratNonNaNs objectAtIndex:i];
		[self eq:[zero mul:rn] :@"0"];
		[self eq:[rn mul:zero] :@"0"];
		[self eq:[one mul:rn] :[rn stringValue]];
		[self eq:[rn mul:one] :[rn stringValue]];
		[self eq:[negOne mul:rn] :[[rn negate] stringValue]];
		[self eq:[rn mul:negOne] :[[rn negate] stringValue]];
	}
}


-(void)testMulSimple{
	[self eq:[two mul:two] :@"4"];
	[self eq:[two mul:three] :@"6"];
	[self eq:[three mul:two] :@"6"];
	[self eq:[one_I_two mul:two] :@"1"];
	[self eq:[two mul:one_I_two] :@"1"];
	[self eq:[one_I_two mul:one_I_two] :@"1/4"];
	[self eq:[one_I_two mul:one_I_three] :@"1/6"];
	[self eq:[one_I_three mul:one_I_two] :@"1/6"];
	[self eq:[three_I_two mul:one_I_two] :@"3/4"];
	[self eq:[three_I_two mul:one_I_three] :@"1/2"];
	[self eq:[three_I_two mul:three_I_four] :@"9/8"];
	[self eq:[three_I_two mul:three_I_two] :@"9/4"];
}

-(void)testMulOnNaN{
	for (int i = 0; i < [ratNums count]; i++) {
		for (int j = 0; j < [ratNaNs count]; j++) {
			RatNum *rni = [ratNums objectAtIndex:i];
			RatNum *rnj = [ratNaNs objectAtIndex:j];
			[self eq:[rni mul:rnj] :@"NaN"];
			[self eq:[rnj mul:rni] :@"NaN"];
		}
	}
}

-(void)testMulTransitively{
	[self eq:[[one mul:one] mul:one] :@"1"];
	[self eq:[one mul:[one mul:one]] :@"1"];
	[self eq:[[zero mul:zero] mul:zero] :@"0"];
	[self eq:[zero mul:[zero mul:zero]] :@"0"];
	[self eq:[[one mul:two] mul:three] :@"6"];
	[self eq:[one mul:[two mul:three]] :@"6"];
	[self eq:[[one_I_three mul:one_I_three] mul:one_I_three] :@"1/27"];
	[self eq:[one_I_three mul:[one_I_three mul:one_I_three]] :@"1/27"];
	[self eq:[[one_I_zero mul:one_I_zero] mul:one_I_zero] :@"NaN"];
	[self eq:[one_I_zero mul:[one_I_zero mul:one_I_zero]] :@"NaN"];	
	[self eq:[[one_I_two mul:one_I_three] mul:one_I_four] :@"1/24"];
	[self eq:[one_I_two mul:[one_I_three mul:one_I_four]] :@"1/24"];
}

-(void)testDiv {
	[self eq:[zero div:zero] :@"NaN"];
	[self eq:[zero div:one] :@"0"];
	[self eq:[one div:zero] :@"NaN"];
	[self eq:[one div:one] :@"1"];
	[self eq:[one div:negOne] :@"-1"];
	[self eq:[one div:two] :@"1/2"];
	[self eq:[two div:two] :@"1"];
	[self eq:[one_I_two div:zero] :@"NaN"];
	[self eq:[one_I_two div:one] :@"1/2"];
	[self eq:[one_I_two div:one_I_two] :@"1"];
	[self eq:[one_I_two div:one_I_three] :@"3/2"];
	[self eq:[one_I_two div:negOne] :@"-1/2"];
	[self eq:[one_I_two div:two] :@"1/4"];
	[self eq:[one_I_two div:two_I_three] :@"3/4"];
	[self eq:[one_I_two div:three_I_four] :@"2/3"];
	[self eq:[one_I_three div:zero] :@"NaN"];
	[self eq:[one_I_three div:two_I_three] :@"1/2"];
	[self eq:[one_I_three div:three_I_four] :@"4/9"];
	[self eq:[three_I_two div:one_I_two] :@"3"];
	[self eq:[three_I_two div:one_I_three] :@"9/2"];
	[self eq:[three_I_two div:three_I_two] :@"1"];	
}

-(void)testDivOnNaN{
	for (int i = 0; i < [ratNums count]; i++) {
		for (int j = 0; j < [ratNaNs count]; j++) {
			RatNum *rni = [ratNums objectAtIndex:i];
			RatNum *rnj = [ratNaNs objectAtIndex:j];
			[self eq:[rni div:rnj] :@"NaN"];
			[self eq:[rnj div:rni] :@"NaN"];
		}
	}
}

-(void)testDivTransitively{
	[self eq:[[one div:one] div:one] :@"1"];
	[self eq:[one div:[one div:one]] :@"1"];
	[self eq:[[zero div:zero] div:zero] :@"NaN"];
	[self eq:[zero div:[zero div:zero]] :@"NaN"];
	[self eq:[[one div:two] div:three] :@"1/6"];
	[self eq:[one div:[two div:three]] :@"3/2"];
	[self eq:[[one_I_three div:one_I_three] div:one_I_three] :@"3"];
	[self eq:[one_I_three div:[one_I_three div:one_I_three]] :@"1/3"];
	[self eq:[[one_I_zero div:one_I_zero] div:one_I_zero] :@"NaN"];
	[self eq:[one_I_zero div:[one_I_zero div:one_I_zero]] :@"NaN"];	
	[self eq:[[one_I_two div:one_I_three] div:one_I_four] :@"6"];
	[self eq:[one_I_two div:[one_I_three div:one_I_four]] :@"3/8"];
}

-(void)assertGreater:(RatNum*)larger :(RatNum*)smaller {
	STAssertTrue([larger compareTo:smaller] == NSOrderedDescending, @"", @"");
	STAssertTrue([smaller compareTo:larger] == NSOrderedAscending, @"", @"");
}

-(void)testCompare{
	[self assertGreater:one :zero];
	[self assertGreater:one :negOne];
	[self assertGreater:two :one];
	[self assertGreater:two :zero];
	[self assertGreater:zero :negOne];
	[self assertGreater:one :one_I_two];
	[self assertGreater:two :one_I_three];
	[self assertGreater:one :two_I_three];
	[self assertGreater:two :two_I_three];
	[self assertGreater:one_I_two :zero];
	[self assertGreater:one_I_two :negOne];
	[self assertGreater:one_I_two :negOne_I_two];
	[self assertGreater:zero :negOne_I_two];
}

-(void)tearDown{
}

@end
