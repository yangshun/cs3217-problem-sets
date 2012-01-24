/*
 RatTerm is an immutable representation of a term in a single-variable
 polynomial expression. The term has the form C*x^E where C is a rational
 number and E is an integer.
 
 A RatTerm, t, can be notated by the pair (C . E), where C is the coefficient
 of t, and E is the exponent of t.
 
 The zero RatTerm, (0 . 0), is the only RatTerm that may have a zero
 coefficient. For example, (0 . 7) is an invalid RatTerm and an attempt to
 construct such a RatTerm (through the constructor or arithmetic operations on
 existing RatTerms) will return the semantically equivalent RatTerm (0 . 0).
 For example, (1 . 7) + (-1 . 7) = (0 . 0).
 
 (0 . 0), (1 . 0), (1 . 1), (1 . 3), (3/4 . 17), (7/2 . -1), and (NaN . 74)
 are all valid RatTerms, corresponding to the polynomial terms "0", "1", "x",
 "x^3", "3/4*x^17", "7/2*x^-1" and "NaN*x^74", respectively.
*/

#import <Foundation/Foundation.h>
#import "RatNum.h"

@interface RatTerm : NSObject {
	RatNum *coeff;
	int expt;
// Abstraction Function:
// For a given RatTerm t, "coefficient of t" is synonymous with
// t.coeff, and, likewise, "exponent of t" is synonymous with t.expt.
// All RatTerms with a zero coefficient are represented by the
// zero RatTerm, z, which has zero for its coefficient AND exponent.
//
// Representation Invariant:
// coeff != null
// [coeff isEqual:[RatNum initZERO]] ==> expt == 0
}

@property (readonly) RatNum* coeff;
@property (readonly) int expt;

-(id)initWithCoeff:(RatNum*)c Exp:(int)e;
  // REQUIRES: (c, e) is a valid RatTerm
  // EFFECTS: returns a RatTerm with coefficient c and exponent e

+(id)initZERO;
  // EFFECTS: returns a zero RatTerm

+(id)initNaN;
  // EFFECTS: returns a NaN RatTerm

-(BOOL)isNaN;
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is NaN

-(BOOL)isZero;
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is zero

// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d;
  // REQUIRES: self != nil
  // EFFECTS: return the value of this polynomial when evaluated at
  //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
  //            [self isNaN] returns YES, return NaN

-(RatTerm*)negate;
  // REQUIRES: self != nil 
  // EFFECTS: return the negated term, return NaN if the term is NaN


// Addition operation.
-(RatTerm*)add:(RatTerm*)arg;
  // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //            arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg;
  // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //             arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg;
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN

// Division operation
-(RatTerm*)div:(RatTerm*)arg;
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN

// Returns a string representation of this RatTerm.
-(NSString*)stringValue;
  //  REQUIRES: self != nil
  // EFFECTS: return A String representation of the expression represented by this.
  //           There is no whitespace in the returned string.
  //           If the term is itself zero, the returned string will just be "0".
  //           If this.isNaN(), then the returned string will be just "NaN"
  //		    
  //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
  //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
  //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
  //          in which case T takes the form "C" (2) the exponent E is one, in which
  //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
  //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero). 
  //          (4) the coefficient C is -1, in which case T takes the form "-x^E" or "-x"(if
  //          E is 1) or "-1" (if E is zero).
  // 
  //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str;
  // REQUIRES: that self != nil and "str" is an instance of
  //             NSString with no spaces that expresses
  //             RatTerm in the form defined in the stringValue method.
  //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
  // EFFECTS: returns a RatTerm t such that [t stringValue] = str

//  Equality test,
-(BOOL)isEqual:(id)obj;
  // REQUIRES: self != nil
  // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
  //            the same RatTerm as self.

@end
