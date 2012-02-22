//
//  TextAnimation.h
//  Game
//
//  Created by Yang Shun Tay on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAnimation : UIImageView {
  
  UIImage *startText;
  NSTimer *textTimer;
}

- (void)flyInStartText;
- (void)flyOutStartText;
- (void)pauseTimer;
- (void)endTimer;
- (void)flyAcrossText;

@end
