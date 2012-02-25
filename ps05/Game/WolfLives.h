//
//  WolfLives.h
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WolfLives : UIViewController {
  
  int lives;
  UIImage *heartImage;
  NSMutableArray *livesCount;
}

- (id)initWithLives:(int)number;
- (void)displayLives;
- (void)deductLife;

@end
