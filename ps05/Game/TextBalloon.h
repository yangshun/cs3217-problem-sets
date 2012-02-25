//
//  TextBalloon.h
//  Game
//
//  Created by Yang Shun Tay on 22/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {kOuchMessage, kAhhhMessage, kHeeheeMessage, 
  kHowlMessage, kMwhahaMessage} MessageType;

@interface TextBalloon : UIImageView {
  
  UIImage *ouchImage;
  UIImage *ahhhImage;
  UIImage *heeheeImage;
  UIImage *howlImage;
  UIImage *mwhahaImage;
}

- (void)displayBalloonAtLocation:(CGPoint)location andType:(MessageType)type;
- (void)removeFromView;

@property (nonatomic, readwrite) BOOL onScreen;

@end
