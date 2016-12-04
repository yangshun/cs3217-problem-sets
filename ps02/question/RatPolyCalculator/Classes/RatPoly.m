#import "RatPoly.h"

@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
  // EFFECTS: returns the degree of this RatPoly object.
  int maxExpt = 0;
  
  if([[self terms]count] == 0) {
    maxExpt = 0;
  } else {
    maxExpt = [[[self terms] objectAtIndex:0]expt];
  }
  
  return maxExpt;
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
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
  if (terms == nil)
    [NSException raise:@"ratpoly representation error" 
                format:@"terms pointing to nil"];
  if ([self isNaN])
    return;
  for(int i = 0; i< [terms count]; i++) {
    RatTerm* curr = [terms objectAtIndex:i];
    // checkRep for RatTerm
    if ([curr coeff] == nil) {
      [NSException raise:@"ratpoly representation error" 
                  format:@"a term has a coefficient that is nil"];
    }
    if ([[curr coeff] isEqual:[RatNum initZERO]]) {
      [NSException raise:@"ratpoly representation error" 
                  format:@"zero term in poly"];
    }
    if ([curr expt] < 0) {
      [NSException raise:@"ratpoly representation error" 
                  format:@"a term has negative exponent"];
    }
    if (i != [terms count] - 1) {
      if ([curr expt] <= [[terms objectAtIndex:(i + 1)] expt]) {
        [NSException raise:@"ratpoly representation error" 
                    format:@"expt is not in decreasing order"];
      }
    }
  }
}

-(void)removeZeroTerms {
  // EFFECTS: removes all the zero terms in the polynomial
  NSMutableArray* newArray = [[NSMutableArray alloc]initWithCapacity:[terms count]];
  
  for (int i = 0; i < [terms count]; i++) {
    if (![[terms objectAtIndex:i]isZero]) {
      [newArray addObject:[terms objectAtIndex:i]];
    }
  }
  
  terms = newArray;
}

-(id)init { // 5 points
  // EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
  //           remember to call checkRep to check for representation invariant
  self = [super init];
  terms = [[NSArray alloc]init];
  [self checkRep];
  return self;
}

-(id)initWithTerm:(RatTerm*)rt { // 5 points
  // REQUIRES: [rt expt] >= 0
  // EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
  //             a zero polynomial remember to call checkRep to check for representation invariant
  self = [super init];
  
  if([rt isZero]) {
    terms = [[NSArray alloc]init];
  } else {
    terms = [[NSArray alloc]initWithObjects:(RatTerm*)rt, nil];
  }
  
  [self checkRep];
  return self;
}

-(id)initWithTerms:(NSArray*)ts { // 5 points
  // REQUIRES: "ts" satisfies clauses given in the representation invariant
  // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
  //            the method does not make a copy of "ts". remember to call checkRep 
  //            to check for representation invariant
  self = [super init];
  terms = ts;
  [self removeZeroTerms];
  [self checkRep];
  return self;
}

-(RatTerm*)getTerm:(int)deg { // 5 points
  // REQUIRES: self != nil && ![self isNaN]
  // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
  //            the zero RatTerm
  for(int i = 0; i<[terms count]; i++) {
    if([[terms objectAtIndex:i]expt] == deg) {
      return [terms objectAtIndex:i];
    }
  }
  
  return [RatTerm initZERO];
}

-(BOOL)isNaN { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if this RatPoly is NaN
  //             i.e. returns YES if and only if some coefficient = "NaN".
  for(int i = 0; i < [terms count]; i++) {
    if([[[terms objectAtIndex:i]coeff]isNaN]) {
      return YES;
    }
  }
  return NO;
}

-(BOOL)isZero {
  if ([terms count] == 0) {
    return YES;
  } else {
    return NO;
  }
}

-(RatPoly*)copyObject { 
  // REQUIRES: self != nil 
  // EFFECTS: returns a copy of self
  return [[RatPoly alloc]initWithTerms:self.terms];
}
    
-(RatPoly*)negate { // 5 points
  // REQUIRES: self != nil 
  // EFFECTS: returns the additive inverse of this RatPoly.
  //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
  //            some r such that [r isNaN]
    
  if ([self isNaN]) {
    return [self copyObject];
  } 
  if ([self isZero]) {
    return [[RatPoly alloc]init];
  }
  NSMutableArray* negatedTerms = [[NSMutableArray alloc]initWithCapacity:[terms count]];
  
  for (int i = 0; i < [terms count]; i++) {
    [negatedTerms addObject:[[terms objectAtIndex:i]negate]];
  }
    
  return [[RatPoly alloc]initWithTerms:negatedTerms];
}

// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or 
  //          [p isNaN], returns some r such that [r isNaN]
    
  if ([self isNaN] || [p isNaN])
    return [[RatPoly alloc]initWithTerm: [RatTerm initNaN]];
  else {
    // Create an empty NSMutableArray to store RatTerm objects
    NSMutableArray* combinedTerms = [[NSMutableArray alloc]initWithCapacity:
                                     [[self terms]count]+[[p terms]count]];
    int selfIter = 0, pIter = 0;
        
    // Repeatedly add RatTerm objects into the array based on exponent value
    while (selfIter != [[self terms]count] && pIter != [[p terms] count]) { 
      if ([[[self terms]objectAtIndex:selfIter]expt] == 
          [[[p terms]objectAtIndex:pIter]expt]) {
        [combinedTerms addObject:[[[self terms]objectAtIndex:selfIter]
                                  add:[[p terms]objectAtIndex:pIter]]];
        selfIter++;
        pIter++;
      } else if ([[[self terms]objectAtIndex:selfIter]expt] > 
                 [[[p terms]objectAtIndex:pIter]expt]) {
        [combinedTerms addObject: [[self terms]objectAtIndex:selfIter]];
        selfIter++;
      } else if ([[[self terms]objectAtIndex:selfIter]expt] < 
                [[[p terms]objectAtIndex:pIter]expt]) {
        [combinedTerms addObject: [[p terms]objectAtIndex:pIter]];
        pIter++;
      }
    }

    // Add any leftover RatTerm objects from either polynomial into the array
    while (selfIter != [[self terms]count]) { 
      [combinedTerms addObject: [[self terms]objectAtIndex:selfIter]];
      selfIter++;
    }
        
    while (pIter != [[p terms]count]) {
      [combinedTerms addObject: [[p terms]objectAtIndex:pIter]];
      pIter++;
    }
        
    return [[RatPoly alloc]initWithTerms:combinedTerms];
  }
}

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
  //            some r such that [r isNaN]
  // Notice that r = self - p is actually r = self + (-p):
  // Negate p to obtain -p.
  // Use polynomial addition algorithm to self and -p to obtain self + (-p)
  if ([self isNaN] || [p isNaN]) {
    return [[RatPoly alloc]initWithTerm: [RatTerm initNaN]];
  } else {
    return [self add:[p negate]];
  }
}

// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
  // some r such that [r isNaN]
  
  // r = self * p:
  // set r = empty
  // foreach term, t_self in self:
  //   set an empty array
  //   foreach term, t_p in p:
  //     add the product of t_p and t_s into the array
  //     add the array to the existing r via polynomial addition
  if ([self isNaN] || [p isNaN])
    return [[RatPoly alloc]initWithTerm: [RatTerm initNaN]];
  else {
    RatPoly* result = [[RatPoly alloc]init];
    
    for (int i = 0; i < [[self terms]count]; i++) {
      NSMutableArray* currTerms = [[NSMutableArray alloc]initWithCapacity:[[p terms]count]];
      for(int j = 0; j < [[p terms]count]; j++) {
        [currTerms addObject:[[[self terms]objectAtIndex:i]mul:[[p terms]objectAtIndex:j]]];
      }
      RatPoly* currPoly = [[RatPoly alloc]initWithTerms:currTerms];
      result = [result add:currPoly];
    }
    return result;
  }
}

// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p{ // 5 points
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
  // For the purposes of this class, the operation "u / v" returns q as
  // defined above.
  //
  // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
  // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
  // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
  //
  // Note that this truncating behavior is similar to the behavior of integer
  // division on computers.
  
  // Let T(p,i) be [p getTerm:i]
  // u = q * v + r:
  // set q = empty and r = empty
  // if degree(u) < degree(v)
  //   q = empty and r = v
  // else {
  //   while(degree(u) >= degree(v))
  //     set RatTerm qTerm to be the quotient of T(q,0) divided by T(v,0)
  //     set s = product of v and qTerm using polynomial multiplication algorithm
  //     add s to existing q
  //     subtract s from existing u using polynomial subtraction algorithm
  //   set r = u
  // }
  RatPoly* divisor = [p copyObject];
  RatPoly* dividend = [self copyObject];
  if ([dividend isNaN] || [divisor isNaN] || [[p terms] count] == 0) {
    return [[RatPoly alloc]initWithTerm: [RatTerm initNaN]];
  } else if ([dividend degree] < [divisor degree]) {
    return [[RatPoly alloc]init];
  } else {
    NSMutableArray* quotientTerms = [[NSMutableArray alloc]initWithCapacity:
                                     [[dividend terms]count]];
    while ([dividend degree] >= [divisor degree] && 
           [[dividend terms]count] != 0 && divisor != nil) {
      RatTerm* quotientTerm = (RatTerm*)[[[dividend terms]objectAtIndex:0] div:
                                  [[divisor terms]objectAtIndex:0]];
      NSLog(@"%@", [quotientTerm stringValue]);
      [quotientTerms addObject:quotientTerm];
      RatPoly* s = [[[RatPoly alloc]initWithTerm: quotientTerm] mul:divisor];
      dividend = [dividend sub:s];
    }
    return [[RatPoly alloc]initWithTerms:quotientTerms];
  }
}

-(double)eval:(double)d { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns the value of this RatPoly, evaluated at d
  //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
  //            if [self isNaN], return NaN
  double sum=0;
  
  if ([self isNaN])
    return NAN;
  else if([[self terms]count] == 0) {
    sum = 0;
  } else {
    for(int i=0; i<[terms count]; i++) {
      sum += [[terms objectAtIndex:i]eval:d];
    }
  }    
  return sum;
}

// Returns a string representation of this RatPoly.
-(NSString*)stringValue { // 5 points
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
    
  NSMutableString* polyString = [[NSMutableString alloc]init];
  
  if ([self isNaN]) {
    [polyString appendFormat:@"NaN"];
  } else if ([[self terms]count] == 0) {
    [polyString appendFormat:@"0"];
  } else if ([self degree] == 0) {
    // Case where RatPoly is 0
    [polyString appendString:[[terms objectAtIndex:0]stringValue]];
  } else {
    // The first term does not need to take into account the positive sign
    [polyString appendString:[[terms objectAtIndex:0]stringValue]];
    // Append the rest of the terms 
    for (int i = 1; i < [terms count]; i++) {
      if ([[[terms objectAtIndex:i]coeff]isPositive]) {
        [polyString appendFormat:@"+%@",[[terms objectAtIndex:i]stringValue]];
      } else {
        [polyString appendString:[[terms objectAtIndex:i]stringValue]];
      }
    }
  }
    
  return polyString;
}

// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
  // REQUIRES : 'str' is an instance of a string with no spaces that
  //              expresses a poly in the form defined in the stringValue method.
  //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
  // EFFECTS : return a RatPoly p such that [p stringValue] = str

  if ([str isEqual:@"NaN"]) {
		return [[RatPoly alloc]initWithTerm:[RatTerm initNaN]];
	} else {

    NSMutableArray* polyStrTerms = [[NSMutableArray alloc]initWithCapacity:[str length]];
              
  if ([str length] > 1) {
    // Stores each term as an NSString object in an NSMutableArray, 
    // using '+' and '-' as delimiters
    int lastIndexOfSign = 0; 
    for (int i = 1; i < [str length]; i++) {
      if([str characterAtIndex:i] == '+') {
        NSRange range = NSMakeRange(lastIndexOfSign, i-lastIndexOfSign);
        [polyStrTerms addObject:[str substringWithRange:range]];
        lastIndexOfSign = i+1;
      } else if ([str characterAtIndex:i] == '-') {
        NSRange range = NSMakeRange(lastIndexOfSign, i-lastIndexOfSign);
        [polyStrTerms addObject:[str substringWithRange:range]];
        lastIndexOfSign = i;
      }
    }
    NSRange range = NSMakeRange(lastIndexOfSign, ([str length]-lastIndexOfSign));
    [polyStrTerms addObject:[str substringWithRange:range]];
  } else {
    // Case whereby str is a one-digit integer
    return [[RatPoly alloc]initWithTerm:[RatTerm valueOf:str]];
  }
      
  NSMutableArray* polyTerms = [[NSMutableArray alloc]initWithCapacity:[polyStrTerms count]];
        
  for (int i = 0; i < [polyStrTerms count]; i++) {
    [polyTerms addObject:[RatTerm valueOf:[polyStrTerms objectAtIndex:i]]];
  }
  return [[RatPoly alloc]initWithTerms:polyTerms];
  }
}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
  //            the same rational polynomial as self. All NaN polynomials are considered equal
  if ([obj isKindOfClass:[RatPoly class]]) {
    RatPoly* rp = (RatPoly*)obj;
    if ([self isNaN] && [rp isNaN]) {
			return YES;
		} else if ([[self terms]count] != [[rp terms]count]) {
      // They cannot be equal if they do not have the same number of terms
      return NO;
    } else {
      // Do a term-by-term comparison between the two RatPoly objects
      for (int i = 0; i < [[self terms]count]; i++) {
        if (![[[self terms]objectAtIndex:i]isEqual:[[rp terms]objectAtIndex:i]]) {
          return NO;
        }
      }
      return YES;
		}
	} else {
    return NO;
  }
}

@end

/* 
 
 Question 1(a)
 ========
 
 Notice that r = p - q is actually r = p + (-q):
 
    foreach term, t_q in q:
      multiply by -1
 
    therefore -q is obtained
 
 then use polynomial addition algorithm to p and -q to obtain p + (-q)
 
 Question 1(b)
 ========
 
 r = p * q:
    set r = empty
    foreach term, t_p in p:
      set a new polynomial s = q
      foreach term, t_s in s:
        replace t_s with the product of t_s and t_p (by multiplying the coefficients and summing up the powers)
      add s to the existing r via polynomial addition
          
 Question 1(c)
 ========
 
 Let T(p,i) be [p getTerm:i]
 
 u = q * v + r:
 set q = empty and r = empty
 if degree(u) < degree(v)
   q = empty and r = v
 else {
   while (degree(u) >= degree(v)) {
    set RatTerm qTerm to be the quotient of T(q,0) and T(v,0)
    set s = multiply v and qTerm using polynomial multiplication algorithm
    add s to existing q
    subtract s from existing u using polynomial subtraction algorithm
    set r = u
   }
 }
 
 Question 2(a)
 ========
 
 Self should not be null as we want a real object that exists. We want to know that an error has occurred if nil is encountered.
 Nothing will happen. A nil value will be returned.
 If NaN is passed to add and sub, the new_denom will be 0, hence the result will still be a Nan and there is no need to check if arg is a Nan.
 However if arg is a NaN in the div method, the initWithNum will take in 0 as an argument and the RatNum that is initialized will have a value of 0. Hence there is a need to check for NaN in the div method.
 
 Question 2(b)
 ========
 
 valueOf turns an existing NSString into a RatNum object, which logically need not be invoked from an instance.
 There is no need for an existing RatNum object to exist before creating a new RatNum object from an NSString, therefore it is a class method.
 An instance method can be used instead, in which the input parameter is an NSString and the instance's numer and denom is modified.
 
 Question 2(c)
 ========
 
 1. initWithNumer:Denom:
    - Less complex in terms of clarity and execution efficiency.
    - Simple assignment of numer and denom to x and y respectively.
 
 2. checkRep
    - Less complex in terms of clarity and execution efficiency.
    - Does not require gcd of numer and denom to be 1.
 
 3. stringValue
    - More complex in terms of clarity and execution efficiency.
    - Have to use gcd to get the fraction in the simplest form
 
 4. isEqual
    - More complex in terms of clarity and execution efficiency.
    - Have to convert both self and arg's numer and denom to simplest form
      before comparison
 
 Question 2(d)
 ========
 
 The numer and denom attributes are readonly, hence they cannot be changed after initialization and each RatNum instance is immutable. New RatNum objects are also created via initialization, which will go through the checkRep process. Hence putting checkRep at the end of initialization is sufficient.
 
 Question 3(a)
 ========
 
 I included calls to checkRep only in the default constructor. Because in all other methods, a new object with the relevant parameters will be created and returned. In other words, in all methods, the default constructor will be called and therefore checkRep will be called.
 
 Question 3(b)
 ========
 
 1. checkRep
    - Less complex in terms of clarity and execution efficiency.
    - Does not require expt to be 0 when coeff = ZERO
 
 2. initWithCoeff:Exp:
    - Less complex in terms of clarity and execution efficiency.
    - Don't have to assign expt as 0 if coeff = ZERO
 
 Question 3(c)
 ========
 
 1. checkRep
    - More complex in terms of clarity and execution efficiency.
    - Have to enforce the new requirement
 
 Question 3(d)
 ========
 
 I prefer to have both sets of representation invariants. Having stricter conditions will reduce the likelihood of errors in the program.
 
 Question 5: Reflection (Bonus Question)
 ==========================
 (a) How many hours did you spend on each problem of this problem set?
 
 5 days:
 Day 1 - RatTerm implementation
 Day 2 - RatTerm debugging
 Day 3 - RatPoly implmentation
 Day 4 - RatPoly debugging
 Day 5 - Creating unit test cases + debugging
 
 In total I think I spent around 20 over hours. I worked on this problem set every single day and I find that debugging takes longer than the coding itself.
 
 
 (b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?
 
 While creating test cases, I copied the expression xˆ3-2*x+3 from ps02.pdf and the output was not what I expected. 
 So I typed x^3-2*x+3 manually and the output was right. I was extremely puzzled by this erratic behaviour of the code and went to check my algorithm many times, spending close to 3 hours on finding out the reason for the different behaviour of the seemingly identical input.
 
 Only after many rounds of debugging did I realise that the ˆ symbol that I copied from the pdf file was different from the ^ character that I checked for in my algorithm (notice that the copied symbol is smaller: ˆ vs ^). This is perhaps the most useful lesson learnt from this problem set, not to copy inputs from sources where the encoding may be different.
 
 I think I could have wrote out all the invariants on a piece of paper and made sure my code followed the invariants strictly rather than spending time debugging then finding out that one particular case failed because I did not realise that the invariant was in place.
 
 
 (c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
 This problem set is extremely well set. I'm glad that the ambiguity is reduced as compared to problem set 1. It was a good thing to provide us with the implementation of RatNum, which kickstart-ed us in doing RatTerm followed by RatPoly. From this problem set, I see for myself how code is built up from small classes to bigger ones which consist of many smaller classes.
 
 All in all, I enjoyed this problem set. It is challenging and very rewarding.
 
 */
