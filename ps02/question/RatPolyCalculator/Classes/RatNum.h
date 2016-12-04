/*
 RatNum represents an immutable rational number. It includes
 all of the elements in the set of rationals, as well as the special "NaN"
 (not-a-number) element that results from division by zero.

 The "NaN" element is special in many ways. Any arithmetic operation (such as
 addition) involving "NaN" will return "NaN". With respect to comparison
 operations, such as less-than, "NaN" is considered equal to itself, and
 larger than all other rationals.

 Examples of RatNums include "-1/13", "53/7", "4", "NaN", and "0".

 An immutatable class is simply a class whose instances cannot be
 modified. All of the information contained in each instance is
 provided when it is created and is fixed for the lifetime of the
 object. In objective c, we can make a class immutable by providing
 only readonly accessors. In objective-c, there is no analogue for the
 "final" keyword in java.
*/
#import <Foundation/Foundation.h>

@interface RatNum : NSObject {
	int numer;
	int denom;

	// Abstraction Function:
	// A RatNum r is NaN if r.denom = 0, (r.numer / r.denom) otherwise.
	// (An abstraction function explains what the state of the fields in a
	// RatNum represents. In this case, a rational number can be
	// understood as the result of dividing two integers, or not-a-number
	// if we would be dividing by zero.)
	
	// Representation invariant for every RatNum r:
	// (r.denom >= 0) &&
	// (r.denom > 0 ==> there does not exist integer i > 1 such that
	// r.numer mod i = 0 and r.denom mod i = 0;)
	// In other words,
	// * r.denom is always non-negative.
	// * r.numer/r.denom is in reduced form (assuming r.denom is not zero).
	// (A representation invariant tells us something that is true for all
	// instances of a RatNum)
	
}

//readonly properties only have getters, not setters
@property (readonly) int numer;
@property (readonly) int denom;

-(id)initWithNumer:(int)x Denom:(int)y;
  // EFFECTS: If d = 0, constructs a new RatNum = NaN. Else constructs
  //           a new RatNum = (n / d).

-(id)initWithInteger:(int)x;
  // EFFECTS: Constructs a new RatNum = x. 

+(RatNum*)initNaN;
  // EFFECTS: returns a RatNum holding a Not-a-Number (NaN) value 

+(RatNum*)initZERO;
  // EFFECTS: returns a RatNum holding the value of zero 

-(BOOL)isNaN;
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self is NaN

-(BOOL)isNegative;
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self < 0

-(BOOL)isPositive;
  // REQUIRES: self != nil
  // EFFECTS: returns YES if self > 0

-(NSComparisonResult)compareTo:(RatNum *)otherRatNum;
  // REQUIRES: self != nil, otherRatNum != nil
  // EFFECTS: compare to another RatNum, returns NSOrderedAscending if self < otherRatNum
  //            returns NSOrderedDescending if self > otherRatNum,
  //            otherwise returns NSOrderedSame
  //            Note: NaN is considered to be larger than all other rational numbers

-(double)doubleValue;
  // REQUIRES: self != nil
  // EFFECTS: return a double approximation of this rational number

-(int)intValue;
  // REQUIRES: self != nil
  // EFFECTS: round to the nearest integer

-(NSString*)stringValue;
  // REQUIRES: self != nil
  // EFFECTS: convert the rational number to a string and return it

-(RatNum*)negate;
  // REQUIRES: self != nil
  // EFFECTS: returns a rational number equal to (0-self)

-(RatNum*)add:(RatNum*)arg;
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self and arg. if either is NaN, return NaN

-(RatNum*)sub:(RatNum*)arg;
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self - arg. if either is NaN, return NaN

-(RatNum*)mul:(RatNum*)arg;
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self * arg. if either is NaN, return NaN

-(RatNum*)div:(RatNum*)arg;
  // REQUIRES: arg != nil, self != nil
  // EFFECTS: returns the sum of self * arg. if either is NaN, return NaN

-(BOOL)isEqual:(id)object;
  // REQUIRES: self != nil, object != nil
  // EFFECTS: override NSObject's isEqual method.
  //            returns YES if object represents the same number as self

// Makes a RatNum from a string describing it
+(RatNum*)valueOf:(NSString*)str;
  // REQUIRES: "str" is an instance of a NSString, with no spaces,
  //            of the form: "NaN"
  //                         "N/M", where N and M are both integers in decimal notation and M != 0, or
  //                           "N", where N is an integer in decimal notation.
  // EFFECTS: return a RatNum represented by "str"

@end
