//
//  CloudFactory.m
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "CloudFactory.h"

@implementation CloudFactory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initCloudsWithTimeStep:(double)dt {
  
  self = [super init];
  if (self) {
    clouds = [[NSMutableArray alloc] init];
    timeStep = dt;
    cloudImage1 = [UIImage imageNamed:@"cloud1.png"];
    cloudImage2 = [UIImage imageNamed:@"cloud2.png"];
    cloudImage3 = [UIImage imageNamed:@"cloud3.png"];
  }
  return self;
}

- (void)addCloud:(CloudType)type {
  
  CloudObject *cloudImageView;
  
  int cloudPositionY = (rand() % 7) * 20 + 30;
  int speed = rand() % 2 + 1;
  double scale = ((double)(rand() % 10)) / 20.0 + 0.5;
  UIImage *currentCloudImage;
  CGRect frame;
  switch (type) {
    case kCloudType1:
      currentCloudImage = cloudImage1;
      frame = CGRectMake(-500, cloudPositionY, 253, 159);
      break;
    case kCloudType2:
      currentCloudImage = cloudImage2;
      frame = CGRectMake(-500, cloudPositionY, 209, 115);
      break;
    case kCloudType3:
      currentCloudImage = cloudImage3;
      frame = CGRectMake(-500, cloudPositionY, 204, 135);
      break;
    default:
      break;
  }
  
  cloudImageView = [[CloudObject alloc] initWithImage:currentCloudImage 
                                             andSpeed:speed
                                             andFrame:frame
                                             andScale:scale];
                      
  [self.view addSubview:cloudImageView];
  [clouds addObject:cloudImageView];
}

- (void)startGeneratingClouds {
  cloudTimer = [NSTimer scheduledTimerWithTimeInterval:timeStep 
                                                target:self 
                                              selector:@selector(generateClouds) 
                                              userInfo:nil 
                                               repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:cloudTimer forMode:NSRunLoopCommonModes];
}

- (void)generateClouds {
  
  CloudType type = rand() % 500;
  if (type < 3) {
    [self addCloud:type];
  }
  
  [self moveClouds];
  NSLog(@"%d", [clouds count]);
}

- (void)moveClouds {
  
  for (int i = 0; i < [clouds count]; i++) {
    CloudObject *cloud = [clouds objectAtIndex:i];
    cloud.center = CGPointMake(cloud.center.x + cloud.speed, cloud.center.y);
    
    if (cloud.frame.origin.x > 1600) {
      [clouds removeObject:cloud];
      [cloud removeFromSuperview];
      cloud = nil;
    }
  }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
