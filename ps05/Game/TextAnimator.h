//
//  TextAnimator.h
//  Game
//
//  Created by Yang Shun Tay on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {kHuffAndPuff, kVictory, kGameOver} TextType;

@interface TextAnimator : UIImageView {
  
  UIImage *startText;
  UIImage *victoryText;
  UIImage *gameOverText;
  
  NSTimer *textTimer;
}

- (void)animateZoomScreenAcrossWithPause:(TextType)type;
- (void)animatePauseAtMiddleOfScreen:(TextType)type;
- (UIImage*)selectImage:(TextType)type;
- (void)flyInStartText;
- (void)flyOutStartText;
- (void)pauseTimer;
- (void)endTimer;
- (void)flyAcrossText;

@end
