//
//  GameObject.h
// 
// You can add your own prototypes in this file
//

#import <UIKit/UIKit.h>

// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;
typedef enum {kPreGameStart, kGameAlive, kGameDead} GameObjectState;
typedef enum {kAwaitingEvent, kEventOccurred} GameResponseState;

@protocol mainViewControllerDelegate <NSObject>

-(void)dropView:(id)viewCaller;
-(void)returnViewToPalette:(id)viewCaller;
-(void)scrollViewDisabled;
-(void)scrollViewEnabled;
-(void)objectPressed;

@end;

@interface GameObject : UIViewController <UIGestureRecognizerDelegate> {
  
  GameObjectType objectType;
  CGPoint origin;
  CGPoint centerPointInPalette;
  UIImageView *gameObjView;
  CGFloat rotatedState;
  CGFloat prevRotatedState;
  BOOL insideGameArea;
  GameObjectState objectState;
  GameResponseState responseState;
  
  CGPoint prevPanPoint;
  CGFloat prevPinchScale;
  CGFloat prevRotation;
  UIPanGestureRecognizer *objDrag;
  UIRotationGestureRecognizer *objRotate;
  UIPinchGestureRecognizer *objZoom;
  UITapGestureRecognizer *objDoubleTap;
  
  id<mainViewControllerDelegate> delegate;
}

@property (nonatomic, readwrite) GameResponseState responseState;
@property (nonatomic, readwrite) GameObjectState objectState;
@property (nonatomic, readwrite) BOOL insideGameArea;
@property (nonatomic, strong) UIImageView *gameObjView;
@property (nonatomic, retain) id delegate;
@property (nonatomic, readonly) GameObjectType objectType;
@property (nonatomic, readonly) CGFloat rotatedState;
@property (nonatomic, readonly) CGFloat prevRotation;

- (id)initWithObject:(UIImageView*)objView;
- (void)removeAllGestureRecognizers;
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: removes all the gesture recognizers added to this view controller

- (void)customRotation:(CGFloat)rotation;
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: rotates the view by the given rotation angle
  //          does not update the rotatedState of the view controller

- (void)customRotationByCollision:(CGFloat)rotation;
  // MODIFIES: self
  // REQUIRES: self != nil
  // EFFECTS: rotates the view by the given rotation angle
  //          updates the rotatedState of the view controller

- (void)translate:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (coordinates)
  // REQUIRES: game in designer mode
  // EFFECTS: the user drags around the object with one finger
  //          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (rotation)
  // REQUIRES: game in designer mode, object in game area
  // EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIGestureRecognizer *)gesture;
  // MODIFIES: object model (size)
  // REQUIRES: game in designer mode, object in game area
  // EFFECTS: the object is scaled up/down with a pinch gesture

- (void)destroyObject;
  // MODIFIES: self (view)
  // EFFECTS: view is removed from superview

@end
