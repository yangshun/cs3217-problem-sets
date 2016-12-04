//
//  GameBar.h
//  Game
//
//  Created by Yang Shun Tay on 16/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

#define kMaxBarPosition 380
#define kMinBarPosition 138

@interface GameBar : GameObject {
  
  UIImage *barImage;
}

- (id)initWithFrame:(CGRect)customFrame;
  // EFFECTS: object will appear at bottom at specified frame

- (UIImageView*)barImageView:(CGRect)frame;
  // EFFECTS: returns a bar image view of the correct position and size

- (void)translate:(UIPanGestureRecognizer *)gesture;
  // MODIFIES: self (game object)
  // REQUIRES: a pan gesture to be recognized
  // EFFECTS: modifies the length of the bar
  
@property (nonatomic, strong) UIImage* barImage;

@end
