//
//  GameObject.m
//  Game
//
//  Created by Yang Shun Tay on 28/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"
#import "GamePig.h"
#import "GameWolf.h"

#define kGroundHeight 590
#define kNudgeDistance 3

@class GamePig;
@class GameWolf;

@implementation GameObject

@synthesize responseState;
@synthesize objectState;
@synthesize insideGameArea;
@synthesize gameObjView;
@synthesize delegate;
@synthesize objectType;
@synthesize rotatedState;
@synthesize prevRotation;

- (id)initWithObject:(UIImageView*)objView {
  // default initializer
  self = [super init];
  if (self) {
    self.gameObjView = objView;
    self.view = gameObjView;
    insideGameArea = NO;
    objectState = kGameAlive;
  
    objDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self 
                                                     action:@selector(translate:)];
    objDrag.delegate = self;
    [self.view addGestureRecognizer:objDrag];
    
    objRotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(rotate:)];
    objRotate.delegate = self;
    [self.view addGestureRecognizer:objRotate];
    
    objZoom = [[UIPinchGestureRecognizer alloc]initWithTarget:self
                                                       action:@selector(zoom:)];
    objZoom.delegate = self;
    [self.view addGestureRecognizer:objZoom];
    
    objDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self 
                                                          action:@selector(doubleTap:)];
    objDoubleTap.delegate = self;
    objDoubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:objDoubleTap];
    
    self.view.userInteractionEnabled = YES;
  }
  return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
  shouldRecognizeSimultaneouslyWithGestureRecognizer:
  (UIGestureRecognizer *)otherGestureRecognizer {
  return NO;
}

- (void)removeAllGestureRecognizers {
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: removes all the gesture recognizers added to this view controller
  [self.view removeGestureRecognizer:objDrag];
  [self.view removeGestureRecognizer:objRotate];
  [self.view removeGestureRecognizer:objZoom];
  [self.view removeGestureRecognizer:objDoubleTap];
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: a pan gesture to be recognized
  // EFFECTS: modifies the center point of the view
  if (gesture.state == UIGestureRecognizerStateBegan) {
    prevPanPoint = [gesture locationInView:self.view.superview];
  }
  
  self.view.alpha = 0.5;
  
  if ([delegate respondsToSelector:@selector(scrollViewDisabled)]) {
    [delegate scrollViewDisabled];
  }
  
  CGPoint curr = [gesture locationInView:self.view.superview];
  
	float diffx = curr.x - prevPanPoint.x;
	float diffy = curr.y - prevPanPoint.y;
  
	CGPoint center = gameObjView.center;
    
  if (insideGameArea && 
      (gameObjView.frame.origin.y + gameObjView.frame.size.height) > kGroundHeight) {
    center.y -= (diffy + kNudgeDistance);
  }
  
  center.x += diffx;
	center.y += diffy;
  
	self.view.center = center;
  
  prevPanPoint = curr;
  
  // handling the event when a gesture ends
  if (gesture.state == UIGestureRecognizerStateEnded && !insideGameArea) {
    // if the view is in the gamearea, transfer it into gamearea
    if ([gesture locationInView:self.view.superview].y > 160 && 
        [delegate respondsToSelector:@selector(dropView:)]) {
      [delegate dropView:self];
    } else {
      // return the view to the starting point in the palette
      self.view.center = centerPointInPalette;
    }
  }
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    self.view.alpha = 1.0;
  }
  
  if ([delegate respondsToSelector:@selector(scrollViewEnabled)]) {
    [delegate scrollViewEnabled];
  }
}

- (void)customRotation:(CGFloat)rotation {
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: rotates the view by the given rotation angle
  //          does not update the rotatedState of the view controller
  self.view.transform = CGAffineTransformRotate(self.view.transform, rotation);
  return;
}

- (void)customRotationByCollision:(CGFloat)rotation {
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: rotates the view by the given rotation angle
  //          updates the rotatedState of the view controller
  rotatedState += rotation;
  [self customRotation:rotation];
  return;
}


- (void)rotate:(UIRotationGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: a rotation gesture to be recognized
  // EFFECTS: rotate a GameObject view by the specified finger positions
  // does not modify GameWolf and GamePig
  if (gesture.state == UIGestureRecognizerStateBegan) {
    prevRotation = 0.0;
  } 
  
  CGFloat thisRotate = gesture.rotation - prevRotation;
  prevRotation = gesture.rotation; 
  rotatedState += thisRotate;
  self.view.transform = CGAffineTransformRotate(self.view.transform, thisRotate);
}

- (void)zoom:(UIPinchGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: a pinch gesture to be recognized
  // EFFECTS: resizes a GameObject view by the specified finger positions
	if (gesture.state == UIGestureRecognizerStateBegan) {
		prevPinchScale = 1.0;
  }
  
  float thisScale = 1 + (gesture.scale - prevPinchScale);
  prevPinchScale = gesture.scale;
  self.view.transform = CGAffineTransformScale(self.view.transform, thisScale, thisScale);
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: double tap gesture to be recognized
  // EFFECTS: removes the game object from the gamearea and returns it to the palette
  if(insideGameArea && [delegate respondsToSelector:@selector(returnViewToPalette:)]) {
    [delegate returnViewToPalette:self];
  }
}

- (void)destroyObject {
  // MODIFIES: self (view)
  // EFFECTS: view is removed from superview
  if ([self.gameObjView respondsToSelector:@selector(stopAnimating)]) {
    [self.gameObjView stopAnimating];
  }
  [self.view removeFromSuperview];
}

@end
