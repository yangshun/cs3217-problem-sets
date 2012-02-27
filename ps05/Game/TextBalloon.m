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

- (id)init {
  
  self = [super init];
  if (self) {
    ouchImage = [UIImage imageNamed:@"text-ouch.png"];
    ahhhImage = [UIImage imageNamed:@"text-ahhh.png"];
    heeheeImage = [UIImage imageNamed:@"text-heehee.png"];
    howlImage = [UIImage imageNamed:@"text-howl.png"];
    mwhahaImage = [UIImage imageNamed:@"text-mwhaha.png"];
    imageWidth = ouchImage.size.width * 0.75;
    imageHeight = ouchImage.size.height * 0.75;
  }
  return self;
}

- (void)displayBalloonAtLocation:(CGPoint)location andType:(MessageType)type {
  // MODIFIES: view controller containing this view
  // REQUIRIES: type != nil
  // EFFECTS: a popup balloon image containing a message is displayed
  CGRect frame = CGRectMake(location.x + kOffsetX, 
                            location.y + kOffsetY, 
                            imageWidth, 
                            imageHeight);
  
  UIImage *displayImage;
  
  switch (type) {
    case kOuchMessage:
      displayImage = ouchImage;
      break;
    case kAhhhMessage:
      displayImage = ahhhImage;
      break;
    case kHeeheeMessage:
      displayImage = heeheeImage;
      break;
    case kHowlMessage:
      displayImage = howlImage;
      break;
    case kMwhahaMessage:
      displayImage = mwhahaImage;
    default:
      break;
  }
  
  self.image = displayImage;
  self.frame = frame;
}

- (void)removeFromView {
  // MODIFIES: view controller containing this view
  // EFFECTS: removes the text balloon from its superview
  [self removeFromSuperview];
}

@end
