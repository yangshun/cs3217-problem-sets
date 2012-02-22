//
//  PlayViewController.h
//  Game
//
//  Created by Yang Shun Tay on 19/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "GameBar.h"
#import "GameArrow.h"
#import "GameBreathe.h"
#import "GameFireButton.h"
#import "PhysicsWorld.h"
#import "TextAnimation.h"
#import "TextBalloon.h"

@interface PlayViewController : UIViewController {
  
  GameWolf *wolfController;
  GamePig *pigController;
  GameArrow *arrowController;
  GameBar *barController;
  GameBreathe *breatheController;
  UIImageView *directionDegree;
  UIImageView *powerBoard;
  GameFireButton *fireButtonController;
  NSMutableArray *objectsInGameArea;
  
  TextBalloon *balloon;
  
  PhysicsWorld *gameareaWorld;
  NSArray *wallRectArray;
  NSMutableArray *physicsObjectArray;
  NSTimer *gameareaTimer;
  double gameareaTimeStep;
  
  NSTimer *breatheTimer;
  
}

- (id)initWithWolf:(GameWolf*)wolf 
               Pig:(GamePig*)pig 
            Blocks:(NSMutableArray*)blocks;
- (void)setUpGamearea;
- (void)initializeTimer;
- (void)toggleShootingGuide;
- (void)addBreatheProjectile;
- (void)removeGameObject:(GameObject*)obj;

@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;


@end
