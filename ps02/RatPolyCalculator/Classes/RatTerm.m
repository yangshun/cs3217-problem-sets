#import "RatTerm.h"

@implementation RatTerm

@synthesize coeff;
@synthesize expt;

// Checks that the representation invariant holds.
-(void)checkRep{ // 5 points
  // You need to fill in the implementation of this method
  if (coeff == nil) {
    [NSException raise:@"ratterm representation error" format:@"coefficient is nil"];
  }
  if ([coeff isEqual:[RatNum initZERO]] && expt != 0) {
    [NSException raise:@"ratterm representation error" format:@"coeff is zero but expt is not"];
  }
}

-(id)initWithCoeff:(RatNum*)c Exp:(int)e {
  // REQUIRES: (c, e) is a valid RatTerm
  // EFFECTS: returns a RatTerm with coefficient c and exponent e
  // TA: should call [self init] and check nil
  // -2pts.
    
  RatNum *ZERO = [RatNum initZERO];
  // if coefficient is 0, exponent must also be 0
  // we'd like to keep the coefficient, so we must retain it
    
  if ([c isEqual:ZERO]) {
    coeff = ZERO;
    expt = 0;
  } else {
    coeff = c;
    expt = e;
  }
  [self checkRep];
  return self;
}

+(id)initZERO { // 5 points
  // EFFECTS: returns a zero ratterm
  return [[RatTerm alloc]initWithCoeff:[RatNum initZERO] Exp:0];
}

+(id)initNaN { // 5 points
  // EFFECTS: returns a nan ratterm
  return [[RatTerm alloc]initWithCoeff:[RatNum initNaN] Exp:0];
}

-(BOOL)isNaN { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is NaN
  return ([coeff isNaN]);
}

-(BOOL)isZero { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is zero
  RatNum *ZERO = [RatNum initZERO];
  return ([coeff isEqual:ZERO]); 
}

// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return the value of this polynomial when evaluated at
  //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
  //            [self isNaN] returns YES, return NaN
  if ([self isNaN]) {
    return NAN;
  } else {
    return ([coeff doubleValue]*pow((double)d, expt));
  }
}

-(RatTerm*)negate { // 5 points
  // REQUIRES: self != nil 
  // EFFECTS: return the negated term, return NaN if the term is NaN
  if ([self isNaN]) {
    return [RatTerm initNaN];
  } else {
    RatTerm* negatedRatTerm = [[RatTerm alloc]initWithCoeff:[[self coeff]negate] 
                                                        Exp:[self expt]];
    return negatedRatTerm;
  }
}

// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //            arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
  RatTerm* new_RatTerm;
  
  // TA: You should use newRatTerm. Don't mix _ (C style) with camelCase. (Java style).
  // It's better to use the camelCase style.
  // -1pt
  if ([self isNaN] || [arg isNaN]) {
    new_RatTerm = [RatTerm initNaN];
  } else if ((self.expt != arg.expt) && ![self isZero] && ![arg isZero]) {
    [NSException raise:@"ratterm addition error" 
                format:@"(self.expt != arg.expt) and neither argument is zero or NaN"];
  } else {
    RatNum* new_coeff = [[self coeff]add:[arg coeff]];
    if (arg.expt == 0) {
      new_RatTerm = [[RatTerm alloc]initWithCoeff:new_coeff Exp:self.expt];
    } else {
      new_RatTerm = [[RatTerm alloc]initWithCoeff:new_coeff Exp:arg.expt];
    }
  }
  
  return new_RatTerm;
}

// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //             arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
  RatTerm* new_RatTerm;
  
  // TA: use [self add:[arg negate]]
  // -2pts.
  if ([self isNaN] || [arg isNaN]) {
    new_RatTerm = [RatTerm initNaN];
  } else if((self.expt != arg.expt) && ![self isZero] && ![arg isZero])
    [NSException raise:@"ratterm subtraction error" 
                format:@"(self.expt != arg.expt) and neither argument is zero or NaN"];
  else {
    RatNum* new_coeff = [[self coeff]sub:[arg coeff]];
    if (arg.expt == 0) {
      new_RatTerm = [[RatTerm alloc]initWithCoeff:new_coeff Exp:self.expt];
    } else {
      new_RatTerm = [[RatTerm alloc]initWithCoeff:new_coeff Exp:arg.expt];
    }
  }
  
  return new_RatTerm;
}

// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN
  if ([self isNaN] || [arg isNaN]) {
    return [RatTerm initNaN];
  } else {
    RatNum* new_coeff = [[self coeff]mul:[arg coeff]];
    int new_expt = [self expt] + [arg expt];
    return [[RatTerm alloc]initWithCoeff:new_coeff Exp:new_expt];
  }
}

// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
  if ([self isNaN] || [arg isNaN]) {
    RatTerm* ratTermNaN = [RatTerm initNaN];
    return ratTermNaN;
  } else {
    RatNum* new_coeff = [[self coeff]div:[arg coeff]];
    int new_expt = [self expt] - [arg expt];
    return [[RatTerm alloc]initWithCoeff:new_coeff Exp:new_expt];
  }
}

// Returns a string representation of this RatTerm.
-(NSString*)stringValue { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return A String representation of the expression represented by this.
  //          There is no whitespace in the returned string.
  //          If the term is itself zero, the returned string will just be "0".
  //          If this.isNaN(), then the returned string will be just "NaN"
  //		    
  //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
  //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
  //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
  //          in which case T takes the form "C" (2) the exponent E is one, in which
  //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
  //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero).
  // 
  //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".
  if ([self isNaN])
    return [NSString stringWithFormat:@"NaN"];
  else if ([self expt] == 0) {
    //There is no term that contains x in the term. ie. rational numbers or integers
    return [[self coeff]stringValue];
  } else if ([self expt] == 1) {
    if ([[[self coeff]stringValue]isEqualToString: @"1"]) {
      //Case whereby term is simply x with a coefficient of 1
      return [NSString stringWithFormat:@"x"];
    } else if ([[[self coeff]stringValue]isEqualToString: @"-1"]) {
      //Case whereby term is simply x with a coefficient of 1
      return [NSString stringWithFormat:@"-x"];
    } else {
      //Case whereby term is degree 1 and coefficient is not 1. Eg: 2*x, 1/2*x
      return [NSString stringWithFormat:@"%@*x", [[self coeff]stringValue]];
    }
  } else {
    if ([[[self coeff]stringValue]isEqualToString: @"1"]) {
      //Case whereby coefficient is 1 and degree is not 1. Eg: x^2, x^3
      return [NSString stringWithFormat:@"x^%d", [self expt]];
    } else if ([[[self coeff]stringValue]isEqualToString: @"-1"]) {
      //Case whereby term is simply x with a coefficient of 1
      return [NSString stringWithFormat:@"-x^%d", [self expt]];
    } else {
      //Case whereby coefficient nor degree are 1. Eg: 1/2*x^2, 3*x^3
      return [NSString stringWithFormat:@"%@*x^%d", [[self coeff]stringValue], [self expt]];
    }
  }
}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
  // REQUIRES: that str != nil and "str" is an instance of
  //             NSString with no spaces that expresses
  //             RatTerm in the form defined in the stringValue method.
  //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
  // EFFECTS: returns a RatTerm t such that [t stringValue] = str
  RatTerm* new_RatTerm;
  
  if ([str isEqual:@"NaN"]) {
    new_RatTerm = [RatTerm initNaN];
  } else {
    NSArray* parts = [str componentsSeparatedByString:@"*"];
    
    if ([parts count] == 1) {
      // TA: Good comments. But you could have indented the cases better.
      //An NSArray of size 1 is returned as there is no "*" in str. Possible cases:
      //(i) Integer. Eg: 1, 2, -3
      //(ii) Rational number. Eg: 1/2, -1/3
      //(iii) Polynomial of coefficient 1 of degree 1. Eg: x
      //(iv) Polynomial of coefficient -1 of degree 1. Eg: -x
      //(v) Polynomial of coefficient 1 of degree >1. Eg: x^2, x^3
      //(vi) Polynomial of coefficient -1 of degree >1. Eg: -x^2, -x^3
      if ([[parts objectAtIndex:0]rangeOfString:@"x"].location == NSNotFound) {
        //case (i) and (ii)
        new_RatTerm = [[RatTerm alloc]initWithCoeff:[RatNum valueOf:str] Exp:0];
      } else {
        if ([[parts objectAtIndex:0]rangeOfString:@"^"].location == NSNotFound) {
          if ([[parts objectAtIndex:0]rangeOfString:@"-"].location == NSNotFound) {
            //case (iii)
            new_RatTerm = [[RatTerm alloc]initWithCoeff:[[RatNum alloc]initWithInteger:1] Exp:1];
          } else {
            //case (iv)
            new_RatTerm = [[RatTerm alloc]initWithCoeff:[[RatNum alloc]initWithInteger:-1] Exp:1];
          }
        } else {
          NSArray* parts2 = [[parts objectAtIndex:0]componentsSeparatedByString:@"^"];
          if ([[parts objectAtIndex:0]rangeOfString:@"-"].location == NSNotFound) {
            //case (v)
            new_RatTerm = [[RatTerm alloc]initWithCoeff:[[RatNum alloc]initWithInteger:1] 
                                                    Exp:[[parts2 objectAtIndex:1] intValue]];
          } else {
            //case (vi)
            new_RatTerm = [[RatTerm alloc]initWithCoeff:[[RatNum alloc]initWithInteger:-1] 
                                                    Exp:[[parts2 objectAtIndex:1] intValue]];
          }
        } 
      }
    } else if ([parts count] == 2) { 
      //An NSArray of size 2 is returned as there is "*" in str. Possible cases:
      //(vii) Polynomial of degree 1 and coefficient !=1. Eg: 2*x, -2/3*x
      //(viii) Polynomial of degree > 1 and coefficient !=1. Eg: 2*x^2, -1/2*x^3
      if ([[parts objectAtIndex:1]rangeOfString:@"^"].location == NSNotFound) {
        //case (vii)
        new_RatTerm = [[RatTerm alloc]initWithCoeff:[RatNum valueOf:[parts objectAtIndex:0]] Exp: 1];
      } else {
        //case (viii)
        NSArray* parts2 = [[parts objectAtIndex:1]componentsSeparatedByString:@"^"];
        new_RatTerm = [[RatTerm alloc]initWithCoeff:[RatNum valueOf:[parts objectAtIndex:0]] 
                                                Exp: [[parts2 objectAtIndex:1]intValue]];
      }
    }
  }
  
  return new_RatTerm;
}

//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
  //            the same RatTerm as self.
  if ([obj isKindOfClass:[RatTerm class]]){
    RatTerm* rt = (RatTerm*)obj;
    if ([self isNaN] && [rt isNaN]) {
      return YES;
    } else {
      return ([[self coeff]isEqual:[rt coeff]] && ([self expt] == [rt expt]));
    }
	} else { 
    return NO;
  }
}

@end
