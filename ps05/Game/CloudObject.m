//
//  CloudObject.m
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "CloudObject.h"

@implementation CloudObject 
@synthesize speed;

- (id)initWithImage:(UIImage*)cloudImage 
           andSpeed:(double)cloudSpeed
           andFrame:(CGRect)cloudFrame
           andScale:(double)scale {
  // EFFECTS: a cloud object is initialized with the given attributes  
  self = [super init];
  if (self) {
    speed = cloudSpeed;
    self.image = cloudImage;
    self.frame = CGRectMake(cloudFrame.origin.x, 
                            cloudFrame.origin.y, 
                            cloudFrame.size.width * scale, 
                            cloudFrame.size.height * scale);
  }
  return self;
}


@end
