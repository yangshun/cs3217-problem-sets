//
//  CloudObject.h
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CloudObject : UIImageView {
  
  int speed;
}

- (id)initWithImage:(UIImage*)cloudImage 
           andSpeed:(int)cloudSpeed
           andFrame:(CGRect)cloudFrame
           andScale:(double)scale;

@property (nonatomic, readonly) int speed;

@end
