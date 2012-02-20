//
//  GameBar.h
//  Game
//
//  Created by Yang Shun Tay on 16/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GameBar : GameObject {
  
  UIImage *barImage;
  
}

- (id)initWithFrame:(CGRect)customFrame;
- (UIImageView*)barImageView:(CGRect)frame;

@property (nonatomic, strong) UIImage* barImage;

@end
