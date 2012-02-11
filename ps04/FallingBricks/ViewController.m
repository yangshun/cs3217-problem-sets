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

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UIView *wallRect1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1024)];
  wallRect1.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:wallRect1];
  
 
  PhysicsRectangle *wallRectLeft = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(0, 0)
                                                                  andHeight:1024 
                                                                   andWidth:50
                                                                    andMass:INFINITY
                                                                andRotation:0 
                                                                andFriction:0.65
                                                                   andIndex:6];

  UIView *wallRect2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 50)];
  wallRect2.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:wallRect2];
  
  PhysicsRectangle *wallRectTop = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(0, 0)
                                                                  andHeight:50 
                                                                   andWidth:768
                                                                    andMass:INFINITY
                                                                andRotation:0 
                                                                andFriction:0.65
                                                                   andIndex:7];

  UIView *wallRect3 = [[UIView alloc] initWithFrame:CGRectMake(718, 0, 50, 1024)];
  wallRect3.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:wallRect3];
  
  PhysicsRectangle *wallRectRight = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(718, 0)
                                                                  andHeight:1024 
                                                                   andWidth:50
                                                                     andMass:INFINITY
                                                                andRotation:0 
                                                                andFriction:0.65
                                                                   andIndex:8];

  
  
  UIView *wallRect4 = [[UIView alloc] initWithFrame:CGRectMake(0, 954, 768, 50)];
  wallRect4.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:wallRect4];
  
  PhysicsRectangle *wallRectBottom = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(0, 954)
                                                                 andHeight:50 
                                                                  andWidth:768
                                                                   andMass:INFINITY
                                                               andRotation:0 
                                                               andFriction:0.65
                                                                  andIndex:9];

  
  UIView *viewRect1 = [[UIView alloc] initWithFrame:CGRectMake(300, 300, 150, 50)];
  viewRect1.backgroundColor = [UIColor redColor];
  [self.view addSubview:viewRect1];
  
  PhysicsRectangle *phyRect1 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(300, 300)
                                                          andHeight:50 
                                                           andWidth:150
                                                            andMass:1
                                                        andRotation:0 
                                                        andFriction:0.45
                                                           andIndex:0];
  
  UIView *viewRect2 = [[UIView alloc] initWithFrame:CGRectMake(400, 400, 50, 150)];
  viewRect2.backgroundColor = [UIColor greenColor];
  viewRect2.transform = CGAffineTransformRotate(viewRect2.transform, 0.755);
  [self.view addSubview:viewRect2];
  PhysicsRectangle *phyRect2 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(400, 400)
                                                           andHeight:150 
                                                            andWidth:50
                                                             andMass:100
                                                         andRotation:0.755 
                                                         andFriction:0.45
                                                            andIndex:1];
  
  UIView *viewRect3 = [[UIView alloc] initWithFrame:CGRectMake(400, 100, 50, 150)];
  viewRect3.backgroundColor = [UIColor blueColor];
  viewRect3.transform = CGAffineTransformRotate(viewRect3.transform, 1.91);
  [self.view addSubview:viewRect3];
  PhysicsRectangle *phyRect3 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(400, 100)
                                                              andHeight:150 
                                                               andWidth:50
                                                                andMass:100
                                                            andRotation:1.91 
                                                            andFriction:0.45
                                                               andIndex:2];
  
  UIView *viewRect4 = [[UIView alloc] initWithFrame:CGRectMake(600, 100, 50, 150)];
  viewRect4.backgroundColor = [UIColor yellowColor];
  viewRect4.transform = CGAffineTransformRotate(viewRect4.transform, 2.71);
  [self.view addSubview:viewRect4];
  PhysicsRectangle *phyRect4 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(600, 100)
                                                              andHeight:150 
                                                               andWidth:50
                                                                andMass:100
                                                            andRotation:2.71 
                                                            andFriction:0.45
                                                               andIndex:3];
  
  UIView *viewRect5 = [[UIView alloc] initWithFrame:CGRectMake(600, 300, 50, 150)];
  viewRect5.backgroundColor = [UIColor orangeColor];
  viewRect5.transform = CGAffineTransformRotate(viewRect5.transform, 0.71);
  [self.view addSubview:viewRect5];
  PhysicsRectangle *phyRect5 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(600, 300)
                                                              andHeight:150 
                                                               andWidth:50
                                                                andMass:100
                                                            andRotation:0.71 
                                                            andFriction:0.45
                                                               andIndex:4];
  
  UIView *viewRect6 = [[UIView alloc] initWithFrame:CGRectMake(120, 300, 50, 150)];
  viewRect6.backgroundColor = [UIColor magentaColor];
  viewRect6.transform = CGAffineTransformRotate(viewRect6.transform, 2.11);
  [self.view addSubview:viewRect6];
  PhysicsRectangle *phyRect6 = [[PhysicsRectangle alloc] initWithOrigin:CGPointMake(120, 300)
                                                              andHeight:150 
                                                               andWidth:50
                                                                andMass:100
                                                            andRotation:2.11 
                                                            andFriction:0.45
                                                               andIndex:5];
  
  viewRectArray = [[NSArray alloc] initWithObjects:viewRect1, viewRect2, viewRect3, viewRect4, viewRect5, viewRect6, nil];
  phyRectArray = [[NSArray alloc] initWithObjects:phyRect1, phyRect2, phyRect3, phyRect4, phyRect5, phyRect6, nil];
  wallsArray = [[NSArray alloc] initWithObjects: wallRectLeft, wallRectTop, wallRectRight, wallRectBottom, nil];
                  
  timeStep = 1.0f / 30.0f;
  world = [[PhysicsWorld alloc] initWithObjects:phyRectArray
                                       andWalls:wallsArray
                                     andGravity:[Vector2D vectorWith:0 y:9.81] 
                                    andTimeStep:timeStep
                                    andObserver:self];
  [self initializeTimer];
}

- (void)initializeTimer {

  timer = [NSTimer scheduledTimerWithTimeInterval:timeStep 
                                           target:self 
                                         selector:@selector(animateBlock) 
                                         userInfo:nil 
                                          repeats:YES];
}

- (void)animateBlock {
  [world updateBlocksState];

}

- (void)updateViewRectPositions:(NSNotification*)notification {
  
  PhysicsRectangle *block = [notification object];

  UIView* thisView = [viewRectArray objectAtIndex:block.tag];
  
  thisView.center = CGPointMake(block.center.x, block.center.y);
  thisView.transform = CGAffineTransformMakeRotation(block.rotation);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if (interfaceOrientation == UIInterfaceOrientationPortrait) {
    world.gravity = [Vector2D vectorWith:0 y:40]; 
  } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    world.gravity = [Vector2D vectorWith:0 y:-40]; 
  } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
    world.gravity = [Vector2D vectorWith:-40 y:0]; 
  } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
    world.gravity = [Vector2D vectorWith:40 y:0]; 
  }
  return NO;
}

@end

/*
Vector2D* gravity = [Vector2D vectorWith:0 y:0.25];
Vector2D* force = [Vector2D vectorWith:0 y:0];
testRect.dt = timeStep;
testRect2.dt = timeStep;
[testRect updateVelocity:gravity withForce:force];
[testRect updateAngularVelocity:10];
[testRect updatePosition];
[testRect initSelfVectorsAndMatricesQuantities];
[testRect2 initSelfVectorsAndMatricesQuantities];

if([testRect testOverlap:testRect2]) {
  [testRect calculateContactPoints];
  CGRect square = CGRectMake(((Vector2D*)[testRect.contactPoints objectAtIndex:0]).x, ((Vector2D*)[testRect.contactPoints objectAtIndex:0]).y, 5, 5);
  UIImageView *collision = [[UIImageView alloc] initWithFrame:square];
  collision.backgroundColor = [UIColor greenColor];
  [self.view addSubview:collision];
  if ([testRect.contactPoints count] > 1) {
    CGRect square2 = CGRectMake(((Vector2D*)[testRect.contactPoints objectAtIndex:1]).x, ((Vector2D*)[testRect.contactPoints objectAtIndex:1]).y, 5, 5);
    UIImageView *collision2 = [[UIImageView alloc] initWithFrame:square2];
    collision2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:collision2];
  }
  
  for (int i=0; i<15; i++) {
    [testRect applyImpulses];
    [testRect moveBodies];
    [testRect2 moveBodies];
  } 
}
if([testRect2 testOverlap:testRect]) {
  [testRect2 calculateContactPoints];
  for (int i=0; i<15; i++) {
    [testRect2 applyImpulses];
    [testRect moveBodies];
    [testRect2 moveBodies];
  } 
}
[testRect moveBodies];
[testRect2 moveBodies];
 */
