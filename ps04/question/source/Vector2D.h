//
//
//  NUS CS3217 2012 
//  Problem Set 4
//  The Physics Engine
//
//

#import <Foundation/Foundation.h>


@interface Vector2D : NSObject {
// OVERVIEW: This class implements an immutable 2-dimensional vector
//             and supports some basic vector operations. 
  double x, y;
}

@property (readonly) double x;
@property (readonly) double y;

@property (readonly) double length;
// EFFECTS: Returns the length of this vector

// Static method for return auto-released Vector2D
+(Vector2D*)vectorWith:(double)x y:(double)y;
  // EFFECTS: Returns an autoreleased 2D vector

-(Vector2D*)add:(Vector2D*)v;
  // REQUIRES: v != nil 
  // EFFECTS: Returns a new vector that is the sum of self and v.

-(Vector2D*)subtract:(Vector2D*)v;
  // REQUIRES: v != nil 
  // EFFECTS: Returns a new vector that is equal to self minus v.

-(Vector2D*)multiply:(double)scalar;
  // EFFECTS: Returns a new vector that is the scalar multiple of self.

-(Vector2D*)abs;
  // EFFECTS: Returns a new vector consisting of the absolute (abs) values of the various components.

-(Vector2D*)negate;
  // EFFECTS: Returns a new vector that is the negation of this vector

-(double)dot:(Vector2D*)v;
  // REQUIRES: v != nil 
  // EFFECTS: Returns the dot product of self and v

-(double)cross:(Vector2D*)v;
  // REQUIRES: v != nil 
  // EFFECTS: Returns the cross product of self and v
  //		Since cross product is a vector perpendicular to x-y-plane,
  //		x and y components are zero, thus only the z-component
  //		is returned, which is a double.

-(Vector2D*)crossZ:(double)v;
  // EFFECTS: Returns the cross product of this vector
  //		with a Z-component of double v

@end
