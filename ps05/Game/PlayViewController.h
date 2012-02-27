//
//  PlayViewController.h
//  Game
//
//  Created by Yang Shun Tay on 19/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "GameBar.h"
#import "GameArrow.h"
#import "GameBreathe.h"
#import "GameFireButton.h"
#import "WolfLives.h"
#import "PhysicsWorld.h"
#import "TextBalloon.h"
#import "CloudFactory.h"

typedef enum {kOutcomeUndetermined, kOutcomeVictory, kOutcomeLose} GameOutcome;

@interface PlayViewController : UIViewController <AVAudioPlayerDelegate> {
  
  UIImageView *scoreboard;
  WolfLives *livesBoard;
  UIButton *backButton;
  UIButton *miniBackButton;
  
  GameWolf *wolfController;
  GamePig *pigController;
  GameArrow *arrowController;
  GameBar *barController;
  GameBreathe *breatheController;
  UIImageView *directionDegree;
  UIImageView *powerBoard;
  GameFireButton *fireButtonController;
  UIImageView *windSuck;
  NSMutableArray *windSuckSprite;
  NSMutableArray *objectsInGameArea;
  
  TextBalloon *textBalloon;
  
  PhysicsWorld *gameareaWorld;
  NSArray *wallRectArray;
  NSMutableArray *physicsObjectArray;
  NSTimer *gameareaTimer;
  double gameareaTimeStep;
  
  NSTimer *breatheTimer;
  GameOutcome outcome;
  
  AVAudioPlayer *audioPlayer;
}

- (id)initWithWolf:(GameWolf*)wolf 
               Pig:(GamePig*)pig 
            Blocks:(NSMutableArray*)blocks;
  // EFFECTS: initializes the view controller with the wolf, pig and blocks

- (PhysicsRect*)createPhysicsObjectFromGameObject:(GameObject*)obj;
  // REQUIRES: obj = nil
  // EFFECTS: returns a physics model of the game object

- (void)setUpGamearea;
  // MODIFIES: self (game area)
  // REQUIRES: view to be loaded
  // EFFECTS: the game area is set up with the necessary buttons and views

- (void)initializeTimer;
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateWorldTime method of PhysicsWorld

- (void)updateWorldTime;
  // MODIFIES: state of the objects in the PhysicsWorld
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld

- (void)updateViewObjectPositions:(NSNotification*)notification;
  // MODIFIES: position of view objects
  // REQUIRES: the PhysicsWorld to be initialized
  // EFFECTS: changes the position of the object views according to its 
  //          position in the physics world

- (void)toggleShootingGuide;
  // MODIFIES: view of arrow and direction degree
  // EFFECTS: makes it appear/hidden

- (void)fireButtonPressed;
  // MODIFIES: view
  // EFFECTS: button image changed
  //          wolf shoots projectile

- (void)addBreatheProjectile;
  // MODIFIES: view
  // EFFECTS: GameBreathe object is created and shot out from the wolf's mouth

- (void)removeGameObject:(GameObject*)obj;
  // MODIFIES: game object
  // EFFECTS: game object (physics and view) is removed from the view controller

- (void)victory;
  // EFFECTS: victory message displayed
  //          the powerboard is removed and user can go back to the previous screen

- (void)gameOver;
  // EFFECTS: game over message displayed
  //          the powerboard is removed and user can go back to the previous screen

- (void)backToPreviousScreen;
  // EFFECTS: returns to the view before this view was loaded

- (void)fadeMusic;
  // MODIFIES: background music
  // REQUIRES: view to be removed
  // EFFECTS: background music volume lowered

@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;


@end
