//
//  PhysicsRectangle.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix2D.h"
#import "Vector2D.h"

typedef enum {ax, ay, bx, by} VectorDiffComponent;

@interface PhysicsRectangle : NSObject {
  
  PhysicsRectangle *otherRect;
  int tag;
  
  // Physical quantities related to dynamics
  CGFloat m;        // Mass
  CGFloat I;        // Moment of Inertia
  CGFloat w;        // Angular velocity
  Vector2D *v;
  
  // Physical quantities related to position of rectangle
  Vector2D *center;   // Center of mass
  CGFloat rotation; // Angle rotated from upright position
  CGFloat height;
  CGFloat width;
  CGFloat dt;
  
  CGFloat fax;
  CGFloat fay;
  CGFloat fbx;
  CGFloat fby;
  
  // Physical quantities related to forces
  Vector2D *force;
  CGFloat torque;
  CGFloat fr;       // Coefficient of friction
  Vector2D *n;
  
  NSMutableArray *contactPoints;
  CGFloat separationDist[2];
}

@property (nonatomic, readonly) int tag;
@property (nonatomic, readonly) CGFloat m;
@property (nonatomic, readonly) CGFloat I;
@property (nonatomic, strong, readwrite) Vector2D *v;
@property (nonatomic, readwrite) CGFloat w;
@property (nonatomic, readwrite) CGFloat dt;
@property (nonatomic, strong, readwrite) Vector2D *center;
@property (nonatomic, readwrite) CGFloat rotation;
@property (nonatomic, readonly) CGFloat fr;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) NSMutableArray *contactPoints;

- (id)initWithOrigin:(CGPoint)origin 
           andHeight:(CGFloat)height 
            andWidth:(CGFloat)width 
             andMass:(CGFloat)mass 
         andRotation:(CGFloat)angle 
         andFriction:(CGFloat)fr
            andIndex:(int)index;
- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce;
- (void)updateAngularVelocity:(CGFloat)extTorque;
- (void)translate:(Vector2D*)vector;
- (void)updatePosition;
- (BOOL)testOverlap:(PhysicsRectangle*)otherRect;
- (void)calculateContactPoints;
- (void)applyImpulses;
- (void)applyImpulsesAtContactPoint:(Vector2D*)c separation:(CGFloat)s;
- (void)moveBodies;

@end
