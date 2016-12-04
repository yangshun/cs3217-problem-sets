//
//  PERectangle.h
//  
//  CS3217 || Assignment 1
//

#import<Foundation/Foundation.h>
#import "PEShape.h"

typedef enum {
	 kTopLeftCorner = 1,
	 kTopRightCorner = 2,
	 kBottomLeftCorner = 3,
	 kBottomRightCorner = 4
} CornerType;
 

@interface PERectangle : NSObject <PEShape> {
// OVERVIEW: This class implements a rectangle and the associated
//             operations. 

}

// rectangle width
@property (nonatomic, readonly) CGFloat width;

// rectangle height
@property (nonatomic, readonly) CGFloat height;

// rectangle corners
@property (nonatomic, readonly) CGPoint* corners;

- (id)initWithOrigin:(CGPoint)o width:(CGFloat)w height:(CGFloat)h rotation:(CGFloat)r;
// MODIFIES: self
// EFFECTS: initializes the state of this rectangle with origin, width,
//          height, and rotation angle in degrees

- (id)initWithRect:(CGRect)rect;
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle using a CGRect

- (BOOL)overlapsWithRect:(PERectangle*)rect;
  // EFFECTS: returns YES if this shape overlaps with specified rectangle

@end
