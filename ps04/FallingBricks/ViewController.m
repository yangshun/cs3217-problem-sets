//
//  ViewController.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#define kIpadWidth 768
#define kIpadHeight 1024
#define kStatusBarThickness 20

#define kWallWidth 100
#define kWallFriction 1
#define kWallRestitution 0.05

#define kBlockFriction 0.2
#define kBlockRestitution 0.05

#define kGravityMagnitude 200
#define kGravityMultiplier 1000

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  // initialize the four walls 
  PhysicsRect *wallRectLeft = [[PhysicsRect alloc] initWithOrigin:CGPointMake(-kWallWidth, 0)
                                                         andWidth:kWallWidth
                                                        andHeight:kIpadHeight
                                                          andMass:INFINITY
                                                      andRotation:0 
                                                      andFriction:kWallFriction
                                                   andRestitution:kWallRestitution
                                                         andIndex:-1];
  
  PhysicsRect *wallRectTop = [[PhysicsRect alloc] initWithOrigin:CGPointMake(0, -kWallWidth)
                                                        andWidth:kIpadWidth
                                                       andHeight:kWallWidth
                                                         andMass:INFINITY
                                                     andRotation:0 
                                                     andFriction:kWallFriction
                                                  andRestitution:kWallRestitution
                                                        andIndex:-1];
  
  PhysicsRect *wallRectRight = [[PhysicsRect alloc] initWithOrigin:CGPointMake(kIpadWidth, 0)
                                                          andWidth:100
                                                         andHeight:kIpadHeight
                                                           andMass:INFINITY
                                                       andRotation:0 
                                                       andFriction:kWallFriction
                                                    andRestitution:kWallRestitution
                                                          andIndex:-1];
  
  PhysicsRect *wallRectBottom = [[PhysicsRect alloc] initWithOrigin:
                                 CGPointMake(0, kIpadHeight - kStatusBarThickness)
                                                           andWidth:kIpadWidth
                                                          andHeight:100
                                                            andMass:INFINITY
                                                        andRotation:0 
                                                        andFriction:kWallFriction
                                                     andRestitution:kWallRestitution
                                                           andIndex:-1];
  
  // initialize the blocks (PhysicRect objects) in the view and in the PhysicsWorld
  // initialize red block
  UIView *viewRect1 = [[UIView alloc] initWithFrame:CGRectMake(290, 300, 250, 150)];
  viewRect1.backgroundColor = [UIColor redColor];
  [self.view addSubview:viewRect1];
  PhysicsRect *blockRect1 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(290, 300)
                                                       andWidth:250
                                                      andHeight:150 
                                                        andMass:100
                                                    andRotation:0 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:0];
  
  // initialize maroon block
  UIView *viewRect2 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 150)];
  viewRect2.backgroundColor = [UIColor colorWithRed:134.0 / 225.0 
                                              green:13.0 / 225.0 
                                               blue:64.0 / 225.0 
                                              alpha:1.0];
  viewRect2.transform = CGAffineTransformRotate(viewRect2.transform, 0.755);
  [self.view addSubview:viewRect2];
  PhysicsRect *blockRect2 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(50, 50)
                                                       andWidth:50
                                                      andHeight:150
                                                        andMass:100
                                                    andRotation:0.755 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:1];
  
  // initialize brown block
  UIView *viewRect3 = [[UIView alloc] initWithFrame:CGRectMake(400, 100, 50, 200)];
  viewRect3.backgroundColor = [UIColor brownColor];
  viewRect3.transform = CGAffineTransformRotate(viewRect3.transform, 1.91);
  [self.view addSubview:viewRect3];
  PhysicsRect *blockRect3 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(400, 100)
                                                       andWidth:50
                                                      andHeight:200 
                                                        andMass:100
                                                    andRotation:1.91 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:2];
  
  // initialize yellow block
  UIView *viewRect4 = [[UIView alloc] initWithFrame:CGRectMake(580, 100, 150, 150)];
  viewRect4.backgroundColor = [UIColor yellowColor];
  viewRect4.transform = CGAffineTransformRotate(viewRect4.transform, 2.71);
  [self.view addSubview:viewRect4];
  PhysicsRect *blockRect4 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(580, 100)
                                                       andWidth:150
                                                      andHeight:150 
                                                        andMass:100
                                                    andRotation:2.71 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:3];
  
  // initialize orange block
  UIView *viewRect5 = [[UIView alloc] initWithFrame:CGRectMake(610, 300, 100, 200)];
  viewRect5.backgroundColor = [UIColor orangeColor];
  viewRect5.transform = CGAffineTransformRotate(viewRect5.transform, 0.71);
  [self.view addSubview:viewRect5];
  PhysicsRect *blockRect5 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(610, 300)
                                                       andWidth:100
                                                      andHeight:200 
                                                        andMass:100
                                                    andRotation:0.71 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:4];
  
  // initialize pink block
  UIView *viewRect6 = [[UIView alloc] initWithFrame:CGRectMake(50, 300, 200, 150)];
  viewRect6.backgroundColor = [UIColor colorWithRed:222.0 / 225.0 
                                              green:17.0 / 225.0 
                                               blue:148.0 / 225.0 
                                              alpha:1.0];
  viewRect6.transform = CGAffineTransformRotate(viewRect6.transform, 2.11);
  [self.view addSubview:viewRect6];
  PhysicsRect *blockRect6 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(50, 300)
                                                       andWidth:200
                                                      andHeight:150
                                                        andMass:100
                                                    andRotation:2.11 
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                       andIndex:5];
  
  // initialize the array of block views, PhysicRect blocks and PhysicRect walls
  viewRectArray = [[NSArray alloc] initWithObjects:viewRect1, viewRect2, 
                   viewRect3, viewRect4, viewRect5, viewRect6, nil];
  blockRectArray = [[NSArray alloc] initWithObjects:blockRect1, blockRect2, 
                    blockRect3, blockRect4, blockRect5, blockRect6, nil];
  wallRectArray = [[NSArray alloc] initWithObjects: wallRectLeft, 
                   wallRectTop, wallRectRight, wallRectBottom, nil];
  
  timeStep = 1.0f/200.0f;
  
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  
  // initialize PhysicsWorld object with the arrays of PhysicRect as paramaters
  world = [[PhysicsWorld alloc] initWithObjects:blockRectArray
                                       andWalls:wallRectArray
                                     andGravity:[self selectGravity:orientation]
                                    andTimeStep:timeStep
                                    andObserver:self];
  
  // add observer to update gravity direction when device orientation changes
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(rotateView:) 
                                               name:UIDeviceOrientationDidChangeNotification 
                                             object:nil];
  
  UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = timeStep;
  
  [self initializeTimer];
}

- (void)initializeTimer {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  timer = [NSTimer scheduledTimerWithTimeInterval:timeStep 
                                           target:self 
                                         selector:@selector(updateWorldTime) 
                                         userInfo:nil 
                                          repeats:YES];
}

- (void)updateWorldTime {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  [world updateBlocksState];
}

- (void)updateViewRectPositions:(NSNotification*)notification {
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity vector according to the orientation of the device
  PhysicsRect *block = [notification object];
  
  UIView* thisView = [viewRectArray objectAtIndex:block.tag];
  
  thisView.center = CGPointMake(block.center.x, block.center.y);
  thisView.transform = CGAffineTransformMakeRotation(block.rotation);
}

- (void)rotateView:(NSNotification*)notification {
  // MODIFIES: gravity vector of PhysicsWorld object
  // REQUIRES: device orientation to be changed
  // EFFECTS: changes the gravity vector according to the orientation of the device
  if (world.accelerometerActivated) {
    return;
  }
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  world.gravity = [self selectGravity:orientation];
}

- (Vector2D*)selectGravity:(UIDeviceOrientation)orientation {
  // EFFECTS: returns a new gravity vector according to the orientation of the device
  Vector2D *gravity;
  
  if (orientation == UIDeviceOrientationPortraitUpsideDown) {
    gravity = [Vector2D vectorWith:0 y:-kGravityMagnitude]; 
  } else if (orientation == UIDeviceOrientationLandscapeLeft) {
    gravity = [Vector2D vectorWith:-kGravityMagnitude y:0]; 
  } else if (orientation == UIDeviceOrientationLandscapeRight) {
    gravity = [Vector2D vectorWith:kGravityMagnitude y:0]; 
  } else {
    gravity = [Vector2D vectorWith:0 y:kGravityMagnitude]; 
  }
  return gravity;
}

- (IBAction)accelerometerSwitch:(UISwitch*)sender {
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity mode of selection between orientation and accelerometer
  world.accelerometerActivated = sender.on;
  
  if (!sender.on) {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    world.gravity = [self selectGravity:orientation];
  }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration {
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity according to accelerometer's direction and magnitude
  if (world.accelerometerActivated) {
    world.gravity = [Vector2D vectorWith:acceleration.x * kGravityMultiplier 
                                       y:-acceleration.y * kGravityMultiplier];
  } 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // EFFECTS: method overridden to prevent rotation of interface
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


@end