//
//  GameArrow.h
//  Game
//
//  Created by Yang Shun Tay on 16/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GameArrow : GameObject {
  UIImage *arrowImage;
  UIImage *selectedArrowImage;
}

- (id)initWithFrame:(CGRect)customFrame;
- (UIImageView*)arrowImageView:(CGRect)frame;
- (void)translate:(UIPanGestureRecognizer *)gesture;
  // MODIFIES: self (game object)
  // REQUIRES: a pan gesture to be recognized
  // EFFECTS: modifies the angle of the arrow

@property (nonatomic, strong) UIImage* arrowImage;

@end
