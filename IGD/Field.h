//
//  Field.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Globals.h"
#import "Lib/NSObject+Utils.h"
#import "MyButton.h"
#import "MySlider.h"

#define FTAG_BASE 100
#define KTAG_BASE 200
#define BTAG_BASE 300

#define PREVBUTTON @" Previous  "
#define CALCBUTTON @" Calculate "
#define NEXTBUTTON @"   Next    "
#define MULTBUTTON @" Multiply  "

typedef enum {
    PriceAL = FTAG_BASE,
    PriceBL,
    PriceA,
    PriceB,
    UnitsEachAL,
    NumItemsAL,
    UnitsEachBL,
    NumItemsBL,
    UnitsEachA,
    XAL,
    NumItemsA,
    UnitsEachB,
    XBL,
    NumItemsB,
    UnitCostAL,
    UnitCostBL,
    UnitCostA,
    UnitCostB,
    TotalCostA,
    TotalCostB,
    Message,
    Message2,
    MoreLabel,
    One = KTAG_BASE,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Zero,
    Period,
    Clr,
    Del,
    Next,
    Mul,
    PrevButton = BTAG_BASE,
    CalcButton,
    NextButton,
    HandleWidget,
    Slider,
    Qty,
    HelpViewTag = 998,
    Ad = 999,
    FtagNotSet = -1
} FTAG;

typedef enum {
    FieldTypeNotSet,
    LabelField,
    KeyType
} FieldType;


@protocol TraverseFieldsDelegate;

@interface Field : NSObject <UITextFieldDelegate, UITextInputTraits, MySliderDelegate>

+ (Field *)allocField;
+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t caller:(id)caller;

- (void)makeButton;
- (void)makeField;
- (void)makeSlider;
- (void)makeHandle;
- (BOOL)isButton;
- (BOOL)isCurrency;
- (BOOL)isNumber;
- (BOOL)isSlider;
- (BOOL)isHandle;
- (BOOL)isQty;

@property (unsafe_unretained, nonatomic) CGRect rect;
@property (unsafe_unretained, nonatomic) CGFloat f;
@property (copy, nonatomic) NSString *value;
@property (unsafe_unretained, nonatomic) BOOL hilight;
@property (unsafe_unretained, nonatomic) FTAG tag;
@property (unsafe_unretained, nonatomic) FieldType type;
@property (strong, nonatomic) UIView *control;
@property (unsafe_unretained, nonatomic) id caller;

@property (strong, nonatomic, readonly) NSString *toString, *tagToString, *rectToString, *fTagToString;
@property (unsafe_unretained, nonatomic, readonly) CGFloat floatValue;

@end

@protocol TraverseFieldsDelegate <NSObject>
- (void)gotoFieldWithControl:(UITextField *)textField;
- (void)hideKeypad:(Field *)field;
- (void)showKeypad:(Field *)field;
- (void)buttonPushed:(id)sender;
- (void)fieldWasSelected:(Field *)field;
- (void)setSliderPosition:(float)v;
- (void)setNumItems:(NSString *)v;
- (void)updateQty:(float)v;
- (void)updateSavings;
- (void)showSettings;
- (UIViewController *)getVC;
@end
