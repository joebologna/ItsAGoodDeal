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

#define STORE "No Ads"
#define THANKS "Thanks!"
#define CLR "C"
#define NEXT "Next/Calc Savings"
#define DEL "Del"
#define PROMPT "Enter Prices, # of Items and # of Units"

typedef enum {
    ShowPrompt,
    ShowResult
} MessageMode;

@protocol TraverseViewDelegate;

@interface Fields : NSObject <TraverseFieldsDelegate>

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
	*priceAL,
	*priceBL,
    *priceA,
    *priceB,
    *unitsEachAL,
    *numItemsAL,
    *unitsEachBL,
    *numItemsBL,
    *unitsEachA,
    *xAL,
    *numItemsA,
    *unitsEachB,
    *xBL,
    *numItemsB,
    *unitCostAL,
    *unitCostBL,
    *unitCostA,
    *unitCostB,
    *totalCostAL,
    *totalCostBL,
    *totalCostA,
    *totalCostB,
	*message,
    *message2,
	*ad,
	*one,
	*two,
	*three,
	*clr,
	*four,
	*five,
	*six,
    *del,
	*seven,
	*eight,
	*nine,
    *store,
	*period,
	*zero,
	*next;

@property (strong, nonatomic) NSArray *inputFields,
	*allFields,
	*keys;

@property (weak, nonatomic) id vc;
@property (strong, nonatomic) Field *curField;

@end

@protocol TraverseViewDelegate <NSObject>
- (void)buttonPushed:(id)sender;
- (void)addControl:(UIView *)control;
@end
