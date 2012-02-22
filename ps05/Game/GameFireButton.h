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
- (UIImageView*)buttonImageView:(CGRect)frame;
- (void)pressed:(UITapGestureRecognizer*)gesture;

@property (nonatomic, strong) UIImage* buttonImage;


@end
