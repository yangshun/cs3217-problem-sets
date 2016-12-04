#import <UIKit/UIKit.h>

@interface RatPolyCalculatorViewController : UIViewController {
	IBOutlet UILabel *resultDisplay;
	IBOutlet UITextField *polyText1;
	IBOutlet UITextField *polyText2;
	NSString *str;
}

@property (nonatomic, strong) IBOutlet UILabel *resultDisplay;
@property (nonatomic, strong) IBOutlet UITextField *polyText1;
@property (nonatomic, strong) IBOutlet UITextField *polyText2;

-(IBAction)buttonPress:(UIButton*)sender;

@end