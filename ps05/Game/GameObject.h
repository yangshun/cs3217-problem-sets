//
//  GameObject.h
// 
// You can add your own prototypes in this file
//

#import <UIKit/UIKit.h>

// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

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
  
  CGPoint prevPanPoint;
  CGFloat prevPinchScale;
  CGFloat prevRotation;
  UIPanGestureRecognizer *objDrag;
  UIRotationGestureRecognizer *objRotate;
  UIPinchGestureRecognizer *objZoom;
  UITapGestureRecognizer *objDoubleTap;
  
  id<mainViewControllerDelegate> delegate;
}

@property (nonatomic, readwrite) BOOL insideGameArea;
@property (nonatomic, strong) UIImageView *gameObjView;
@property (nonatomic, retain) id delegate;
@property (nonatomic, readonly) GameObjectType objectType;
@property (nonatomic, readonly) CGFloat rotatedState;
@property (nonatomic, readonly) CGFloat prevRotation;

- (id)initWithObject:(UIImageView*)objView;
- (void)removeAllGestureRecognizers;
- (void)customRotation:(CGFloat)rotation;
- (void)customRotationByCollision:(CGFloat)rotation;
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

@end
