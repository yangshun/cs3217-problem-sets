//
//  DesignViewController.h
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"

#import "FileDataController.h"
#import "PlayViewController.h"

#define START 1
#define SAVE 2
#define LOAD 3
#define RESET 4

@interface DesignViewController : UIViewController <UIAlertViewDelegate> {
  
  UIImageView* palette;
  
  GameWolf *wolfController;
  GamePig *pigController;
  GameBlock *blockController;
  
  GameObject *newObject;
  NSMutableArray *blocksInGameArea;
  FileDataController *fileDataManager;
  PlayViewController *playView;
  
  UIButton *backButton;
  UIButton *startButton;
  UIButton *resetButton;
  UIButton *loadButton;
  UIButton *saveButton;
}

- (void)setUpPalette;
  // MODIFIES: subviews in palette view
  // REQUIRES: wolfController, pigController and blockController to be nil
  // EFFECTS: game objects are added to palette  

- (void)scrollViewDisabled;
  // MODIFIES: scrolling ability of scrollview
  // REQUIRES: GameObject to be in panning mode
  // EFFECTS: disables the scrolling ability of gamearea

- (void)scrollViewEnabled;
  // MODIFIES: scrolling ability of scrollview
  // REQUIRES: GameObject to have ended panning mode
  // EFFECTS: enables the scrolling ability of gamearea

- (void)dropView:(GameObject*)viewCaller;
  // MODIFIES: gamearea scrollview
  // REQUIRES: GameObject to be out of the palette 
  // EFFECTS: transfers from view from the palette to the point of release in gamearea

- (void)setUpPalette;
  // MODIFIES: subviews in palette view
  // REQUIRES: wolfController, pigController and blockController to be nil
  // EFFECTS: game objects are added to palette

- (void)clearAllObjectsFromView;
  // MODIFIES: all GameObjects
  // EFFECTS: removes all GameObject from both gamearea and palette

- (void)backToMainScreen;
  // EFFECTS: returns to the level designer

- (void)proceedToSaveLevel;
  // MODIFIES: save data
  // EFFECTS: properties of all the GameObject controllers are saved in FileDataController object

@property (nonatomic, weak) IBOutlet UIImageView *taskbar;
@property (nonatomic, weak) IBOutlet UITextField *levelName;
@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;
@property (nonatomic, strong) IBOutlet UIImageView *palette;

@end
