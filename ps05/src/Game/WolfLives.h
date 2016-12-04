//
//  WolfLives.h
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeartStartingPositionX 218
#define kHeartStartingPositionY 131
#define kDistanceBetweenHearts 10

@interface WolfLives : UIViewController {
  
  int lives;
  UIImage *heartImage;
  NSMutableArray *livesCount;
}

- (id)initWithLives:(int)number;
  // EFFECTS: initializes the lives of the wolf depending on the parameter value

- (void)displayLives;
  // MODIFIES: view
  // EFFECTS: view to display the number of hearts corresponding to the number of lives left

- (void)deductLife;
  // MODIFIES: self (number of lives)
  // REQUIRIES: wolf to have shot a breathe
  // EFFECTS: number of lives of wolf is reduced by one

@end
