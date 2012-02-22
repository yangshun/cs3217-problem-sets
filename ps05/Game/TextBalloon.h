//
//  TextBalloon.h
//  Game
//
//  Created by Yang Shun Tay on 22/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {kOuchMessage, kAhhhMessage, kHowlMessage} messageType;

@interface TextBalloon : UIViewController {
  
  UIImageView *textImageView;
  UIImage *textImage;
  BOOL onScreen;
}

- (id)initAtPoint:(CGPoint)location andType:(messageType)type; 

@property (nonatomic, readwrite) BOOL onScreen;

@end
