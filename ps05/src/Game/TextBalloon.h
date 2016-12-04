//
//  TextBalloon.h
//  Game
//
//  Created by Yang Shun Tay on 22/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOffsetX 30
#define kOffsetY -180

typedef enum {kOuchMessage, kAhhhMessage, kHeeheeMessage, 
  kHowlMessage, kMwhahaMessage} MessageType;

@interface TextBalloon : UIImageView {
  
  UIImage *ouchImage;
  UIImage *ahhhImage;
  UIImage *heeheeImage;
  UIImage *howlImage;
  UIImage *mwhahaImage;
  CGFloat imageWidth;
  CGFloat imageHeight;
}

- (void)displayBalloonAtLocation:(CGPoint)location andType:(MessageType)type;
  // MODIFIES: view controller containing this view
  // REQUIRIES: type != nil
  // EFFECTS: a popup balloon image containing a message is displayed

- (void)removeFromView;
  // MODIFIES: view controller containing this view
  // EFFECTS: removes the text balloon from its superview

@property (nonatomic, readwrite) BOOL onScreen;

@end
