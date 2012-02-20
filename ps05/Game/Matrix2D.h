//
//
//  NUS CS3217 2012 
//  Problem Set 4
//  The Physics Engine
//
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@interface Matrix2D : NSObject {
// OVERVIEW: This class implements an immutable 2x2 matrix
//	       and supports a number of matrix operations

	Vector2D *col1, *col2;
}

@property (readonly) Vector2D* col1;
@property (readonly) Vector2D* col2;

// Static Method for creating a Matrix with 2 Vector2Ds.
+(Matrix2D*)matrixWithVector:(Vector2D*)v1 andVector:(Vector2D*)v2;
  // REQUIRES: v1 != nil && v2 != nil
  // EFFECTS: Returns an auto released 2x2 Matrix

// Static Method for creating a Matrix with 4 values.
+(Matrix2D*)matrixWithValues:(double)c1r1 and:(double)c1r2 and:(double)c2r1 and:(double)c2r2;
  // EFFECTS: Returns an autoreleased 2x2 Matrix

// Static Method for creating a rotational Matrix with an angle
+(Matrix2D*)initRotationMatrix:(double)angle;
  // EFFECTS: Returns an autoreleased 2x2 Matrix

// Calculates transposition of this matrix
-(Matrix2D*)transpose;
  // EFFECTS: Returns a new matrix that is a transpose of self.

// Calculates Inverse the matrix 
-(Matrix2D*)inverse;
  // EFFECTS: Returns a new matrix that is the inverse of self.

// Multiplies this matrix with another vector
-(Vector2D*)multiplyVector:(Vector2D*)v;
  // REQUIRES: v != nil 
  // EFFECTS: Returns a new matrix that is the result of multiplying self by v.

// Calculates the sum of this matrix with another 2x2 Matrix
-(Matrix2D*)add:(Matrix2D*)m;
  // REQUIRES: m != nil 
  // EFFECTS: Returns a new matrix that is the sum of self and m.

// Perform matrix multiplication with another 2x2 Matrix
-(Matrix2D*)multiply:(Matrix2D*)m;
  // REQUIRES: m != nil 
  // EFFECTS: Returns a new matrix that is the matrix product of self and m.

// Multiplies all the elements of this matrix by a scalar
-(Matrix2D*)multiplyScalar:(double)scal;
  // EFFECTS: Returns a new matrix that is the scalar multiple of self.

// Calculate the absolute of the Matrix
-(Matrix2D*)abs;
  // EFFECTS: Returns the absolute of self as a new 2x2 Matrix Object

@end
