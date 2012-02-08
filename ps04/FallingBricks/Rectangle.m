//
//  Rectangle.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

@synthesize m;
@synthesize I;
@synthesize w;
@synthesize v;
@synthesize dt;
@synthesize rotation;
@synthesize hA;
@synthesize pA;
@synthesize rotA;
@synthesize rotTA;

- (id)initWithImage {
  
  self = [super init];
  if (self) {
    UIImage* ironImage = [UIImage imageNamed:@"iron.png"];
    rect = [[UIImageView alloc] initWithImage:ironImage];
    rect.frame = CGRectMake(360, 200, 30, 130);
    self.view = rect;
    m = 1;
    v = [Vector2D vectorWith:0 y:0];
    width = self.view.bounds.size.width;
    height = self.view.bounds.size.height;
    //rotation = 0.7;
    I = ((width * width) + (height * height)) * m / 12.0;
    contactPoints = [[NSMutableArray alloc] init];
    [self rotate:rotation];
  }
  return self;
}

- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce {
  v = [v add:[[gravity add:[extForce multiply:1/m]]multiply:dt]];
}

- (void)updateAngularVelocity:(CGFloat)extTorque {
  w += dt * extTorque / I;
}

- (void)translate:(Vector2D*)vector {
  self.view.center = CGPointMake(self.view.center.x + vector.x, 
                                 self.view.center.y + vector.y);
}

- (void)rotate:(CGFloat)angle {
  self.view.transform = CGAffineTransformRotate(self.view.transform, angle);
}

- (void)updatePosition {
  v = [v add:[Vector2D vectorWith:(v.x * dt) y:(v.y * dt)]];
  [self translate:v];
  CGFloat changeInAngularDist = w * dt;
  
  rotation += changeInAngularDist;
  
  [self rotate:changeInAngularDist];
}

- (void)initSelfVectorsAndMatricesQuantities {
  
  hA = [Vector2D vectorWith:width/2 y:height/2];
  pA = [Vector2D vectorWith:self.view.center.x 
                          y:self.view.center.y];
  rotA = [Matrix2D matrixWithValues:cos(self.rotation) 
                                and:sin(self.rotation)
                                and:-sin(self.rotation)
                                and:cos(self.rotation)];
  rotTA = [rotA transpose];
}

- (BOOL)testOverlap:(Rectangle*)other {
  otherRect = other;
  hB = other.hA;
  pB = other.pA;
  rotB = other.rotA;
  rotTB = other.rotTA;
  
  d = [pB subtract:pA];
  dA = [rotTA multiplyVector:d];
  dB = [rotTB multiplyVector:d];
  
  C = [rotTA multiply:rotB];
  CT = [C transpose];
  
  fA = [[[dA abs] subtract:hA] subtract:[[C abs] multiplyVector:hB]];
  fB = [[[dB abs] subtract:hB] subtract:[[CT abs] multiplyVector:hA]];
  
  fi[0] = fA.x;
  fi[1] = fA.y;
  fi[2] = fB.x;
  fi[3] = fB.y;
  
  if (fA.x <= 0 && fA.y <= 0 && fB.x <= 0 && fB.y <= 0) {
    return true;
  } else {
    return false;
  }
}

- (void)calculateContactPoints {

  VectorDiffComponent index = ax;
  CGFloat largestFi = fi[ax];

  for (int i = 1; i < 4; i++) {
    if (fi[i] > fi[index]) {
      index = i;
      largestFi = fi[i];
    }
  }
  
  switch (index) {
    case ax:
      if (dA.x > 0) {
        ref = E1;
        n = rotA.col1;
      } else {
        ref = E3;
        n = [rotA.col1 negate];
      }
      nf = n;
      Df = [pA dot:nf] + hA.x;
      ns = rotA.col2;
      Ds = [pA dot:ns];
      Dneg = hA.y - Ds;
      Dpos = hA.y + Ds;
      break;
      
    case ay:
      if (dA.y > 0) {
        ref = E4;
        n = rotA.col2;
      } else {
        ref = E2;
        n = [rotA.col2 negate];
      }
      nf = n;
      Df = [pA dot:nf] + hA.y;
      ns = rotA.col1;
      Ds = [pA dot:ns];
      Dneg = hA.x - Ds;
      Dpos = hA.x + Ds;
      break;
      
    case bx:
      if (dB.x > 0) {
        ref = E3;
        n = rotB.col1;
      } else {
        ref = E1;
        n = [rotB.col1 negate];
      }
      nf = [n negate];
      Df = [pB dot:nf] + hB.x;
      ns = rotB.col2;
      Ds = [pB dot:ns];
      Dneg = hB.y - Ds;
      Dpos = hB.y + Ds;
      break;
      
    case by:
      if (dB.x > 0) {
        ref = E2;
        n = rotB.col2;
      } else {
        ref = E4;
        n = [rotB.col2 negate];
      }
      nf = [n negate];
      Df = [pB dot:nf] + hB.y;
      ns = rotB.col1;
      Ds = [pB dot:ns];
      Dneg = hB.x - Ds;
      Dpos = hB.x + Ds;
      break;
  }
  
  if (index == ax || index == ay) {
    ni = [[rotTB multiplyVector:nf] negate];
    p = pB;
    rot = rotB;
    h = hB;
  } else if (index == bx || index == by) {
    ni = [[rotTA multiplyVector:nf] negate];
    p = pA;
    rot = rotA;
    h = hA;
  }
  
  if (([ni abs].x > [ni abs].y) && (ni.x > 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
  } else if (([ni abs].x > [ni abs].y) && (ni.x <= 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
  } else if (([ni abs].x <= [ni abs].y) && (ni.y > 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
  } else if (([ni abs].x <= [ni abs].y) && (ni.x <= 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
  } 
  
  // First clipping
  CGFloat dist1 = [[ns negate] dot:v1] - Dneg;
  CGFloat dist2 = [[ns negate] dot:v2] - Dneg;
  
  if (dist1 < 0 && dist2 < 0) {
    v1 = v1;
    v2 = v2;
  } else if (dist1 > 0 && dist2 > 0) {
    return;
  } else if (dist1 < 0 && dist2 > 0) {
    v1 = v1;
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  } else if (dist1 > 0 && dist2 < 0) {
    v1 = v2;
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  }
  
  // Second clipping
  dist1 = [ns dot:v1] - Dpos;
  dist2 = [ns dot:v2] - Dpos;
  
  if (dist1 < 0 && dist2 < 0) {
    v1 = v1;
    v2 = v2;
  } else if (dist1 > 0 && dist2 > 0) {
    return;
  } else if (dist1 < 0 && dist2 > 0) {
    v1 = v1;
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  } else if (dist1 > 0 && dist2 < 0) {
    v1 = v2;
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  }
  
  CGFloat s1 = [nf dot:v1] - Df;
  c1 = [v1 subtract:[nf multiply:s1]];
  
  if (s1 < 0) {
    [contactPoints addObject:c1];
    separationDist[0] = s1;
  }
  
  CGFloat s2 = [nf dot:v2] - Df;
  c2 = [v2 subtract:[nf multiply:s2]];
  
  if (s2 < 0) {
    [contactPoints addObject:c2];
    separationDist[1] = s2;
  }
  
}

- (void)applyImpulses {
  for (int i = 0; i < [contactPoints count]; i++) {
    [self applyImpulsesAtContactPoints:[contactPoints objectAtIndex:i] 
                            separation:separationDist[i]];
  }
}

- (void)applyImpulsesAtContactPoints:(Vector2D*)c separation:(CGFloat)s {
  Vector2D *rA = [c subtract:pA];
  Vector2D *rB = [c subtract:pB];
  
  Vector2D *uA = [self.v add:[rA multiply:self.w]];
  Vector2D *uB = [otherRect.v add:[rB multiply:otherRect.w]];

  Vector2D *t = [n crossZ:1.0];
  
  Vector2D *u = [uB subtract:uA];
  
  CGFloat un = [u dot:n];
  CGFloat ut = [u dot:t];
  
  CGFloat mn = 1 / ((1 / self.m) + (1 / otherRect.m)
                    + (([rA dot:rA] - [rA dot:n]*[rA dot:n]) / self.I)
                    + (([rB dot:rB] - [rB dot:n]*[rB dot:n]) / otherRect.I));
  CGFloat mt = 1 / ((1 / self.m) + (1 / otherRect.m)
                    + (([rA dot:rA] - [rA dot:t]*[rA dot:t]) / self.I)
                    + (([rB dot:rB] - [rB dot:t]*[rB dot:t]) / otherRect.I));
  
}

@end
