//
//  Rectangle.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix2D.h"
#import "Vector2D.h"

typedef enum {E1, E2, E3, E4} ReferenceEdge;
typedef enum {ax, ay, bx, by} VectorDiffComponent;

@interface Rectangle : UIView {
  
  Rectangle *otherRect;
  
  // Physical quantities related to dynamics
  CGFloat m;        // Mass
  CGFloat I;        // Moment of Inertia
  CGFloat w;        // Angular velocity
  Vector2D *v;
  Vector2D *v1;
  Vector2D *v2;
  
  // Physical quantities related to position of rectangle
  CGPoint center;   // Center of mass
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
  
  // Self vector quantities
  Vector2D *h;
  Vector2D *hA;
  Vector2D *pA;
  Vector2D *d;
  Vector2D *dA;
  Vector2D *fA;
  Vector2D *p;
  
  // Self matrix quantities
  Matrix2D *rot;
  Matrix2D *rotA;
  Matrix2D *rotTA;
  Matrix2D *C;
  Matrix2D *CT;
  
  // Other rectangle vector quantities
  Vector2D *vB;
  Vector2D *hB;
  Vector2D *pB;
  Vector2D *dB;
  Vector2D *fB;
  
  // Other rectangle matrix quantities
  Matrix2D *rotB;
  Matrix2D *rotTB;
  
  // Collision related quantities
  ReferenceEdge ref;
  Vector2D *n;
  Vector2D *nf;
  Vector2D *ns;
  Vector2D *ni;
  Vector2D *c1;
  Vector2D *c2;
  
  CGFloat Df;
  CGFloat Ds;
  CGFloat Dneg;
  CGFloat Dpos;
  CGFloat e;
  
  NSMutableArray *contactPoints;
  CGFloat separationDist[2];
}

@property (nonatomic, readonly) CGFloat m;
@property (nonatomic, readonly) CGFloat I;
@property (nonatomic, strong, readwrite) Vector2D *v;
@property (nonatomic, readwrite) CGFloat w;
@property (nonatomic, readwrite) CGFloat dt;
@property (nonatomic, readwrite) CGFloat rotation;
@property (nonatomic, readonly) CGFloat fr;
@property (nonatomic, readonly) Vector2D *hA;
@property (nonatomic, readonly) Vector2D *pA;
@property (nonatomic, readonly) Matrix2D *rotA;
@property (nonatomic, readonly) Matrix2D *rotTA;
@property (nonatomic, readonly) NSMutableArray *contactPoints;

- (id)init;
- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce;
- (void)updateAngularVelocity:(CGFloat)extTorque;
- (void)translate:(Vector2D*)vector;
- (void)rotate:(CGFloat)angle;
- (void)updatePosition;
- (void)initSelfVectorsAndMatricesQuantities;
- (BOOL)testOverlap:(Rectangle*)otherRect;
- (void)calculateContactPoints;
- (void)applyImpulses;
- (void)applyImpulsesAtContactPoints:(Vector2D*)c separation:(CGFloat)s;
- (void)moveBodies;

@end
