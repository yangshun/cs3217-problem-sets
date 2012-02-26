//
//  PlayViewController.m
//  Game
//
//  Created by Yang Shun Tay on 19/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PlayViewController.h"

@implementation PlayViewController

@synthesize gamearea;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (id)initWithWolf:(GameWolf*)wolf Pig:(GamePig*)pig Blocks:(NSMutableArray*)blocks
{
  self = [super init];
  if (self) {
    wolfController = [[GameWolf alloc] initWithFrame:wolf.view.frame 
                                         andRotation:wolf.rotatedState 
                                            andState:wolf.insideGameArea];
    
    pigController = [[GamePig alloc] initWithFrame:pig.view.frame
                                       andRotation:pig.rotatedState
                                          andState:pig.insideGameArea];
   
    objectsInGameArea = [[NSMutableArray alloc] init];
    
    for (GameBlock* block in blocks) {
      [block customRotation:-block.rotatedState];   
      CGRect tempBlockFrame = block.view.frame;
      CGFloat tempBlockRotation = block.rotatedState;
      blockObjectType tempBlockType = block.blockType;


      GameBlock *tempBlock = [[GameBlock alloc] initWithFrame:tempBlockFrame 
                                                  andRotation:tempBlockRotation 
                                                 andBlockType:tempBlockType];
      [block customRotation:block.rotatedState];
      [objectsInGameArea addObject:tempBlock];
    }
    
    [objectsInGameArea addObject:pigController];
    [objectsInGameArea addObject:wolfController];
  }

  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
      NSLog(@"play view sucks");
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // Do any additional setup after loading the view, typically from a nib.
  UIImage *bgImage = [UIImage imageNamed:@"background.png"];
  UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
  UIImage *scoreboardImage = [UIImage imageNamed:@"scoreboard.png"];
  
  // Get the width and height of the two images
  CGFloat backgroundWidth = bgImage.size.width;
  CGFloat backgroundHeight = bgImage.size.height;
  CGFloat groundWidth = groundImage.size.width;
  CGFloat groundHeight = groundImage.size.height;
  CGFloat scoreboardWidth = scoreboardImage.size.width;
  CGFloat scoreboardHeight = scoreboardImage.size.height;
  
  // Place each of them in an UIImageView
  UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
  UIImageView *ground = [[UIImageView alloc] initWithImage:groundImage];
  scoreboard = [[UIImageView alloc] initWithImage:scoreboardImage];
  
  CGFloat groundY = gamearea.frame.size.height - groundHeight;
  CGFloat backgroundY = groundY - backgroundHeight;
  CGFloat scoreboardY = 0;
  
  // The frame property holds the position and size of the views
  // The CGRectMake methods arguments are : x position, y position, width,
  // height. origin at top left hand corner, with positive y-axis downwards
  background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
  ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
  scoreboard.frame = CGRectMake(0, scoreboardY, scoreboardWidth, scoreboardHeight);
  scoreboard.userInteractionEnabled = YES;
  [self.view addSubview:scoreboard];
  
  livesBoard = [[WolfLives alloc] initWithLives:5];
  [livesBoard displayLives];
  [scoreboard addSubview:livesBoard.view];
  
  miniBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
  miniBackButton.frame = CGRectMake(25, 20, 80, 39);
  [miniBackButton addTarget:self 
                     action:@selector(backToLevelDesigner) 
           forControlEvents:UIControlEventTouchUpInside];
  miniBackButton.backgroundColor = [UIColor clearColor];
  UIImage *miniBackButtonImage = [UIImage imageNamed:@"button-back.png"];
  [miniBackButton setImage:miniBackButtonImage forState:UIControlStateNormal];
  [scoreboard addSubview:miniBackButton];
  
  // Add these views as subviews of the gamearea.
  [gamearea addSubview:background];
  [gamearea addSubview:ground];

  // Set the content size so that gamearea is scrollable
  // otherwise it defaults to the current window size
  CGFloat gameareaHeight = backgroundHeight + groundHeight;
  CGFloat gameareaWidth = backgroundWidth;
  [gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
  
  cloudGenerator = [[CloudFactory alloc] initWithTimeStep:0.02];
  [gamearea addSubview:cloudGenerator.view];
  [cloudGenerator startGeneratingClouds];
  
  physicsObjectArray = [[NSMutableArray alloc] init];
  
  for (GameObject *obj in objectsInGameArea) {
    [obj customRotation:-obj.rotatedState];
    [physicsObjectArray addObject:[self createPhysicsObjectFromGameObject:obj]];               
    [obj customRotation:obj.rotatedState];
    [obj removeAllGestureRecognizers];
    [gamearea addSubview:obj.view];
  }
  
  pigController.objectState = kPreGameStart;
  
  CGPoint newGroundOrigin = CGPointMake(ground.frame.origin.x, ground.frame.origin.y);
  PhysicsRect *wallGround = [[PhysicsRect alloc] initWithOrigin:newGroundOrigin
                                                       andWidth:groundWidth
                                                      andHeight:groundHeight
                                                        andMass:INFINITY
                                                  andRotation:0 
                                                    andFriction:5
                                                 andRestitution:0
                                                        andView:nil];
  wallRectArray = [[NSArray alloc] initWithObjects:wallGround, nil];
  
  gameareaTimeStep = 1.0f / 100.0f;
  gameareaWorld = [[PhysicsWorld alloc] initWithObjects:physicsObjectArray
                                               andWalls:wallRectArray 
                                             andGravity:[Vector2D vectorWith:0 y:400]
                                            andTimeStep:gameareaTimeStep];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateViewObjectPositions:) 
                                               name:@"MoveBodies"
                                             object:nil];
  
  [self initializeTimer];
  textBalloon = [[TextBalloon alloc] init];
  
  UIImage *startText = [UIImage imageNamed:@"text-huff-and-puff-away.png"];
  UIImageView *startTextView = [[UIImageView alloc] initWithImage:startText];
  
  startTextView.frame = CGRectMake(-920, 375, 477, 28);
  [self.view addSubview:startTextView];
  
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut 
                   animations:^{ 
                     startTextView.center = CGPointMake(512, 389);
                   } 
                   completion:^(BOOL finished){
                                        
  [UIView animateWithDuration:0.5
                        delay:1.0
                      options:UIViewAnimationOptionCurveEaseIn 
                   animations:^{ 
                     startTextView.frame = CGRectMake(1024, 375, 477, 28);
                   } 
                  completion:^(BOOL finished){}];
                     
                   }];

  [self performSelector:@selector(setUpGamearea) withObject:nil afterDelay:2.0];
  outcome = kOutcomeUndetermined;
  
  backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, 200, 100);
  [backButton addTarget:self 
                 action:@selector(backToLevelDesigner) 
       forControlEvents:UIControlEventTouchUpInside];
  backButton.backgroundColor = [UIColor clearColor];
  UIImage *backButtonImage = [UIImage imageNamed:@"button-back-pink.png"];
  [backButton setImage:backButtonImage forState:UIControlStateNormal];
  backButton.center = CGPointMake(512, 926);
}

- (PhysicsRect*)createPhysicsObjectFromGameObject:(GameObject*)obj {
  
  double mass = 0, friction = 0, restitution = 0;
  
  switch (obj.objectType) {
    case kGameObjectWolf:
      mass = 500;
      friction = 0.9;
      break;
    case kGameObjectPig:
      mass = 200;
      friction = 0.6;
      break;
    case kGameObjectBlock:
      switch (((GameBlock*)obj).blockType) {
        case kStrawBlockObject:
          mass = 100;
          friction = 1.2;
          restitution = 0.1;
          break;
        case kWoodBlockObject:
          mass = 300;
          friction = 2.3;
          restitution = 0.5;
        case kIronBlockObject:
          mass = 500;
          friction = 3.4;
          restitution = 0.7;
        case kStoneBlockObject:
          mass = 1000;
          friction = 4.5;
          restitution = 1.0;
        default:
          break;
      }
      break;
    default:
      break;
  }
  
  PhysicsRect *physicsObject = [[PhysicsRect alloc] initWithOrigin:obj.view.frame.origin
                                                          andWidth:obj.view.frame.size.width
                                                         andHeight:obj.view.frame.size.height
                                                           andMass:mass
                                                       andRotation:obj.rotatedState
                                                       andFriction:friction
                                                    andRestitution:restitution
                                                           andView:nil];  
  return physicsObject;
}

- (void)setUpGamearea {
  
  CGRect arrowFrame = CGRectMake(wolfController.view.center.x + 60, 
                                 wolfController.view.center.y - 260,
                                 74, 430);
  arrowController = [[GameArrow alloc] initWithFrame:arrowFrame];
  arrowController.view = arrowController.gameObjView;
  
  UIImage *degreeImage = [UIImage imageNamed:@"direction-degree.png"];
  directionDegree = [[UIImageView alloc] initWithImage:degreeImage];
  directionDegree.frame = CGRectMake(wolfController.view.center.x + 80, 
                                     wolfController.view.center.y - 260,
                                     233, 408);
  
  UIImage *powerBoardImage = [UIImage imageNamed:@"power-board.png"];
  powerBoard = [[UIImageView alloc] initWithImage:powerBoardImage];
  powerBoard.frame = CGRectMake(15, 650, 400, 86);
  powerBoard.userInteractionEnabled = YES;
  
  CGRect barFrame = CGRectMake(128, 17, 172, 26);
  barController = [[GameBar alloc] initWithFrame:barFrame];
  barController.view = barController.gameObjView;
  
  CGRect fireButtonFrame = CGRectMake(332, 48, 50, 25);
  fireButtonController = [[GameFireButton alloc] initWithFrame:fireButtonFrame];
  fireButtonController.view = fireButtonController.gameObjView;
  fireButtonController.delegate = self;
  
  UIImage *windSuckImage = [UIImage imageNamed:@"windsuck.png"];
  windSuckSprite = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 8; i++) {
    CGRect spriteFrame = CGRectMake(150 * (i % 4), 144 * (i / 4), 150, 144);
    CGImageRef windImageRef = CGImageCreateWithImageInRect([windSuckImage CGImage], spriteFrame);
    UIImage *croppedWind = [UIImage imageWithCGImage:windImageRef];
    [windSuckSprite addObject:croppedWind];
  }
  
  windSuck = [[UIImageView alloc] initWithImage: [windSuckSprite objectAtIndex:0]];
  windSuck.animationImages = windSuckSprite;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleObjectObjectCollisions:) 
                                               name:@"ObjectObjectCollision"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleObjectWallCollisions:) 
                                               name:@"ObjectWallCollision"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(fireButtonPressed) 
                                               name:@"FireButtonPressed"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleShootingGuide) 
                                               name:@"ToggleShootingGuide"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(addBreatheProjectile) 
                                               name:@"ShootProjectile"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(gameOver) 
                                               name:@"GameOver"
                                             object:nil];
  
  pigController.objectState = kGameAlive;
  pigController.responseState = kAwaitingEvent;
  wolfController.objectState = kGameAlive;
  
  [gamearea addSubview:directionDegree];
  [gamearea addSubview:arrowController.view];
  [self.view addSubview:powerBoard];
  [powerBoard addSubview:barController.view];
  [powerBoard addSubview:fireButtonController.view];
}

- (void)initializeTimer {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  gameareaTimer = [NSTimer scheduledTimerWithTimeInterval:gameareaTimeStep 
                                                   target:self 
                                                 selector:@selector(updateWorldTime) 
                                                 userInfo:nil 
                                                  repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:gameareaTimer forMode:NSRunLoopCommonModes];
}

- (void)updateWorldTime {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  [gameareaWorld updateBlocksState];
}

- (void)updateViewObjectPositions:(NSNotification*)notification {
  // MODIFIES: position of view objects
  // EFFECTS: changes the position of the object views according to its 
  //          position in the physics world
  NSArray *physicsWorldBlocks = [notification object];
  for (int i = 0; i < [physicsWorldBlocks count]; i++) {
    PhysicsShape *thisBlock = [physicsWorldBlocks objectAtIndex:i];
    GameObject *thisObject = [objectsInGameArea objectAtIndex:i];
    thisObject.view.center = CGPointMake(thisBlock.center.x, thisBlock.center.y);
    [thisObject customRotationByCollision:(thisBlock.rotation - thisObject.rotatedState)];
  }
}

- (void)handleObjectObjectCollisions:(NSNotification*)notification {
  
  NSArray *objectIndices = [notification object];
  int index1 = [[objectIndices objectAtIndex:0] intValue];
  int index2 = [[objectIndices objectAtIndex:1] intValue];
  
  if (([[objectsInGameArea objectAtIndex:index1] isKindOfClass:[GameBreathe class]] &&
       [[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GamePig class]]) ||
      ([[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GameBreathe class]] &&
       [[objectsInGameArea objectAtIndex:index1] isKindOfClass:[GamePig class]])) {
        if (pigController.objectState == kGameAlive) {
          pigController.objectState = kGameDead;
          [textBalloon displayBalloonAtLocation:pigController.view.center andType:kAhhhMessage];
          [gamearea addSubview:textBalloon];
          [textBalloon performSelector:@selector(removeFromView) 
                            withObject:nil afterDelay:1];
          [breatheController breatheDisperseAnimation];
          [self performSelector:@selector(removeGameObject:) 
                     withObject:breatheController afterDelay:1.5];
          [pigController pigDieAnimation];
          [self performSelector:@selector(victory) withObject:nil afterDelay:1.5];
          return;
        }
      } 
  
  if ([[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GameBreathe class]] &&
      [[objectsInGameArea objectAtIndex:index1] isKindOfClass:[GameBlock class]]) {
    if (((GameBlock*)[objectsInGameArea objectAtIndex:index1]).blockType == kStrawBlockObject) {
      ((PhysicsCircle*)[physicsObjectArray objectAtIndex:index2]).v = 
      [((PhysicsCircle*)[physicsObjectArray objectAtIndex:index2]).v multiply:0.5];
      [[objectsInGameArea objectAtIndex:index1] strawBreakAnimation];
      [self performSelector:@selector(removeGameObject:) 
                 withObject:[objectsInGameArea objectAtIndex:index1] 
                 afterDelay:1.5];
    } else {
      [breatheController breatheDisperseAnimation];
      [self performSelector:@selector(removeGameObject:) withObject:breatheController afterDelay:1.5];
    }
    return;
  }
  
  if (([[objectsInGameArea objectAtIndex:index1] isKindOfClass:[GameBlock class]] &&
       [[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GamePig class]]) ||
      ([[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GameBlock class]] &&
       [[objectsInGameArea objectAtIndex:index1] isKindOfClass:[GamePig class]])) {
    if ([[objectsInGameArea objectAtIndex:index2] isKindOfClass:[GameBlock class]]) {
      // to ensure index1 refers to GameBlock
      int temp = index1;
      index1 = index2;
      index2 = temp;
    }
    if (((GameBlock*)[objectsInGameArea objectAtIndex:index1]).blockType != kStrawBlockObject) {
      if (pigController.responseState == kAwaitingEvent && 
        [((PhysicsRect*)[physicsObjectArray objectAtIndex:index1]).v length] > 5) {
        [textBalloon displayBalloonAtLocation:pigController.view.center andType:kOuchMessage];
        [gamearea addSubview:textBalloon];
        pigController.responseState = kEventOccurred;
        [textBalloon performSelector:@selector(removeFromView) withObject:nil afterDelay:1];
      }
    }
    return;
  } 
}

- (void)handleObjectWallCollisions:(NSNotification*)notification {
  
  int index = [[notification object] intValue];
  GameObject *obj = [objectsInGameArea objectAtIndex:index];
  PhysicsRect *phyObj = [physicsObjectArray objectAtIndex:index];
  
  if ([obj isKindOfClass:[GameBreathe class]]) {
      [breatheController breatheDisperseAnimation];
      [self performSelector:@selector(removeGameObject:) withObject:breatheController afterDelay:0.8];
    return;
    }
  if ([obj isKindOfClass:[GamePig class]]) {
    if (pigController.objectState == kPreGameStart) {
      phyObj.v = [Vector2D vectorWith:0 y:0];
    } else if (pigController.objectState == kGameAlive && phyObj.v.y > 30) {
      pigController.objectState = kGameDead;
      [pigController pigDieAnimation];
      [self performSelector:@selector(victory) withObject:nil afterDelay:1.5];
    }
    return;
  }
}

- (void)removeGameObject:(GameObject*)obj {
  if (obj) {
    [obj destroyObject];
    for (int i = 0; i < [objectsInGameArea count]; i++) {
      if ([[objectsInGameArea objectAtIndex:i] isEqual:obj]) {
        [objectsInGameArea removeObjectAtIndex:i];
        [physicsObjectArray removeObjectAtIndex:i];
      }
    }
    if ([obj isEqual:breatheController]) {
      [livesBoard deductLife];
      [fireButtonController changeState];
      breatheController = nil;
    }
    obj = nil;
  }
}

- (void)fireButtonPressed {
  if (fireButtonController.responseState == kAwaitingEvent) {
    [wolfController startWolfBlow];
    [textBalloon displayBalloonAtLocation:wolfController.view.center andType:kHowlMessage];
    [gamearea addSubview:textBalloon];
    [textBalloon performSelector:@selector(removeFromView) withObject:nil afterDelay:1.0];
    [self toggleShootingGuide];
    
    windSuck.frame = CGRectMake(arrowController.view.center.x, 
                                arrowController.view.center.y - 60, 
                                150, 144);
    windSuck.animationDuration = 1.0;
    windSuck.animationRepeatCount = 0;
    [windSuck startAnimating];
    [gamearea addSubview:windSuck];
    [windSuck performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
  }
}

- (void)toggleShootingGuide {
  if (arrowController.view.hidden) {
    arrowController.view.hidden = NO;
  } else {
    arrowController.view.hidden = YES;
  }
  
  if (directionDegree.hidden) {
    directionDegree.hidden = NO;
  } else {
    directionDegree.hidden = YES;
  }
}

- (void)addBreatheProjectile {
  
  [gameareaTimer invalidate];
  gameareaWorld = nil;
  
  pigController.responseState = kAwaitingEvent;
  
  CGRect breatheFrame = CGRectMake(arrowController.view.center.x, 
                                   arrowController.view.center.y - 45, 65, 65);
  breatheController = [[GameBreathe alloc] initWithFrame:breatheFrame];
  breatheController.view = breatheController.gameObjView;
  [gamearea addSubview:breatheController.view];
  
  PhysicsCircle *breatheBlock = [[PhysicsCircle alloc] 
                                 initWithOrigin:breatheController.view.frame.origin
                                 andWidth:breatheController.view.frame.size.width
                                 andHeight:breatheController.view.frame.size.height
                                 andMass:300
                                 andRotation:0
                                 andFriction:5
                                 andRestitution:0
                                 andView:nil]; 
 
  double breatheMagnitude = barController.view.frame.size.width * 2.5;
  breatheBlock.v = [Vector2D vectorWith:arrowController.view.transform.b * breatheMagnitude
                                      y:-arrowController.view.transform.a * breatheMagnitude];

  [physicsObjectArray addObject:breatheBlock];
  [objectsInGameArea addObject:breatheController];
  [breatheController removeAllGestureRecognizers];
  [breatheController breatheTravelAnimation];
  
  gameareaWorld = [[PhysicsWorld alloc] initWithObjects:physicsObjectArray
                                               andWalls:wallRectArray 
                                             andGravity:[Vector2D vectorWith:0 y:200]
                                            andTimeStep:gameareaTimeStep];
  [self performSelector:@selector(removeGameObject:) withObject:breatheController afterDelay:8.0];

  [self initializeTimer];
}

- (void)victory {
  if (outcome == kOutcomeUndetermined) {
    [fireButtonController changeState];
    [self toggleShootingGuide];
    
    UIImage *victoryText = [UIImage imageNamed:@"text-victory.png"];
    UIImageView *victoryTextView = [[UIImageView alloc] initWithImage:victoryText];
    
    victoryTextView.frame = CGRectMake(-810, 375, 213, 28);
    [self.view addSubview:victoryTextView];
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{ 
                       victoryTextView.center = CGPointMake(512, 389);
                     } 
                     completion:^(BOOL finished){}];
    
    [self performSelector:@selector(removeGameObject:) withObject:pigController afterDelay:2.0];
    [textBalloon displayBalloonAtLocation:wolfController.view.center andType:kMwhahaMessage];
    [gamearea addSubview:textBalloon];
    [powerBoard removeFromSuperview];
    outcome = kOutcomeVictory;
    
    [self.view addSubview:backButton];
    [UIView animateWithDuration:0.5
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{ 
                       backButton.center = CGPointMake(512, 500);
                     } 
                     completion:^(BOOL finished){}];
  }
}

- (void)gameOver {
  if (outcome == kOutcomeUndetermined) {
    [fireButtonController changeState];
    [wolfController wolfDieAnimation];
    [self toggleShootingGuide];
    
    UIImage *gameoverText = [UIImage imageNamed:@"text-game-over.png"];
    UIImageView *gameoverTextView = [[UIImageView alloc] initWithImage:gameoverText];
    
    gameoverTextView.frame = CGRectMake(-830, 375, 267, 28);
    [self.view addSubview:gameoverTextView];
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{ 
                       gameoverTextView.center = CGPointMake(512, 389);
                     } 
                     completion:^(BOOL finished){}];
    
    [textBalloon displayBalloonAtLocation:pigController.view.center andType:kHeeheeMessage];
    [gamearea addSubview:textBalloon];
    [powerBoard removeFromSuperview];
    outcome = kOutcomeLose;
    
    [self.view addSubview:backButton];
    [UIView animateWithDuration:0.5
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{ 
                       backButton.center = CGPointMake(512, 500);
                     } 
                     completion:^(BOOL finished){}];
  }
}

- (void)backToLevelDesigner {
  wolfController = nil;
  pigController = nil;
  for (int i = 0; i < [objectsInGameArea count]; i++) {
    [objectsInGameArea removeLastObject];
  }
  objectsInGameArea = nil;
  for (int i = 0; i < [physicsObjectArray count]; i++) {
    [physicsObjectArray removeLastObject];
  }
  physicsObjectArray = nil;
  gameareaWorld = nil;
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:YES completion:^(void){}];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ForestEvening"
                                                       ofType:@"caf"];
  NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
  audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
  audioPlayer.delegate = self;
  [audioPlayer prepareToPlay];
  [audioPlayer setNumberOfLoops:INFINITY];
  [audioPlayer play];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleMusic" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleMusic" object:nil];
  [self fadeMusic];
}

-(void)fadeMusic {  
  if (audioPlayer.volume > 0.1) {
    audioPlayer.volume = audioPlayer.volume - 0.1;
    [self performSelector:@selector(fadeMusic) withObject:nil afterDelay:0.1];           
  } else {
    // Stop and get the sound ready for playing again
    [audioPlayer stop];
    audioPlayer.currentTime = 0;
    [audioPlayer prepareToPlay];
    audioPlayer.volume = 1.0;
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
