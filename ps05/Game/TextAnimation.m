//
//  TextAnimation.m
//  Game
//
//  Created by Yang Shun Tay on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "TextAnimation.h"

@implementation TextAnimation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      startText = [UIImage imageNamed:@"huff-and-puff-away"];
      self.image = startText;
    }
    return self;
}

- (void)showStartText {
  
  
  
}

@end
