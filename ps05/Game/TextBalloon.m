//
//  TextBalloon.m
//  Game
//
//  Created by Yang Shun Tay on 22/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "TextBalloon.h"

@implementation TextBalloon

@synthesize onScreen;

- (id)initAtPoint:(CGPoint)location andType:(messageType)type {
  
  CGRect frame = CGRectMake(location.x + 30, location.y - 180, 200, 133);
  self = [super init];
  if (self) {
    switch (type) {
      case kOuchMessage:
        textImage = [UIImage imageNamed:@"text-ouch.png"];
        break;
      case kAhhhMessage:
        textImage = [UIImage imageNamed:@"text-ahhh.png"];
        break;
      case kHowlMessage:
        textImage = [UIImage imageNamed:@"text-howl.png"];
        break;
      default:
        break;
    }
    
    textImageView = [[UIImageView alloc] initWithImage:textImage];
    textImageView.frame = frame;
    self.view = textImageView;
    onScreen = NO;
  }
  return self;
}

@end
