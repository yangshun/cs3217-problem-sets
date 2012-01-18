//
//  PERectangle.m
//  
//  CS3217 || Assignment 1
//  Name: Tay Yang Shun
//

#import "PERectangle.h"

@implementation PERectangle
// OVERVIEW: This class implements a rectangle and the associated
//             operations.

@synthesize origin, rotation, width, height; 
//corners;

- (CGPoint)center {
  // EFFECTS: returns the coordinates of the centre of mass for this
  // rectangle.
  CGPoint centerOfMass = CGPointMake((origin.x + ((double)width)/2), (origin.y + ((double)height)/2));
 
  return centerOfMass;
}

- (CGPoint)cornerFrom:(CornerType)corner {
  // REQUIRES: corner is a enum constant defined in PEShape.h as follows:
  //           kTopLeftCorner, kTopRightCorner, kBottomLeftCorner,
  //		   kBottomRightCorner 
  // EFFECTS: returns the coordinates of the specified rotated rectangle corner after rotating
	CGPoint point;
	
	// determines the coordinate of the corner prior to rotation based on object state properties
	switch(corner) {
		case kTopLeftCorner:
			point.x = self.center.x - width/2;
			point.y = self.center.y - height/2;
			break;
		case kTopRightCorner:
			point.x = self.center.x + width/2;
			point.y = self.center.y - height/2;
			break;
		case kBottomRightCorner:
			point.x = self.center.x + width/2;
			point.y = self.center.y + height/2;
			break;
		case kBottomLeftCorner:
			point.x = self.center.x - width/2;
			point.y = self.center.y + height/2;
			break;
	}
    
	double x = point.x;
	double y = point.y;
	
	// modifies the coordinates of the corner based on the angle of rotation
	point.x = (x - self.center.x)*cos(self.rotation*M_PI/180) + (y - self.center.y)*sin(self.rotation*M_PI/180) + self.center.x;
	point.y = (y - self.center.y)*cos(self.rotation*M_PI/180) - (x - self.center.x)*sin(self.rotation*M_PI/180) + self.center.y;
	
	return point;
}

- (CGPoint*)corners {
  // EFFECTS:  return an array with all the rectangle corners

  CGPoint *newCorners = (CGPoint*) malloc(4*sizeof(CGPoint));
  newCorners[0] = [self cornerFrom: kTopLeftCorner];
  newCorners[1] = [self cornerFrom: kTopRightCorner];
  newCorners[2] = [self cornerFrom: kBottomRightCorner];
  newCorners[3] = [self cornerFrom: kBottomLeftCorner];
  return newCorners;
}

- (id)initWithOrigin:(CGPoint)o 
               width:(CGFloat)w 
              height:(CGFloat)h 
            rotation:(CGFloat)r{
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle with origin, width,
  //          height, and rotation angle in degrees

  self = [super init];
	
  if(self) {
	self.origin = o;
	width = w;
	height = h;
	self.rotation = r;
  }
	
  return self;
}

- (id)initWithRect:(CGRect)rect {
  // MODIFIES: self
  // EFFECTS: initializes the state of this rectangle using a CGRect
	
	self = [super init];
	
  if(self) {
		CGPoint rectOrigin = CGPointMake(rect.origin.x, rect.origin.y);
		self.origin = rectOrigin;
		width = rect.size.width;
		height = rect.size.height;
		self.rotation = 0;
  }
	
  return self;
}

- (void)rotate:(CGFloat)angle {
  // MODIFIES: self
  // EFFECTS: rotates this shape anti-clockwise by the specified angle
  // around the center of mass

	rotation += angle;
	corners = [self corners];
	
	// while loops to act as a modulo operator to ensure angle of rotation stays
	// within 0 to 360 degrees. 0 <= rotation < 360.
	/*
    while(rotation >= 360) {
		rotation -= 360;
	}
	while(rotation < 0) {
		rotation += 360;
	}*/
}

- (void)translateX:(CGFloat)dx Y:(CGFloat)dy {
  // MODIFIES: self
  // EFFECTS: translates this shape by the specified dx (along the
  //            X-axis) and dy coordinates (along the Y-axis)
    CGPoint newOrigin = CGPointMake(self.origin.x + dx, self.origin.y + dy);
    self.origin = newOrigin;

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
	
	// Makes use of Separate-Axis Theorem to determine if all the points of the other
	// rectangle object lies on one side of an edge. 
	for(int i=0; i<4; i++) {
		CGPoint vec = CGPointMake((float)(self.corners[(i+1)%4].x - self.corners[i%4].x), (float)(self.corners[(i+1)%4].y - self.corners[i%4].y));
		CGPoint rotated = CGPointMake((-1*vec.y),(vec.x));
				
		BOOL refSide = ((rotated.x * (self.corners[(i+2)%4].x - self.corners[i%4].x)) + 
						(rotated.y * (self.corners[(i+2)%4].y - self.corners[i%4].y))) >= 0;

		int count = 0;
		for(int j=0; j<4; j++) {
			BOOL side = ((rotated.x * (rect.corners[j].x - self.corners[i].x)) + 
			(rotated.y * (rect.corners[j].y - self.corners[i].y))) >= 0;
			
			if(side != refSide)
				count++;
		}
		if(count == 4)
			return NO;
		else {
			count = 0;
		}
	}
	return YES;
}

- (CGRect)boundingBox {	
  // EFFECTS: returns the bounding box of this shape.

  // optional implementation (not graded)
  return CGRectMake(INFINITY, INFINITY, INFINITY, INFINITY);
}

@end

