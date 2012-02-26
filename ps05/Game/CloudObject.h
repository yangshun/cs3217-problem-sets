//
//  CloudObject.h
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudObject : UIImageView {
  double speed;
}

- (id)initWithImage:(UIImage*)cloudImage 
           andSpeed:(double)cloudSpeed
           andFrame:(CGRect)cloudFrame
           andScale:(double)scale;
  // EFFECTS: a cloud object is initialized with the given attributes

@property (nonatomic, readonly) double speed;

@end
