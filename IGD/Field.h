//
//  Field.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyButton.h"

#define FTAG_BASE 100
#define KTAG_BASE 400

typedef enum {
    ItemA = FTAG_BASE,
    ItemB,
    BetterDealA,
    BetterDealB,
    PriceA,
    QtyA,
    SizeA,
    Qty2BuyA,
    PriceB,
    QtyB,
    SizeB,
    Qty2BuyB,
    Message,
    CostField,
    SavingsField,
    MoreField,
    CostLabel,
    SavingsLabel,
    MoreLabel,
    Ad = 999,
    FtagNotSet = -1
} FTAG;

typedef enum {
    One = KTAG_BASE,
    Two,
    Three,
    Clr,
    Four,
    Five,
    Six,
    Store,
    Seven,
    Eight,
    Nine,
    Del,
    Period,
    Zero,
    Next
} KTAG;

typedef enum {
    FieldTypeNotSet,
    LabelField,
    KeyType
} FieldType;

@interface Field : NSObject

+ (Field *)allocField;
+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t andVC:(UIViewController *)vc;

- (void)makeButton;
- (void)makeField;
- (BOOL)isButton;

@property (unsafe_unretained, nonatomic) CGRect rect;
@property (unsafe_unretained, nonatomic) CGFloat f;
@property (copy, nonatomic) NSString *value;
@property (unsafe_unretained, nonatomic) FTAG tag;
@property (unsafe_unretained, nonatomic) FieldType type;
@property (strong, nonatomic) UIView *control;
@property (unsafe_unretained, nonatomic) UIViewController *vc;

@property (strong, nonatomic, readonly) NSString *toString, *tagToString, *rectToString, *fTagToString;

@end
