#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "RatNum.h"


@interface RatNumTests : SenTestCase {
    RatNum *zero;
    RatNum *one;
    RatNum *negOne;
    RatNum *two;
    RatNum *three;
    RatNum *one_I_two;
	RatNum *one_I_three;
    RatNum *one_I_four;
    RatNum *two_I_three;
    RatNum *three_I_four;
    RatNum *negOne_I_two;
    RatNum *three_I_two;
    RatNum *one_I_zero;
	RatNum *negOne_I_zero;
    RatNum *hundred_I_zero;
	NSArray *ratNums;
	NSArray *ratNaNs;
	NSArray *ratNonNaNs;
}

@end
