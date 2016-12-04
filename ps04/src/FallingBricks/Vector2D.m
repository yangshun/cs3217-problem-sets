//
//
//  NUS CS3217 2012 
//  Problem Set 4
//  The Physics Engine
//
//

#import "Vector2D.h"

@implementation Vector2D
// OVERVIEW: This class implements an immutable 2-dimensional vector
//             and supports some basic vector operations. 

@synthesize x,y;

-(double)length {
  // EFFECTS: Returns the length of this vector
  return sqrt(x * x + y * y);
}

// Constructor for initalizing Vector2D
-(id)initWith:(double)px y:(double)py{
  // EFFECTS: initializes the state of this 2D Vector with x and y
  if(self = [super init]){
    x = px;
    y = py;
  }
  return self;
}

// Static method for return auto-released Vector2D
// EFFECTS: Returns autoreleased 2d vector
+(Vector2D*)vectorWith:(double)x y:(double)y {
  // EFFECTS: Returns an autoreleased 2D vector
  return [[Vector2D alloc] initWith:x y:y];
}

-(Vector2D*)add:(Vector2D*)v {
  // REQUIRES: v != nil 
  // EFFECTS: Returns a new vector that is the sum of self and v.
  return [Vector2D vectorWith:(self.x+v.x)y:(self.y+v.y)];
}

-(Vector2D*)subtract:(Vector2D*)v {
  // REQUIRES: v != nil 
  // EFFECTS: Returns a new vector that is equal to self minus v.
  return [Vector2D vectorWith:(self.x-v.x)y:(self.y-v.y)];
}

-(Vector2D*)multiply:(double)scalar {
  // EFFECTS: Returns a new vector that is the scalar multiple of self.
  return [Vector2D vectorWith:(self.x*scalar)y:(self.y*scalar)];
}

-(Vector2D*)abs {
  // EFFECTS: Returns a new vector consisting of the absolute (abs) values of the various components.
  return [Vector2D vectorWith:fabs(self.x)y:fabs(self.y)];
}

-(Vector2D*)negate {
  // EFFECTS: Returns a new vector that is the negation of this vector
  return [Vector2D vectorWith:-self.x y:-self.y];
}

-(double)dot:(Vector2D*)v {
  // REQUIRES: v != nil 
  // EFFECTS: Returns the dot product of self and v
  return self.x*v.x + self.y*v.y;
}

-(double)cross:(Vector2D *)v {
  // REQUIRES: v != nil 
  // EFFECTS: Returns the cross product of self and v
  //		Since cross product is a vector perpendicular to x-y-plane,
  //		x and y components are zero, thus only the z-component
  //		is returned, which is a double.
  return self.x*v.y - self.y*v.x;
}

-(Vector2D*)crossZ:(double)v {
  // EFFECTS: Returns the cross product of this vector
  //		with a Z-component of double v
  return [Vector2D vectorWith:(v*self.y) y:(-v*self.x)];
}

@end
