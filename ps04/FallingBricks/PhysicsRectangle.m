//
//  PhysicsRectangle.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsRectangle.h"

@implementation PhysicsRectangle

@synthesize tag;
@synthesize m;
@synthesize I;
@synthesize w;
@synthesize v;
@synthesize dt;
@synthesize center;
@synthesize rotation;
@synthesize fr;
@synthesize width;
@synthesize height;
@synthesize contactPoints;

- (id)initWithOrigin:(CGPoint)origin 
           andHeight:(CGFloat)thisHeight 
            andWidth:(CGFloat)thisWidth 
             andMass:(CGFloat)mass 
         andRotation:(CGFloat)angle 
         andFriction:(CGFloat)thisFr
            andIndex:(int)index {
  
  self = [super init];
  
  if (self) {
    tag = index;
    width = thisWidth;
    height = thisHeight;
    center = [Vector2D vectorWith:origin.x + width/2 
                                y:origin.y + height/2];
    rotation = angle;
    m = mass;
    v = [Vector2D vectorWith:0 y:0];
    w = 0;
    fr = thisFr;
    I = ((width * width) + (height * height)) * m / 12.0;
    contactPoints = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce {
  v = [v add:[[gravity add:[extForce multiply:(1 / m)]]multiply:dt]];
}
/*
- (void)updateAngularVelocity:(CGFloat)extTorque {
  w += dt * extTorque / I;
}

- (void)translate:(Vector2D*)vector {
  center = [center add: vector];
}

- (void)rotateByAngle:(CGFloat)angle {
  rotation += angle;
}

- (void)updatePosition {
  v = [v add:[Vector2D vectorWith:(v.x * dt) y:(v.y * dt)]];
  [self translate:v];
  CGFloat changeInAngularDist = w * dt;
  
  rotation += changeInAngularDist;
  
  [self rotateByAngle:changeInAngularDist];
}
*/
- (BOOL)testOverlap:(PhysicsRectangle*)other {
  
  Vector2D *hA = [Vector2D vectorWith:width/2 y:height/2];
  Vector2D *pA = [Vector2D vectorWith:center.x y:center.y];
  Matrix2D *rotA = [Matrix2D initRotationMatrix:rotation];
  Matrix2D *rotTA = [rotA transpose];
  
  otherRect = other;
  Vector2D *hB = [Vector2D vectorWith:otherRect.width/2 y:otherRect.height/2];
  Vector2D *pB = otherRect.center;
  Matrix2D *rotB = [Matrix2D initRotationMatrix:otherRect.rotation];
  Matrix2D *rotTB = [rotB transpose];
  
  Vector2D *d = [pB subtract:pA];
  Vector2D *dA = [rotTA multiplyVector:d];
  Vector2D *dB = [rotTB multiplyVector:d];
  
  Matrix2D *C = [rotTA multiply:rotB];
  Matrix2D *CT = [C transpose];
  
  Vector2D *fA = [[[dA abs] subtract:hA] subtract:[[C abs] multiplyVector:hB]];
  Vector2D *fB = [[[dB abs] subtract:hB] subtract:[[CT abs] multiplyVector:hA]];

  fax = fA.x;
  fay = fA.y;
  fbx = fB.x;
  fby = fB.y;
  
  double fi[] = {fA.x, fA.y, fB.x, fB.y};
  
  if (fA.x > 0 || fA.y > 0 || fB.x > 0 || fB.y > 0) {
    return NO;
  }

  VectorDiffComponent index = ax;
  CGFloat largestFi;

  largestFi = MAX(MAX(fax, fay), MAX(fbx, fby));
  
  if (largestFi == fax) {
    index = ax;
  } else if (largestFi == fay) {
    index = ay;
  } else if (largestFi == fbx) {
    index = bx;
  } else if (largestFi == fby) {
    index = by;
  }
  
  Vector2D *nf, *ns;
  double Dneg, Dpos, Df, Ds;
  
  switch (index) {
    case ax:
      if (dA.x > 0) {
        // E1 of A is the reference edge
        n = rotA.col1;
      } else {
        // E3 of A is the reference edge
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
        //E4 of A is the reference edge
        n = rotA.col2;
      } else {
        //E2 of A is the reference edge
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
        //E3 of B is the reference edge
        n = rotB.col1;
      } else {
        //E1 of B is the reference edge
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
      if (dB.y > 0) {
        //E2 of B is the reference edge
        n = rotB.col2;
      } else {
        //E4 of B is the reference edge
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
  
  Vector2D *ni, *h, *p;
  Matrix2D *rot;
  
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
 
  Vector2D *v1;
  Vector2D *v2;
  
  // Pick incident edge
  if (([ni abs].x > [ni abs].y) && (ni.x > 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
  } else if (([ni abs].x > [ni abs].y) && (ni.x <= 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
  } else if (([ni abs].x <= [ni abs].y) && (ni.y > 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
  } else if (([ni abs].x <= [ni abs].y) && (ni.y <= 0)) {
    v1 = [p add:[rot multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
    v2 = [p add:[rot multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
  } 
  
  // First clipping
  CGFloat dist1 = [[ns negate] dot:v1] - Dneg;
  CGFloat dist2 = [[ns negate] dot:v2] - Dneg;
  
  Vector2D *v1p;
  Vector2D *v2p;
  
  if (dist1 < 0 && dist2 < 0) {
    v1p = v1;
    v2p = v2;
  } else if (dist1 > 0 && dist2 > 0) {
    return NO;
  } else if (dist1 < 0 && dist2 > 0) {
    v1p = v1;
    v2p = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  } else if (dist1 > 0 && dist2 < 0) {
    v1p = v2;
    v2p = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  }
  
  // Second clipping
  dist1 = [ns dot:v1p] - Dpos;
  dist2 = [ns dot:v2p] - Dpos;
  
  Vector2D *v1pp;
  Vector2D *v2pp;
  
  if (dist1 < 0 && dist2 < 0) {
    v1pp = v1p;
    v2pp = v2p;
  } else if (dist1 > 0 && dist2 > 0) {
    return NO;
  } else if (dist1 < 0 && dist2 > 0) {
    v1pp = v1p;
    v2pp = [v1p add:[[v2p subtract:v1p] multiply:(dist1 / (dist1 - dist2))]];
  } else if (dist1 > 0 && dist2 < 0) {
    v1pp = v2p;
    v2pp = [v1p add:[[v2p subtract:v1p] multiply:(dist1 / (dist1 - dist2))]];
  }

  [contactPoints removeAllObjects];
  
  if (v1pp == v2pp)
    return NO;
  else {
      CGFloat s1 = [nf dot:v1pp] - Df;
      Vector2D *c1 = [v1pp subtract:[nf multiply:s1]];
      [contactPoints addObject:c1];
      separationDist[0] = s1;
      
      CGFloat s2 = [nf dot:v2pp] - Df;
      Vector2D *c2 = [v2pp subtract:[nf multiply:s2]];
      [contactPoints addObject:c2];
      separationDist[1] = s2;
    //Test:
    //n = nf;
      return YES;
  }
}

- (void)applyImpulses {
  for (int i = 0; i < [contactPoints count]; i++) {
    [self applyImpulsesAtContactPoint:[contactPoints objectAtIndex:i] 
                           separation:separationDist[i]];
  }
}

- (void)applyImpulsesAtContactPoint:(Vector2D*)c separation:(CGFloat)s {
  
  Vector2D *pA = [Vector2D vectorWith:center.x y:center.y];
  Vector2D *rA = [c subtract:pA];
  Vector2D *pB = [Vector2D vectorWith:otherRect.center.x y:otherRect.center.y];
  Vector2D *rB = [c subtract:pB];
  
  Vector2D *uA = [self.v add:[rA crossZ:-self.w]];
  Vector2D *uB = [otherRect.v add:[rB crossZ:-otherRect.w]];

  Vector2D *t = [n crossZ:1.0];
  
  Vector2D *u = [uB subtract:uA];
  
  CGFloat un = [u dot:n];
  CGFloat ut = [u dot:t];
  
  CGFloat mn = 1.0 / ((1 / self.m) + (1 / otherRect.m) + (([rA dot:rA] - ([rA dot:n] * [rA dot:n])) / self.I) + (([rB dot:rB] - ([rB dot:n] * [rB dot:n])) / otherRect.I));
  CGFloat mt = 1.0 / ((1 / self.m) + (1 / otherRect.m) + (([rA dot:rA] - ([rA dot:t] * [rA dot:t])) / self.I) + (([rB dot:rB] - ([rB dot:t] * [rB dot:t])) / otherRect.I));
  
  double e = 0.15;
  CGFloat epsilon = 0.05;
  CGFloat k = 0.05;
  CGFloat bias = ABS(epsilon / dt * (k + s));
  
  if (k < s) {
    bias = 0;
  }
  
  Vector2D *pn = [n multiply:MIN(0, (mn * ((1 + e) * un - bias)))]; 
  CGFloat dPt = mt * ut;
  
  CGFloat ptmax = self.fr * otherRect.fr * pn.length;
  
  dPt = MAX(-ptmax, MIN(dPt, ptmax));
  
  Vector2D *pt = [t multiply:dPt];
  Vector2D *sumOfP = [pn add:pt];
  
  self.v = [self.v add:[sumOfP multiply:(1.0 / self.m)]]; 
  otherRect.v = [otherRect.v subtract:[sumOfP multiply:(1.0 / otherRect.m)]]; 
  
  self.w = self.w + ([rA cross:sumOfP] / self.I);
  otherRect.w = otherRect.w - ([rB cross:sumOfP] / otherRect.I);
}

- (void)moveBodies {
  center = [center add:[v multiply:dt]];
  rotation += w * dt;
}

@end
