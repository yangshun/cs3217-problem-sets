//
//  GameWolf.m
//  Game
//
//  Created by Yang Shun Tay on 28/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameWolf.h"

@implementation GameWolf

@synthesize wolfImage;

- (id)init {
  // default initializer
  // object will appear in palette
  self = [super initWithObject:[self wolfImageView:CGRectMake(20, 20, 150, 100)]];
  
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(95, 70);
  }
  return self;
}
   
- (id)initWithFrame:(CGRect)customFrame andState:(BOOL)state {
  // custom initializer
  // object will appear in gamearea at specified frame
  self = [super initWithObject:[self wolfImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(95, 70);
    insideGameArea = state;
  }
  return self;
}

- (UIImageView*)wolfImageView:(CGRect)frame {
  // returns an UIImageView of this GameObject subclass at the specified position
  wolfImage = [UIImage imageNamed:@"wolfs.png"];
  CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfImage CGImage], 
                                                         CGRectMake(0, 0, 225, 150));
  UIImage *croppedWolfImage =[UIImage imageWithCGImage:wolfImageRef];
  UIImageView *wolfImageView = [[UIImageView alloc]initWithImage:croppedWolfImage];
  wolfImageView.frame = frame;
  return wolfImageView;
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x - 35, point.y - 10, 225, 150);
}

@end
