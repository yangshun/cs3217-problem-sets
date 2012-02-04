//
//  GamePig.h
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GamePig : GameObject

- (id)initWithFrame:(CGRect)customFrame andState:(BOOL)state;
- (UIImageView*)pigImageView:(CGRect)frame;
- (CGRect)frameInGameArea:(CGPoint)point;

@end
