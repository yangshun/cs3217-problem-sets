#import <UIKit/UIKit.h>

@class RatPolyCalculatorViewController;

@interface RatPolyCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RatPolyCalculatorViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet RatPolyCalculatorViewController *viewController;

@end

