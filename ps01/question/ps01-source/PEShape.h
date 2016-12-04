//
//  PEShape.h
//  
//  CS3217 || Assignment 1
//

#import<Foundation/Foundation.h>

@protocol PEShape <NSObject>

// shape origin point
@property (nonatomic) CGPoint origin;

// shape centre of mass point
@property (nonatomic, readonly) CGPoint center;

// shape rotation angle around center of mass (in degrees)
@property (nonatomic) CGFloat rotation;

- (void)rotate:(CGFloat)angle;
  // MODIFIES: self
  // EFFECTS: rotates this shape anti-clockwise by the specified angle
  // around the center of mass in degrees

- (void)translateX:(CGFloat)dx Y:(CGFloat)dy;
  // MODIFIES: self
  // EFFECTS: translates this shape by the specified dx (along the
  //            X-axis) and dy coordinates (along the Y-axis)

- (BOOL)overlapsWithShape:(id<PEShape>)shape;
  // EFFECTS: returns YES if this shape overlaps with specified shape.

- (CGRect)boundingBox;
  // EFFECTS: returns the bounding box of this shape.

@end


