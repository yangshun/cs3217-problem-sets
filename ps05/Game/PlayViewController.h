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
  CloudFactory *cloudGenerator;
  
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
- (PhysicsRect*)createPhysicsObjectFromGameObject:(GameObject*)obj;
- (void)setUpGamearea;
- (void)initializeTimer;
- (void)toggleShootingGuide;
- (void)addBreatheProjectile;
- (void)removeGameObject:(GameObject*)obj;
- (void)victory;
- (void)gameOver;
- (void)fadeMusic;

@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;


@end
