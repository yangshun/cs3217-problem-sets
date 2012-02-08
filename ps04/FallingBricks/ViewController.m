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
  testRect = [[Rectangle alloc] initWithImage];
  [self.view addSubview:testRect.view];
  testRect2 = [[Rectangle alloc] initWithImage];
  [testRect2 rotate:1.57];
  [testRect2 translate:[Vector2D vectorWith:0 y:300]];
  [self.view addSubview:testRect.view];
  [self.view addSubview:testRect2.view];
  [self initializeTimer];
}

- (void)initializeTimer {

  timeStep = 1.0/10.0;
  timer = [NSTimer scheduledTimerWithTimeInterval:timeStep 
                                             target:self 
                                           selector:@selector(animateBlock) 
                                           userInfo:nil 
                                            repeats:YES];

}

- (void)animateBlock {
  Vector2D* gravity = [Vector2D vectorWith:0 y:0.1];
  Vector2D* force = [Vector2D vectorWith:0 y:0];
  testRect.dt = timeStep;
  [testRect updateVelocity:gravity withForce:force];
  //[testRect updateAngularVelocity:10];
  [testRect updatePosition];
  [testRect initSelfVectorsAndMatricesQuantities];
  [testRect2 initSelfVectorsAndMatricesQuantities];
  NSLog(@"%d",[testRect2 testOverlap:testRect]);
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
    // Return YES for supported orientations
  return YES;
}

@end
