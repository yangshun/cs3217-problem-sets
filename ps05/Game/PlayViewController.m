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
    wolfController = wolf;
    pigController = pig;
    objectsInGameArea = blocks;
    [objectsInGameArea addObject:pigController];
    [objectsInGameArea addObject:wolfController];
  }

  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  // Do any additional setup after loading the view, typically from a nib.
  UIImage *bgImage = [UIImage imageNamed:@"background.png"];
  UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
  //UIImage *paletteImage = [UIImage imageNamed:@"palette.png"];
  
  // Get the width and height of the two images
  CGFloat backgroundWidth = bgImage.size.width;
  CGFloat backgroundHeight = bgImage.size.height;
  CGFloat groundWidth = groundImage.size.width;
  CGFloat groundHeight = groundImage.size.height;
  //CGFloat paletteWidth = paletteImage.size.width;
  //CGFloat paletteHeight = paletteImage.size.height;
  
  // Place each of them in an UIImageView
  UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
  UIImageView *ground = [[UIImageView alloc] initWithImage:groundImage];
  //palette = [[UIImageView alloc] initWithImage:paletteImage];
  
  CGFloat groundY = gamearea.frame.size.height - groundHeight;
  CGFloat backgroundY = groundY - backgroundHeight;
  //CGFloat paletteY = 768 - backgroundHeight - groundHeight - paletteHeight;
  
  // The frame property holds the position and size of the views
  // The CGRectMake methods arguments are : x position, y position, width,
  // height. origin at top left hand corner, with positive y-axis downwards
  background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
  ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
  //palette.frame = CGRectMake(0, paletteY, paletteWidth, paletteHeight);
  //palette.userInteractionEnabled = YES;
  //[self.view addSubview:palette];
  
  // Add these views as subviews of the gamearea.
  [gamearea addSubview:background];
  [gamearea addSubview:ground];
  
  // Set the content size so that gamearea is scrollable
  // otherwise it defaults to the current window size
  CGFloat gameareaHeight = backgroundHeight + groundHeight;
  CGFloat gameareaWidth = backgroundWidth;
  [gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
  
  physicsObjectArray = [[NSMutableArray alloc] init];
  
  for (GameObject *obj in objectsInGameArea) {
    [obj customRotation:-obj.rotatedState];
    PhysicsRect *rectBlock = [[PhysicsRect alloc] initWithOrigin:obj.view.frame.origin
                                                        andWidth:obj.view.frame.size.width
                                                       andHeight:obj.view.frame.size.height
                                                         andMass:100
                                                     andRotation:obj.rotatedState
                                                     andFriction:4
                                                  andRestitution:0
                                                         andView:nil];
    [physicsObjectArray addObject:rectBlock];               
    
    [obj customRotation:obj.rotatedState];
    [obj removeAllGestureRecognizers];
    [gamearea addSubview:obj.view];
  }
  
  PhysicsRect *wallGround = [[PhysicsRect alloc] initWithOrigin:ground.frame.origin
                                                       andWidth:groundWidth
                                                      andHeight:groundHeight
                                                        andMass:INFINITY
                                                  andRotation:0 
                                                    andFriction:5
                                                 andRestitution:0
                                                        andView:nil];
  wallRectArray = [[NSArray alloc] initWithObjects:wallGround, nil];
  
  gameareaTimeStep = 1.0f/120.0f;
  gameareaWorld = [[PhysicsWorld alloc] initWithObjects:physicsObjectArray
                                               andWalls:wallRectArray 
                                             andGravity:[Vector2D vectorWith:0 y:100]
                                            andTimeStep:gameareaTimeStep
                                            andObserver:self];
  [self initializeTimer];
  [self performSelector:@selector(setUpGamearea) withObject:nil afterDelay:2];
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
  
  CGRect barFrame = CGRectMake(100, 530, 21, 147);
  barController = [[GameBar alloc] initWithFrame:barFrame];
  barController.view = barController.gameObjView;
  
  CGRect fireButtonFrame = CGRectMake(42, 620, 30, 40);
  fireButtonController = [[GameFireButton alloc] initWithFrame:fireButtonFrame];
  fireButtonController.view = fireButtonController.gameObjView;
  fireButtonController.delegate = self;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(fireButtonPressed) 
                                               name:@"FireButtonPressed"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleShootingGuide) 
                                               name:@"DisplayShootingGuide"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(addBreatheProjectile) 
                                               name:@"ShootProjectile"
                                             object:nil];
  // remove the wolf from the physics engine
  [objectsInGameArea removeObjectAtIndex:[objectsInGameArea count] - 1];
  [physicsObjectArray removeObjectAtIndex:[physicsObjectArray count] - 1];
  
  [gamearea addSubview:directionDegree];
  [gamearea addSubview:arrowController.view];
  [gamearea addSubview:barController.view];
  [gamearea addSubview:fireButtonController.view];
  
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

- (void)fireButtonPressed {
  [wolfController startWolfBlow];
  [self toggleShootingGuide];
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

  CGRect breatheFrame = CGRectMake(arrowController.view.center.x, 
                                   arrowController.view.center.y - 50, 113, 104);
  breatheController = [[GameBreathe alloc] initWithFrame:breatheFrame];
  breatheController.view = breatheController.gameObjView;
  [gamearea addSubview:breatheController.view];
  
  PhysicsCircle *breatheBlock = [[PhysicsCircle alloc] initWithOrigin:breatheController.view.frame.origin
                                                             andWidth:breatheController.view.frame.size.width
                                                            andHeight:breatheController.view.frame.size.height
                                                              andMass:1000
                                                          andRotation:0
                                                          andFriction:5
                                                       andRestitution:0
                                                              andView:nil]; 
 
  double breatheMagnitude = barController.view.frame.size.width * 3;
  breatheBlock.v = [Vector2D vectorWith:arrowController.view.transform.b * breatheMagnitude
                                      y:-arrowController.view.transform.a * breatheMagnitude];

  [physicsObjectArray addObject:breatheBlock];
  [objectsInGameArea addObject:breatheController];
  [breatheController removeAllGestureRecognizers];
  [breatheController startBreathe];
  
  gameareaWorld = [[PhysicsWorld alloc] initWithObjects:physicsObjectArray
                                               andWalls:wallRectArray 
                                             andGravity:[Vector2D vectorWith:0 y:100]
                                            andTimeStep:gameareaTimeStep
                                            andObserver:self];
   
  [self initializeTimer];
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
