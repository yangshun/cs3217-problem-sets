#import "RatNum.h"


@implementation RatNum

//synthesize the readonly accessors of the two properties
@synthesize numer;
@synthesize denom;

/*
 Returns the gcd of x and y
 Note that "+" declares a class method that is analogous to C++ and
 java's static method. By declaring it within the implementation file,
 we make it only accessible to methods in this file, since it cannot be 
 found in the header .h file. 
*/
+(int)gcd:(int)x :(int)y{
  // REQUIRES: y != 0
  // EFFECTS: returns d such that a % d = 0 and b % d = 0

  x = abs(x);
  y = abs(y);
  if (y == 0) return 0;
  while (y != 0) {
    int tmp = y;
    y = x % y;
    x = tmp;
  }
  return x;
}

+(RatNum*)initNaN{
  // EFFECTS: returns a RatNum holding a Not-a-Number (NaN) value 
  return [[RatNum alloc] initWithNumer:1 Denom:0];
}

+(RatNum*)initZERO{
  // EFFECTS: returns a RatNum holding the value of zero 
  return [[RatNum alloc] initWithInteger:0];
}

// Checks that the representation invariant holds.
-(void)checkRep{

	if (denom < 0){
		[NSException raise:@"RatNum rep error" format:
		 @"Denominator of a RatNum cannot be less than zero"];
	}
	
	if (denom > 0) {
		int thisGcd = [RatNum gcd:self.numer :self.denom];
		if (thisGcd != 1 && thisGcd != -1) {
			[NSException raise:@"RatNum rep error" format:
			 @"RatNum not in lowest form"];
		}
	}
}

-(id)initWithNumer:(int)x Denom:(int)y{
  // EFFECTS: If d = 0, constructs a new RatNum = NaN. Else constructs
  //           a new RatNum = (n / d).

  if (y==0) {
    numer = x;
    denom = 0;
  } else {
    int g = [RatNum gcd:x :y];
    x = x / g;
    y = y / g;
    
    if (y < 0) {
      numer = -x;
      denom = -y;
    } else {
      numer = x;
      denom = y;
    }
    
  }
  [self checkRep];
  return self;
}

-(id)initWithInteger:(int)x{
  // EFFECTS: Constructs a new RatNum = x. 

  numer = x;
  denom = 1;
  [self checkRep];
  return self;
}

-(BOOL)isNaN{
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self is NaN

  return (denom == 0);
}

-(BOOL)isNegative{
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self < 0

  RatNum *ZERO = [RatNum initZERO];
  return ([self compareTo:ZERO] == NSOrderedAscending);
}

-(BOOL)isPositive{
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self > 0

  RatNum *ZERO = [RatNum initZERO];
  return ([self compareTo:ZERO] == NSOrderedDescending);
}

-(NSComparisonResult)compareTo:(RatNum *)otherRatNum{
  // REQUIRES: self != nil, otherRatNum != nil
  // EFFECTS: compare to another RatNum, returns NSOrderedAscending if self < otherRatNum
  //            returns NSOrderedDescending if self > otherRatNum,
  //            otherwise returns NSOrderedSame
  //            Note: NaN is considered to be larger than all other rational numbers
 
  if ([self isNaN] && [otherRatNum isNaN]) {
    return NSOrderedSame;
  } else if ([self isNaN]) {
    return NSOrderedDescending;
  } else if ([otherRatNum isNaN]) {
    return NSOrderedAscending;
  }
  long a = self.numer * otherRatNum.denom;
  long b = otherRatNum.numer * self.denom;
  if(a < b) return NSOrderedAscending;
  else if(a > b) return NSOrderedDescending;
  else return NSOrderedSame;
}

-(double)doubleValue{
  // REQUIRES: self != nil
  // EFFECTS: return a double approximation of this rational number

  if([self isNaN]) return NAN;
  else {
    return ((double)self.numer) / ((double)self.denom);
  }
}

-(int)intValue{
  // REQUIRES: self != nil
  // EFFECTS: round to the nearest integer

  if (self.numer >= 0) {
    return (int)(((long long)self.numer + (self.denom/2)) / self.denom);
  } else {
    return (int)(((long long)self.numer - (self.denom/2)) / self.denom); 
  }
}

-(NSString*)stringValue{
  // REQUIRES: self != nil
  // EFFECTS: convert the rational number to a string and return it

  if ([self isNaN]) {
    return @"NaN";
  } else if (self.denom != 1) {
    return [NSString stringWithFormat:@"%d/%d", self.numer, self.denom];
  } else return [NSString stringWithFormat:@"%d", self.numer];
}

-(RatNum*)negate{
  // REQUIRES: self != nil
  // EFFECTS: returns a rational number equal to (0-self)

  return [[RatNum alloc] initWithNumer:-self.numer Denom:self.denom];
}

-(RatNum*)add:(RatNum*)arg{
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self and arg. if either is NaN, return NaN

  int new_numer = self.numer * arg.denom + arg.numer * self.denom;
  int new_denom = self.denom * arg.denom;
  return [[RatNum alloc] initWithNumer:new_numer Denom:new_denom];
}

-(RatNum*)sub:(RatNum*)arg{
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self - arg. if either is NaN, return NaN

  return [self add:[arg negate]];
}

-(RatNum*)mul:(RatNum*)arg{
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self * arg. if either is NaN, return NaN

  return [[RatNum alloc] initWithNumer: self.numer*arg.numer Denom:self.denom*arg.denom];
}

-(RatNum*)div:(RatNum*)arg{
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self / arg. if either is NaN, return NaN

  if ([arg isNaN]) {
    return arg;
  } else {
    return [[RatNum alloc] initWithNumer:self.numer*arg.denom Denom:self.denom*arg.numer];
  }
}

-(BOOL)isEqual:(id)object{
  // REQUIRES: self != nil, object != nil
  // EFFECTS: override NSObject's isEqual method.
  //            returns YES if object represents the same number as self

	if([object isKindOfClass:[RatNum class]]){
	//isKindOfClass returns true if object can be considered as an
	//instance of the argument class. Each class has a method
	//called "class", which returns the class object. so [RatNum
	//class] returns the class object of RatNum class

		RatNum *rn = (RatNum*)object;
		if ([self isNaN] && [rn isNaN]) {
			return YES;
		} else {
			return self.numer == rn.numer && self.denom == rn.denom;
		}

	} else return NO;
}

// Makes a RatNum from a string describing it
+(RatNum*)valueOf:(NSString*)str{
  // REQUIRES: "str" is an instance of a NSString, with no spaces,
  //            of the form: "NaN"
  //                         "N/M", where N and M are both integers in decimal notation and M != 0, or
  //                           "N", where N is an integer in decimal notation.
  // EFFECTS: return a RatNum represented by "str"

	if ([str isEqual:@"NaN"]) {
		return [RatNum initNaN];
	} else {
		NSArray *tokens = [str componentsSeparatedByString:@"/"];
		//if there is only one token, then it must be an integer
		if ([tokens count] == 1) {
			int arg = [str intValue];
			//as a good habit, any function that is not "alloc", and returns
			//a newly allocated object, should autorelease it.
			return [[RatNum alloc] initWithInteger:arg];
		} else {
			int x = [[tokens objectAtIndex:0] intValue];
			int y = [[tokens objectAtIndex:1] intValue];
			return [[RatNum alloc] initWithNumer:x Denom:y];
		}
	}

}

@end
