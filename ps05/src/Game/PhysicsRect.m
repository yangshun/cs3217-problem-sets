//
//  PhysicsRectangle.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsRect.h"

@implementation PhysicsRect

- (id)initWithOrigin:(CGPoint)origin 
            andWidth:(double)thisWidth
           andHeight:(double)thisHeight 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)thisFr
      andRestitution:(double)coeff
             andView:(UIView*)viewObj; {
  // MODIFIES: PhysicsRect object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: a PhysicsRect object with the method parameters as the 
  //          attributes are initialized
  self = [super initWithOrigin:(CGPoint)origin 
                      andWidth:thisWidth
                     andHeight:thisHeight 
                       andMass:mass 
                   andRotation:angle 
                   andFriction:thisFr
                andRestitution:coeff
                       andView:(UIView*)viewObj];
  
  if (self) {
    I = ((width * width) + (height * height)) * m / 12.0;
  }
  
  return self;
}

- (BOOL)testOverlap:(PhysicsRect*)other {
  // REQUIRES: otherRect != nil
  // EFFECTS: Tests whether this rectangle is overlapping with another rectangle  
  Vector2D *hA = [Vector2D vectorWith:width/2 y:height/2];
  Vector2D *pA = [Vector2D vectorWith:center.x y:center.y];
  Matrix2D *rotA = [Matrix2D initRotationMatrix:rotation];
  Matrix2D *rotTA = [rotA transpose];
  
  otherShape = other;
  Vector2D *hB = [Vector2D vectorWith:otherShape.width/2 y:otherShape.height/2];
  Vector2D *pB = otherShape.center;
  Matrix2D *rotB = [Matrix2D initRotationMatrix:otherShape.rotation];
  Matrix2D *rotTB = [rotB transpose];
  
  Vector2D *d = [pB subtract:pA];
  Vector2D *dA = [rotTA multiplyVector:d];
  Vector2D *dB = [rotTB multiplyVector:d];
  
  Matrix2D *C = [rotTA multiply:rotB];
  Matrix2D *CT = [C transpose];
  
  Vector2D *fA = [[[dA abs] subtract:hA] subtract:[[C abs] multiplyVector:hB]];
  Vector2D *fB = [[[dB abs] subtract:hB] subtract:[[CT abs] multiplyVector:hA]];
  
  double fi[] = {fA.x, fA.y, fB.x, fB.y};
  
  if (fi[0] > 0 || fi[1] > 0 || fi[2] > 0 || fi[3] > 0) {
    return NO;
  }
  
  VectorDiffComponent index = ax;
  double largestFi;
  
  largestFi = MAX(MAX(fi[0], fi[1]), MAX(fi[2], fi[3]));
  
  for (int i = 0; i < 4; i++) {
    if (largestFi == fi[i]) {
      index = (VectorDiffComponent)i;
    }
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
      
    default:
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
  
  // first clipping
  double dist1 = [[ns negate] dot:v1] - Dneg;
  double dist2 = [[ns negate] dot:v2] - Dneg;
  
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
  
  // second clipping
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
  separationDist[0] = 0;
  separationDist[1] = 0;
  
  double s1 = [nf dot:v1pp] - Df;
  int iter = 0;
  if (s1 <= 0) {
    Vector2D *c1 = [v1pp subtract:[nf multiply:s1]];
    [contactPoints addObject:c1];
    separationDist[iter++] = s1;
  }
  
  double s2 = [nf dot:v2pp] - Df;
  if (s2 <= 0) {
    Vector2D *c2 = [v2pp subtract:[nf multiply:s2]];
    [contactPoints addObject:c2];
    separationDist[iter] = s2;
  }
  
  return YES;
}

@end
