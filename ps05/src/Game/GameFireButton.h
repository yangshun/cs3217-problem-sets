//
//  GameFireButton.h
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GameFireButton : GameObject {

  UIImage *buttonImage;
  UIImage *buttonImagePressed;
  UITapGestureRecognizer *objSingleTap;
}

- (id)initWithFrame:(CGRect)customFrame;
  // EFFECTS: object will appear at specified frame

- (UIImageView*)buttonImageView:(CGRect)frame;
  // EFFECTS: returns an UIImageView of this GameObject subclass at the specified position

- (void)pressed:(UITapGestureRecognizer*)gesture;
  // MODIFIES: play view controller
  // REQUIRES: the button to be pressed
  // EFFECTS: fires a projectile from the wolf's mouth

- (void)changeState;
  // MODIFIES: button image of self
  // EFFECTS: changes the button image, according to the current state

@property (nonatomic, strong) UIImage* buttonImage;


@end
