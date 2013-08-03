//
//  Field.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Features.h"
#import "Lib/NSObject+Utils.h"
#import "MyButton.h"
#import "MySlider.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define CURFIELDCOLOR UIColorFromRGB(0x86e4ae)
#define FIELDCOLOR UIColorFromRGB(0xaaffcf)
#define BACKGROUNDCOLOR UIColorFromRGB(0x53e99e)
#define HIGHLIGHTCOLOR UIColorFromRGB(0xd2fde8)

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
    Store,
    Del,
    Next,
    Mul,
    PrevButton = BTAG_BASE,
    CalcButton,
    NextButton,
    MultButton,
    Slider,
    Ad = 999,
    FtagNotSet = -1
} FTAG;

typedef enum {
    FieldTypeNotSet,
    LabelField,
    KeyType
} FieldType;


@protocol TraverseFieldsDelegate;

@interface Field : NSObject <UITextFieldDelegate, UITextInputTraits>

+ (Field *)allocField;
+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t caller:(id)caller;

- (void)makeButton;
- (void)makeField;
- (void)makeSlider;
- (BOOL)isButton;
- (BOOL)isCurrency;
- (BOOL)isNumber;
- (BOOL)isSlider;

@property (unsafe_unretained, nonatomic) CGRect rect;
@property (unsafe_unretained, nonatomic) CGFloat f;
@property (copy, nonatomic) NSString *value;
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
@end
