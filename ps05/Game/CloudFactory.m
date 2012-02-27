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

- (id)initWithTimeStep:(double)dt {
  // REQUIRES: dt to be non-nil
  // EFFECTS: cloud images are loaded
  self = [super init];
  if (self) {
    timeStep = dt;
    cloudImage1 = [UIImage imageNamed:@"cloud1.png"];
    cloudImage2 = [UIImage imageNamed:@"cloud2.png"];
    cloudImage3 = [UIImage imageNamed:@"cloud3.png"];
    cloudImage4 = [UIImage imageNamed:@"cloud4.png"];
    startingPosition = kDefaultCloudPosition;
  }
  return self;
}

- (void)addCloud:(CloudType)type {
  // MODIFIES: clouds array
  // REQUIRES: self != nil
  // EFFECTS: a cloud object is initialized and added into the clouds array
  CloudObject *cloudImageView;
  
  CGFloat cloudWidth1 = cloudImage1.size.width;
  CGFloat cloudHeight1 = cloudImage1.size.height;
  CGFloat cloudWidth2 = cloudImage2.size.width;
  CGFloat cloudHeight2 = cloudImage2.size.height;
  CGFloat cloudWidth3 = cloudImage3.size.width;
  CGFloat cloudHeight3 = cloudImage3.size.height;
  CGFloat cloudWidth4 = cloudImage4.size.width;
  CGFloat cloudHeight4 = cloudImage4.size.height;
  
  double cloudPositionY = (arc4random() % 7) * 20 + 30;
  double speed = (arc4random() % 2) + 1;
  double scale = ((double)(rand() % 10)) / 20.0 + 0.5;
  UIImage *currentCloudImage;
  CGRect frame;

  switch (type) {
    case kCloudType1:
      currentCloudImage = cloudImage1;
      frame = CGRectMake(startingPosition, cloudPositionY, cloudWidth1, cloudHeight1);
      break;
    case kCloudType2:
      currentCloudImage = cloudImage2;
      frame = CGRectMake(startingPosition, cloudPositionY, cloudWidth2, cloudHeight2);
      break;
    case kCloudType3:
      currentCloudImage = cloudImage3;
      frame = CGRectMake(startingPosition, cloudPositionY, cloudWidth3, cloudHeight3);
      break;
    case kCloudType4:
      currentCloudImage = cloudImage4;
      frame = CGRectMake(startingPosition, cloudPositionY, cloudWidth4, cloudHeight4);
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

- (void)createInitialClouds {
  // MODIFIES: view and clouds array
  // REQUIRES: self != nil
  // EFFECTS: clouds are added into the view before timer is started
  clouds = [[NSMutableArray alloc] init];
  for (int i = 0; i < 10; i++) {
    CloudType type = arc4random() % 4;
    startingPosition = arc4random() % kIpadLandscapeWidth;
    [self addCloud:type];
  }
  startingPosition = kDefaultCloudPosition;
}

- (void)startGeneratingClouds {
  // MODIFIES: view
  // REQUIRES: parameters to be non-nil
  // EFFECTS: starts the timer for the cloud factory
  cloudTimer = [NSTimer scheduledTimerWithTimeInterval:timeStep 
                                                target:self 
                                              selector:@selector(updateClouds) 
                                              userInfo:nil 
                                               repeats:YES];
}

- (void)updateClouds {
  // MODIFIES: number of clouds in clouds array
  // REQUIRES: timer to have started
  // EFFECTS: randomly adds clouds of random sizes into the cloud array and     
  //          moves them
  CloudType type = arc4random() % 500;
  if (type < 4) {
    [self addCloud:type];
  }
  
  [self moveClouds];
}

- (void)moveClouds {
  // MODIFIES: position of clouds in clouds array
  // REQUIRES: timer to have started
  // EFFECTS: moves a cloud object by its speed given
  for (int i = 0; i < [clouds count]; i++) {
    CloudObject *cloud = [clouds objectAtIndex:i];
    cloud.center = CGPointMake(cloud.center.x + cloud.speed, cloud.center.y);
        
    if (cloud.frame.origin.x > kIpadLandscapeWidth) {
      [self removeCloud:cloud];
    }
  }
}

- (void)removeCloud:(CloudObject*)cloud {
  // MODIFIES: view
  // EFFECTS: a particular cloud is removed from the clouds array and from
  //          superview
  [cloud removeFromSuperview];
  [clouds removeObject:cloud];
}

- (void)removeAllClouds {
  // MODIFIES: view
  // EFFECTS: removes all clouds from the array and superview
  [cloudTimer invalidate];
  while ([clouds count] > 0) {
    [[clouds objectAtIndex:([clouds count] - 1)] removeFromSuperview]; 
    [clouds removeLastObject];
  }
  clouds = nil;
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
