//
//  Fields.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Globals.h"
#import "Field.h"

#define PROMPT "Enter Prices, Units and # of Items"

typedef enum {
    ShowPrompt,
    ShowResult
} MessageMode;

typedef enum {OnA, OnB, OnNeither} Emphasis;
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
- (void)calcSavings:(BOOL)useQty;
- (void)emphasis:(Emphasis)e;

@property (unsafe_unretained, nonatomic) DeviceType deviceType;
@property (unsafe_unretained, nonatomic) float menuthingBought, menuthingNotBought;
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
    *slider,
    *qtyL,
    *qty,
	*message,
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
	*period,
	*zero,
	*next,
    *handle;

@property (strong, nonatomic) NSArray *inputFields,
	*allFields,
	*keys;

@property (weak, nonatomic) id vc;
@property (strong, nonatomic) Field *curField;

@end

@protocol TraverseViewDelegate <NSObject>
- (void)buttonPushed:(id)sender;
- (void)addControl:(UIView *)control;
- (void)showSettings;
@end
