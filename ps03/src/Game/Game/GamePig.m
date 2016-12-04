//
//  GamePig.m
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GamePig.h"

@implementation GamePig

- (id)init {
  // default initializer
  // object will appear in palette
  self = [super initWithObject:[self pigImageView:CGRectMake(190, 50, 55, 55)]];
  
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(217.5, 77.5);
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
           andState:(BOOL)state {
  // custom initializer
  // object will appear in gamearea at specified frame and rotation
  self = [super initWithObject:[self pigImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(217.5, 77.5);
    insideGameArea = state;
    if (insideGameArea) {
      [self customRotation:rotation];
    }
  }
  
  return self;
}



- (UIImageView*)pigImageView:(CGRect)frame {
  // returns an UIImageView of this GameObject subclass at the specified position
  // TA: No magic string.
  UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
  UIImageView *gamePigImageView = [[UIImageView alloc]initWithImage:pigImage];
  gamePigImageView.frame = frame;
  return gamePigImageView;
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x - 15, point.y + 10, 88, 88);
  // Prof: magic numbers here. 
}

@end
