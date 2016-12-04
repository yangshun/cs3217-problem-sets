//
//  PhysicsRectTest.m
//  PhysicsRectTest
//
//  Created by Yang Shun Tay on 12/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsRectTest.h"

#define kTimeStep 0.01 

@implementation PhysicsRectTest
 
PhysicsRect* phyRectMake(double x, double y, double width, double height, 
                         double mass, double rotation, double friction, 
                         double restitution, int index) {
  return [[PhysicsRect alloc] initWithOrigin:CGPointMake(x, y)
                                    andWidth:width
                                   andHeight:height
                                     andMass:mass
                                 andRotation:rotation
                                 andFriction:friction
                              andRestitution:restitution
                                    andIndex:index];  
}

- (void)setUp {
  [super setUp];
  // Set-up code here.
}

- (void)testOverlap {
  
  PhysicsRect *rect1 = phyRectMake(290, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  PhysicsRect *rect2 = phyRectMake(400, 310, 240, 140, 100, 0, 0.1, 0.1, 0);
  STAssertTrue([rect1 testOverlap:rect2], @"rect1 and rect2 should be overlapping");
  STAssertTrue([rect2 testOverlap:rect1], @"rect2 and rect1 should be overlapping");
  
  PhysicsRect *rect3 = phyRectMake(290, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  PhysicsRect *rect4 = phyRectMake(400, 300, 250, 150, 100, 1, 0.1, 0.1, 0);
  STAssertTrue([rect3 testOverlap:rect4], @"rect3 and rect4 should be overlapping");
  STAssertTrue([rect4 testOverlap:rect3], @"rect4 and rect3 should be overlapping");
  
  PhysicsRect *rect5 = phyRectMake(100, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  PhysicsRect *rect6 = phyRectMake(500, 700, 250, 150, 100, 0, 0.1, 0.1, 0);
  STAssertFalse([rect5 testOverlap:rect6], @"rect5 and rect6 should not be overlapping");
  STAssertFalse([rect6 testOverlap:rect5], @"rect6 and rect5 should not be overlapping");
  
  PhysicsRect *rect7 = phyRectMake(100, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  PhysicsRect *rect8 = phyRectMake(500, 700, 250, 150, 100, 1, 0.1, 0.1, 0);
  STAssertFalse([rect7 testOverlap:rect8], @"rect7 and rect8 should not be overlapping");
  STAssertFalse([rect8 testOverlap:rect7], @"rect8 and rect7 should not be overlapping");

}

- (void)testGravity {
  
  PhysicsRect *rect1 = phyRectMake(290, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  [rect1 updateVelocity:[Vector2D vectorWith:0 y:0] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue(rect1.v.length == 0, @"rect 1 should have a linear velocity of 0");
  
  PhysicsRect *rect2 = phyRectMake(290, 300, 250, 150, 100, 0.5, 0.1, 0.1, 0);
  rect2.dt = kTimeStep;
  [rect2 updateVelocity:[Vector2D vectorWith:0 y:1] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue(rect2.v.length > 0, @"rect 2 should have a linear velocity greater than 0");
  
  PhysicsRect *rect3 = phyRectMake(290, 300, 250, 150, 100, 1, 0.1, 0.1, 0);
  rect3.dt = kTimeStep;
  [rect3 updateVelocity:[Vector2D vectorWith:0 y:-1] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue(rect3.v.length > 0, @"rect 3 should have a linear velocity greater than 0");
  
}

- (void)testExternalForce {
  
  PhysicsRect *rect1 = phyRectMake(290, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  [rect1 updateVelocity:[Vector2D vectorWith:0 y:0] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue(rect1.v.length == 0, @"rect 1 should have a linear velocity of 0");
  
  PhysicsRect *rect2 = phyRectMake(290, 300, 250, 150, 100, 0.5, 0.1, 0.1, 0);
  rect2.dt = kTimeStep;
  [rect2 updateVelocity:[Vector2D vectorWith:0 y:0] withForce:[Vector2D vectorWith:1 y:1]];
  STAssertTrue(rect2.v.length > 0, @"rect 2 should have a linear velocity greater than 0");
  
  PhysicsRect *rect3 = phyRectMake(290, 300, 250, 150, 100, 1, 0.1, 0.1, 0);
  rect3.dt = kTimeStep;
  [rect3 updateVelocity:[Vector2D vectorWith:0 y:0] withForce:[Vector2D vectorWith:-1 y:-1]];
  STAssertTrue(rect3.v.length > 0, @"rect 3 should have a linear velocity greater than 0");
  
}

- (void)testExternalTorque {
  
  PhysicsRect *rect1 = phyRectMake(290, 300, 250, 150, 100, 0, 0.1, 0.1, 0);
  [rect1 updateAngularVelocity:0];
  STAssertTrue(rect1.w == 0, @"rect 1 should have an angular velocity of 0");
  
  PhysicsRect *rect2 = phyRectMake(290, 300, 250, 150, 100, 0.5, 0.1, 0.1, 0);
  rect2.dt = kTimeStep;
  [rect2 updateAngularVelocity:1];
  STAssertTrue(rect2.w > 0, @"rect 2 should have an angular velocity greater than 0");
  
  PhysicsRect *rect3 = phyRectMake(290, 300, 250, 150, 100, 1, 0.1, 0.1, 0);
  rect3.dt = kTimeStep;
  [rect3 updateAngularVelocity:-1];
  STAssertTrue(rect3.w < 0, @"rect 3 should have an angular velocity greater than 0");
  
}

- (void)testApplyImpulsesWithOtherRectangles {
  
  // test rectangle colliding with a stationary object face on
  PhysicsRect *rect1 = phyRectMake(290, 110, 200, 200, 1, 0, 0.1, 0.1, 0);
  PhysicsRect *rect2 = phyRectMake(280, 300, 250, 150, 1, 0, 0.1, 0.1, 0);
  Vector2D *originalVelocity1 = [Vector2D vectorWith:rect1.v.x y:rect1.v.y];
  double originalAngularVelocity1 = rect1.w;
  Vector2D *originalVelocity2 = [Vector2D vectorWith:rect2.v.x y:rect2.v.y];
  double originalAngularVelocity2 = rect2.w;
  rect1.dt = kTimeStep;
  rect2.dt = kTimeStep;
  [rect1 updateVelocity:[Vector2D vectorWith:0 y:1000] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue([rect1 testOverlap:rect2], @"rect1 and rect2 should be overlapping");
  [rect1 applyImpulses];
  STAssertTrue(rect1.v.x != originalVelocity1.x ||
               rect1.v.y != originalVelocity1.y,
               @"rect1 should have a different linear velocity");
  STAssertTrue(rect1.w != originalAngularVelocity1,
               @"rect1 should have a different angular velocity");
  STAssertTrue(rect2.v.x != originalVelocity2.x ||
               rect2.v.y != originalVelocity2.y,
               @"rect2 should have a diferent linear velocity");
  STAssertTrue(rect2.w != originalAngularVelocity2,
               @"rect2 should have a different angular velocity");
  
  // test rectangle colliding with a stationary object at an angle
  PhysicsRect *rect3 = phyRectMake(290, 110, 200, 200, 1, 0.755, 0.1, 0.1, 0);
  PhysicsRect *rect4 = phyRectMake(280, 300, 250, 150, 1, 0, 0.1, 0.1, 0);
  Vector2D *originalVelocity3 = [Vector2D vectorWith:rect3.v.x y:rect3.v.y];
  double originalAngularVelocity3 = rect3.w;
  Vector2D *originalVelocity4 = [Vector2D vectorWith:rect4.v.x y:rect4.v.y];
  double originalAngularVelocity4 = rect4.w;
  rect3.dt = kTimeStep;
  rect4.dt = kTimeStep;
  [rect3 updateVelocity:[Vector2D vectorWith:0 y:1000] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue([rect3 testOverlap:rect4], @"rect3 and rect4 should be overlapping");
  [rect3 applyImpulses];
  STAssertTrue(rect3.v.x != originalVelocity3.x ||
               rect3.v.y != originalVelocity3.y,
               @"rect3 should have a different linear velocity");
  STAssertTrue(rect3.w != originalAngularVelocity3,
               @"rect3 should have a different angular velocity");
  STAssertTrue(rect4.v.x != originalVelocity4.x ||
               rect4.v.y != originalVelocity4.y,
               @"rect4 should have a diferent linear velocity");
  STAssertTrue(rect4.w != originalAngularVelocity4,
               @"rect4 should have a different angular velocity");
  
}

- (void)testApplyImpulsesWithWalls {
  
  // test rectangle colliding with a wall face on
  PhysicsRect *rect1 = phyRectMake(290, 110, 200, 200, 1, 0, 0.1, 0.1, 0);
  PhysicsRect *wall1 = phyRectMake(280, 300, 250, 150, INFINITY, 0, 0.1, 0.1, 0);
  Vector2D *originalVelocity1 = [Vector2D vectorWith:rect1.v.x y:rect1.v.y];
  double originalAngularVelocity1 = rect1.w;
  Vector2D *originalVelocityWall1 = [Vector2D vectorWith:wall1.v.x y:wall1.v.y];
  double originalAngularVelocityWall1 = wall1.w;
  rect1.dt = kTimeStep;
  wall1.dt = kTimeStep;
  [rect1 updateVelocity:[Vector2D vectorWith:0 y:1000] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue([rect1 testOverlap:wall1], @"rect1 and wall should be overlapping");
  [rect1 applyImpulses];
  STAssertTrue(rect1.v.x != originalVelocity1.x ||
               rect1.v.y != originalVelocity1.y,
               @"rect1 should have a different linear velocity");
  STAssertTrue(rect1.w != originalAngularVelocity1,
               @"rect1 should have a different angular velocity");
  STAssertTrue(wall1.v.x == originalVelocityWall1.x ||
               wall1.v.y == originalVelocityWall1.y,
               @"wall1 should have the same linear velocity");
  STAssertTrue(wall1.w == originalAngularVelocityWall1,
               @"wall1 should have the same angular velocity");
  
  // test rectangle colliding with a wall at an angle
  PhysicsRect *rect2 = phyRectMake(290, 110, 200, 200, 1, 0.755, 0.1, 0.1, 0);
  PhysicsRect *wall2 = phyRectMake(280, 300, 250, 150, INFINITY, 0, 0.1, 0.1, 0);
  Vector2D *originalVelocity2 = [Vector2D vectorWith:rect2.v.x y:rect2.v.y];
  double originalAngularVelocity2 = rect2.w;
  Vector2D *originalVelocityWall2 = [Vector2D vectorWith:wall2.v.x y:wall2.v.y];
  double originalAngularVelocityWall2 = wall2.w;
  rect2.dt = kTimeStep;
  wall2.dt = kTimeStep;
  [rect2 updateVelocity:[Vector2D vectorWith:0 y:1000] withForce:[Vector2D vectorWith:0 y:0]];
  STAssertTrue([rect2 testOverlap:wall2], @"rect2 and wall2 should be overlapping");
  [rect2 applyImpulses];
  STAssertTrue(rect2.v.x != originalVelocity2.x ||
               rect2.v.y != originalVelocity2.y,
               @"rect2 should have a different linear velocity");
  STAssertTrue(rect2.w != originalAngularVelocity2,
               @"rect2 should have a different angular velocity");
  STAssertTrue(wall2.v.x == originalVelocityWall2.x ||
               wall2.v.y == originalVelocityWall2.y,
               @"wall2 should have the same linear velocity");
  STAssertTrue(wall2.w == originalAngularVelocityWall2,
               @"wall2 should have the same angular velocity");
  
}

- (void)testMoveBodies {
  
  // effect of gravity on rectangle
  PhysicsRect *rect1 = phyRectMake(290, 110, 200, 200, 1, 0, 0.1, 0.1, 0);
  Vector2D *originalCenter1 = [Vector2D vectorWith:rect1.center.x y:rect1.center.y];
  rect1.dt = kTimeStep;
  [rect1 updateVelocity:[Vector2D vectorWith:0 y:1000] withForce:[Vector2D vectorWith:0 y:0]];
  [rect1 moveBodies];
  STAssertTrue(rect1.center.x != originalCenter1.x ||
               rect1.center.y != originalCenter1.y, 
               @"rect1 should not be in the original position");
  
  // effect of external force on rectangle
  PhysicsRect *rect2 = phyRectMake(290, 110, 200, 200, 1, 0, 0.1, 0.1, 0);
  Vector2D *originalCenter2 = [Vector2D vectorWith:rect2.center.x y:rect2.center.y];
  rect2.dt = kTimeStep;
  [rect2 updateVelocity:[Vector2D vectorWith:0 y:0] withForce:[Vector2D vectorWith:0 y:1000]];
  [rect2 moveBodies];
  STAssertTrue(rect2.center.x != originalCenter2.x ||
               rect2.center.y != originalCenter2.y, 
               @"rect2 should not be in the original position");

  // effect of non-head-on collision with another rectangle
  PhysicsRect *rect3 = phyRectMake(290, 110, 200, 200, 1, 0.55, 0.1, 0.1, 0);
  PhysicsRect *rect4 = phyRectMake(280, 300, 250, 150, 1, 0, 0.1, 0.1, 0);
  Vector2D *originalCenter3 = [Vector2D vectorWith:rect3.center.x y:rect3.center.y];
  double originalRotation3 = rect3.rotation;
  Vector2D *originalCenter4 = [Vector2D vectorWith:rect4.center.x y:rect4.center.y];
  double originalRotation4 = rect4.rotation;
  rect3.dt = kTimeStep;
  rect4.dt = kTimeStep;
  [rect3 updateVelocity:[Vector2D vectorWith:0 y:10000] withForce:[Vector2D vectorWith:0 y:0]];
  if ([rect3 testOverlap:rect4]) {
    [rect3 applyImpulses];
    [rect3 moveBodies];
    [rect4 moveBodies];
  }
  STAssertTrue(rect3.center.x != originalCenter3.x ||
               rect3.center.y != originalCenter3.y, 
               @"rect3 should not be in the original position");
  STAssertTrue(rect3.rotation != originalRotation3, 
               @"rect3 should not have the original rotation");
  STAssertTrue(rect4.center.x != originalCenter4.x ||
               rect4.center.y != originalCenter4.y, 
               @"rect4 should not be in the original position");
  STAssertTrue(rect4.rotation != originalRotation4, 
               @"rect4 should not have the original rotation");
  
  // effect of collision with wall on rectangle
  PhysicsRect *rect5 = phyRectMake(290, 110, 200, 200, 1, 0, 0.1, 0.1, 0);
  PhysicsRect *wall = phyRectMake(280, 300, 250, 150, INFINITY, 0, 0.1, 0.1, 0);
  Vector2D *originalCenter5 = [Vector2D vectorWith:rect5.center.x y:rect5.center.y];
  double originalRotation5 = rect5.rotation;
  Vector2D *originalWallCenter = [Vector2D vectorWith:wall.center.x y:wall.center.y];
  double originalWallRotation = wall.rotation;
  rect5.dt = kTimeStep;
  wall.dt = kTimeStep;
  [rect5 updateVelocity:[Vector2D vectorWith:0 y:10000] withForce:[Vector2D vectorWith:0 y:0]];
  if ([rect5 testOverlap:wall]) {
    [rect5 applyImpulses];
    [rect5 moveBodies];
    [wall moveBodies];
  }
  STAssertTrue(rect5.center.x != originalCenter5.x ||
               rect5.center.y != originalCenter5.y, 
               @"rect5 should not be in the original position");
  STAssertTrue(rect5.rotation != originalRotation5, 
               @"rect3 should not have the original rotation");
  STAssertTrue(wall.center.x == originalWallCenter.x ||
               wall.center.y == originalWallCenter.y, 
               @"wall should be in the original position");
  STAssertTrue(wall.rotation == originalWallRotation, 
               @"wall should have the original rotation");
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

@end
