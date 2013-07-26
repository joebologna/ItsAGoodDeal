//
//  Fields.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Features.h"
#import "Field.h"

#define STORE "Remove Ads"
#define THANKS "Thank You"
#define CLR "C"
#define NEXT "Next/Calc Savings"
#define DEL "Del"
#define PROMPT "Enter Price, Min Qty & Size of Items"

typedef enum {
    ShowPrompt,
    ShowResult
} MessageMode;

@interface Fields : NSObject

- (Fields *)makeFields:(UIViewController *)vc;
- (void)hideKeypad:(id)sender;
- (void)showKeypad:(id)sender;
- (void)populateScreen;
- (void)fieldWasSelected:(Field *)field;
- (void)gotoNextField:(BOOL)grabKeyboard;
- (void)gotoPrevField:(BOOL)grabKeyboard;
- (void)gotoFieldWithControl:(UITextField *)t;
- (void)calcSavings;

@property (unsafe_unretained, nonatomic) DeviceType deviceType;
@property (strong, nonatomic, readonly) NSString
	*toString,
	*fieldValues;

@property (strong, nonatomic) Field
	*itemA,
	*itemB,
	*priceA,
	*priceB,
	*numItemsA,
	*numItemsB,
	*unitsEachA,
	*unitsEachB,
    *unitCostA,
    *unitCostB,
	*message,
	*ad,
	*one,
	*two,
	*three,
	*clr,
	*four,
	*five,
	*six,
	*store,
	*seven,
	*eight,
	*nine,
	*del,
	*period,
	*zero,
	*next;

@property (strong, nonatomic) NSArray *inputFields,
	*allFields,
	*keys;

@property (weak, nonatomic) UIViewController *vc;
@property (strong, nonatomic) Field *curField;

@end
