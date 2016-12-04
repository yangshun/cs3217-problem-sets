//
//  PhysicsRectTest.h
//  PhysicsRectTest
//
//  Created by Yang Shun Tay on 12/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PhysicsRect.h"

@interface PhysicsRectTest : SenTestCase 

PhysicsRect* phyRectMake(double x, double y, double width, double height, 
                         double mass, double rotation, double friction, 
                         double restitution, int index);

@end
