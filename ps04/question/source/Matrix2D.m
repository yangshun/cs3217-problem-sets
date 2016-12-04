//
//
//  NUS CS3217 2012 
//  Problem Set 4
//  The Physics Engine
//
//

#import "Matrix2D.h"

@implementation Matrix2D
// OVERVIEW: This class implements an immutable 2x2 matrix
//	       and supports a number of matrix operations

@synthesize col1;
@synthesize col2;

// Constructor for initalizing Vector2D
-(Matrix2D*)initWithVectors:(Vector2D*)c1:(Vector2D*)c2 {
  // EFFECTS: initializes a Matrix with 2 2D Vectors
  if(self = [super init]){
    col1 = [c1 retain];
    col2 = [c2 retain];
  }
  return self;
}

// Static Method for creating a Matrix with 2 Vector2Ds.
+(Matrix2D*)matrixWithVector:(Vector2D*)v1 andVector:(Vector2D*)v2 {
  // EFFECTS: Returns an autoreleased 2x2 Matrix
  return [[[Matrix2D alloc] initWithVectors:v1 :v2] autorelease];
}

// Static Method for creating a Matrix with 4 values.
+(Matrix2D*)matrixWithValues:(double)c1r1 and:(double)c1r2 and:(double)c2r1 and:(double)c2r2 {
  // EFFECTS: Returns an autoreleased 2x2 Matrix
  Vector2D *c1 = [Vector2D vectorWith:c1r1 y:c1r2];
  Vector2D *c2 = [Vector2D vectorWith:c2r1 y:c2r2];
  return [Matrix2D matrixWithVector:c1 andVector:c2];
}

// Static Method for creating a rotational Matrix with an angle
+(Matrix2D*)initRotationMatrix:(double)angle {
  // EFFECTS: Returns an autoreleased 2x2 Matrix
  return [Matrix2D matrixWithValues:cos(angle) and:sin(angle) and:-sin(angle) and:cos(angle)];
}

// Calculates transposition of this matrix
// EFFECTS: Returns an autoreleased 2x2 Matrix transposition
-(Matrix2D*)transpose {
  // EFFECTS: Returns a new matrix that is a transpose of self.
  return [Matrix2D matrixWithValues:col1.x and:col2.x and:col1.y and:col2.y];
}

// Calculates Inverse the matrix and
-(Matrix2D*)inverse {
  // EFFECTS: Returns a new matrix that is the inverse of self.
  double a = col1.x, b = col2.x, c = col1.y, d = col2.y;
  double det = a * d - b * c;
  if (det == 0.0f) {
    NSException *excp = [[NSException alloc] initWithName:@"ZeroDeterminant" reason:nil userInfo:nil];
    [excp autorelease];
    @throw excp;
  }
  det = 1.0f / det;
  double c1r1 = det * d;
  double c2r1 = - det * b;
  double c1r2 = - det * c;
  double c2r2 = det * a;
  return [Matrix2D matrixWithValues:c1r1 and:c1r2 and:c2r1 and:c2r2];
}

// Multiplies this matrix with another vector
-(Vector2D*)multiplyVector:(Vector2D*)v {
  // REQUIRES: v != nil 
  // EFFECTS: Returns a matrix that that is the result of multiplying self by v.
  double a = col1.x * v.x + col2.x * v.y;
  double b = col1.y * v.x + col2.y * v.y;
  return [Vector2D vectorWith:a y:b];
}

// Calculates the sum of this matrix with another 2x2 Matrix
-(Matrix2D*)add:(Matrix2D*)m {
  // REQUIRES: m != nil 
  // EFFECTS: Returns a new matrix that is the matrix sum of self and m.
  Vector2D *v1 = [col1 add:m.col1];
  Vector2D *v2 = [col2 add:m.col2];
  return [Matrix2D matrixWithVector:v1 andVector:v2];
}

// Perform Matric Multiplication with another 2x2 Matrix
-(Matrix2D*)multiply:(Matrix2D*)m {
  // REQUIRES: m != nil 
  // EFFECTS: Returns a new matrix that is the matrix product of self and m.
  Vector2D *v1 = [self multiplyVector:m.col1];
  Vector2D *v2 = [self multiplyVector:m.col2];
  return [Matrix2D matrixWithVector:v1 andVector:v2];
}

// Performs a Scalar multiplication
-(Matrix2D*)multiplyScalar:(double)s {
  // EFFECTS: Returns a new matrix that is the scalar multiple of self.
  return [Matrix2D matrixWithVector:[col1 multiply:s] andVector:[col2 multiply:s]];
}


// Calculate the absolute of the Matrix
-(Matrix2D*)abs{
  // EFFECTS: Returns the absolute of self as a new 2x2 Matrix Object
  return [Matrix2D matrixWithVector:[col1 abs] andVector:[col2 abs]];
}

-(void)dealloc {
  // Clean up
  [col1 release];
  [col2 release];
  [super dealloc];
}

@end

