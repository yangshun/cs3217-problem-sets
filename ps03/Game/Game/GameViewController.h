//
//  GameViewController.h
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "FileDataController.h"

#define START 1
#define SAVE 2
#define LOAD 3
#define RESET 4

@interface GameViewController : UIViewController <UIAlertViewDelegate> {
  
  UIImageView* palette;

  GameWolf* wolfController;
  GamePig* pigController;
  GameBlock* blockController;
  GameObject* newObject;
  NSMutableArray* blocksInGameArea;
  FileDataController* fileDataManager;
}

- (IBAction)buttonPressed:(id)sender;
- (void)dropView:(GameObject*)viewCall;
- (void)setUpPalette;

@property (nonatomic, weak) IBOutlet UITextField *levelName;
@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;
@property (nonatomic, strong) IBOutlet UIImageView *palette;

@end
