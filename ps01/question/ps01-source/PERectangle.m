//
//  PERectangle.m
//  
//  CS3217 || Assignment 1
//  Name: Tay Yang Shun
//	Matric No: A0073063M
//

#import "PERectangle.h"

@implementation PERectangle
// OVERVIEW: This class implements a rectangle and the associated
//             operations.

- (CGPoint)center {
  // EFFECTS: returns the coordinates of the centre of mass for this
  // rectangle.

}

- (CGPoint)cornerFrom:(CornerType)corner {
  // REQUIRES: corner is a enum constant defined in PEShape.h as follows:
  //           kTopLeftCorner, kTopRightCorner, kBottomLeftCorner,
  //		   kBottomRightCorner 
  // EFFECTS: returns the coordinates of the specified rotated rectangle corner after rotating

}

- (CGPoint*)corners {
  // EFFECTS:  return an array with all the rectangle corners

  CGPoint *corners = (CGPoint*) malloc(4*sizeof(CGPoint));
  corners[0] = [self cornerFrom: kTopLeftCorner];
  corners[1] = [self cornerFrom: kTopRightCorner];
  corners[2] = [self cornerFrom: kBottomRightCorner];
  corners[3] = [self cornerFrom: kBottomLeftCorner];
  return corners;
}

- (id)initWithOrigin:(CGPoint)o width:(CGFloat)w height:(CGFloat)h rotation:(CGFloat)r{
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle with origin, width,
  //          height, and rotation angle in degrees

}

- (id)initWithRect:(CGRect)rect {
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle using a CGRect

}

- (void)rotate:(CGFloat)angle {
  // MODIFIES: self
  // EFFECTS: rotates this shape anti-clockwise by the specified angle
  // around the center of mass

}

- (void)translateX:(CGFloat)dx Y:(CGFloat)dy {
  // MODIFIES: self
  // EFFECTS: translates this shape by the specified dx (along the
  //            X-axis) and dy coordinates (along the Y-axis)

}

- (BOOL)overlapsWithShape:(id<PEShape>)shape {
  // EFFECTS: returns YES if this shape overlaps with specified shape.
  
  if ([shape class] == [PERectangle class]) {
    return [self overlapsWithRect:(PERectangle *)shape];
  }

  return NO;
}

- (BOOL)overlapsWithRect:(PERectangle*)rect {
  // EFFECTS: returns YES if this shape overlaps with specified shape.
  // <add missing code here>

}

- (CGRect)boundingBox {	
  // EFFECTS: returns the bounding box of this shape.

  // optional implementation (not graded)
  return CGRectMake(INFINITY, INFINITY, INFINITY, INFINITY);
}

@end

