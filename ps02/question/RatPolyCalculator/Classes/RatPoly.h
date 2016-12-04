/*
 RatPoly represents an immutable single-variate polynomial expression.
 RatPolys are sums of RatTerms with non-negative exponents.
 Since RatPoly is immutable, there's no "Modifies" clause in the specification
 Examples of RatPolys include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
*/

#import <Foundation/Foundation.h>
#import "RatTerm.h"

@interface RatPoly : NSObject {
	NSArray *terms;

// Definitions:
// For a RatPoly p, let C(p,i) be
//   [[[p terms] objectAtIndex:i] coeff] and
// E(p,i) be [[[p terms] objectAtIndex:i] expt]
// length(p) be "[[p terms] count]"
// (These are helper functions that will make it easier for us
// to write the remainder of the specifications. They are not
// executable code; they just represent complex expressions in a
// concise manner, so that we can stress the important parts of
// other expressions in the spec rather than get bogged down in
// the details of how we extract the coefficient for the 2nd term
// or the exponent for the 5th term. So when you see C(p,i),
// think "coefficient for the ith term in p".)
//
// Abstraction Function:
// RatPoly, p, represents the polynomial equal to the sum of the
// RatTerms contained in 'terms':
// sum (0 <= i < length(p)): [[p terms] objectAtIndex:i]
// If there are no terms, then the RatPoly represents the zero
// polynomial.
//
// Representation Invariant for every RatPoly p:
// terms != null &&
// forall i such that (0 <= i < length(p)), C(p,i) != 0 &&
// forall i such that (0 <= i < length(p)), E(p,i) >= 0 &&
// forall i such that (0 <= i < length(p) - 1), E(p,i) > E(p, i+1)
// In other words:
// * The terms field always points to some usable object.
// * No term in a RatPoly has a zero coefficient.
// * No term in a RatPoly has a negative exponent.
// * The terms in a RatPoly are sorted in descending exponent order.
// (It is implied that 'terms' does not contain any null elements by the
// above
// invariant.)	
}

@property (readonly) NSArray* terms;
@property (readonly) int degree;

-(id)init;
  //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
  //           remember to call checkRep to check for representation invariant

-(id)initWithTerm:(RatTerm*)rt;
  //  REQUIRES: [rt expt] >= 0
  //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
  //             a zero polynomial remember to call checkRep to check for representation invariant

-(id)initWithTerms:(NSArray*)ts;
  // REQUIRES: "ts" satisfies clauses given in the representation invariant
  // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
  //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant

-(RatTerm*)getTerm:(int)deg;
 // REQUIRES: self != nil && ![self isNaN]
 // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
 //            the zero RatTerm

-(BOOL)isNaN;
 // REQUIRES: self != nil
 //  EFFECTS: returns YES if this RatPoly is NaN
 //             i.e. returns YES if and only if some coefficient = "NaN".

-(RatPoly*)negate;
 // REQUIRES: self != nil 
 // EFFECTS: returns the additive inverse of this RatPoly.
 //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
 //            some r such that [r isNaN]

// Addition operation
-(RatPoly*)add:(RatPoly*)p;
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
  //            some r such that [r isNaN]

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p;
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
  //            some r such that [r isNaN]

// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p;
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
  // some r such that [r isNaN]

// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p;
  // REQUIRES: p != null, self != nil
  // EFFECTS: return a RatPoly, q, such that q = "this / p"; if p = 0 or [self isNaN]
  //           or [p isNaN], returns some q such that [q isNaN]
  //
  // Division of polynomials is defined as follows: Given two polynomials u
  // and v, with v != "0", we can divide u by v to obtain a quotient
  // polynomial q and a remainder polynomial r satisfying the condition u = "q *
  // v + r", where the degree of r is strictly less than the degree of v, the
  // degree of q is no greater than the degree of u, and r and q have no
  // negative exponents.
  // 
  // For the purposes of this class, the operation "u / v" returns q as
  // defined above.
  //
  // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
  // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
  // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
  //
  // Note that this truncating behavior is similar to the behavior of integer
  // division on computers.

-(double)eval:(double)d;
  // REQUIRES: self != nil
  // EFFECTS: returns the value of this RatPoly, evaluated at d
  //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
  //            if [self isNaN], return NaN

// Returns a string representation of this RatPoly.
-(NSString*)stringValue;
  // REQUIRES: self != nil
  // EFFECTS:
  // return A String representation of the expression represented by this,
  // with the terms sorted in order of degree from highest to lowest.
  //
  // There is no whitespace in the returned string.
  //        
  // If the polynomial is itself zero, the returned string will just
  // be "0".
  //         
  // If this.isNaN(), then the returned string will be just "NaN"
  //         
  // The string for a non-zero, non-NaN poly is in the form
  // "(-)T(+|-)T(+|-)...", where "(-)" refers to a possible minus
  // sign, if needed, and "(+|-)" refer to either a plus or minus
  // sign, as needed. For each term, T takes the form "C*x^E" or "C*x"
  // where C > 0, UNLESS: (1) the exponent E is zero, in which case T
  // takes the form "C", or (2) the coefficient C is one, in which
  // case T takes the form "x^E" or "x". In cases were both (1) and
  // (2) apply, (1) is used.
  //        
  // Valid example outputs include "x^17-3/2*x^2+1", "-x+1", "-1/2",
  // and "0".

// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str;
  // REQUIRES : 'str' is an instance of a string with no spaces that
  //              expresses a poly in the form defined in the stringValue method.
  //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
  // EFFECTS : return a RatPoly p such that [p stringValue] = str

// Equality test
-(BOOL)isEqual:(id)obj;
  // REQUIRES: self != nil
  // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
  //            the same rational polynomial as self. All NaN polynomials are considered equal


@end
