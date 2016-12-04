#import "RatPolyCalculatorViewController.h"
#import "RatPoly.h"

@implementation RatPolyCalculatorViewController

@synthesize resultDisplay;
@synthesize polyText1;
@synthesize polyText2;

-(IBAction)buttonPress:(UIButton*)sender{
	NSString *oper = [[sender titleLabel] text];
	NSString *arg1 = self.polyText1.text;
	NSString *arg2 = self.polyText2.text;
	NSString *resultStr;
	
	RatPoly *poly1 = [RatPoly valueOf:arg1];
	RatPoly *poly2 = [RatPoly valueOf:arg2];
	RatPoly *resultPoly;
	if ([oper isEqual:@"+"]) {
		resultPoly = [poly1 add:poly2];
	} else if ([oper isEqual:@"-"]) {
		resultPoly = [poly1 sub:poly2];
	} else if ([oper isEqual:@"*"]) {
		resultPoly = [poly1 mul:poly2];
	} else {
		resultPoly = [poly1 div:poly2];
	}
	resultStr = [resultPoly stringValue];
	
	[resultDisplay setText:resultStr];
}

-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event
{
    [polyText1 resignFirstResponder];
	
    [polyText2 resignFirstResponder];
	
    [super touchesBegan:touches withEvent:event ];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
