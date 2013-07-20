//
//  Field.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface Field : NSObject

+ (Field *)allocField;
+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andLabel:(NSString *)l andTag:(FTAG)tag;

@property (unsafe_unretained, nonatomic) CGRect rect;
@property (unsafe_unretained, nonatomic) CGFloat f;
@property (copy, nonatomic) NSString *label;
@property (unsafe_unretained, nonatomic) FTAG tag;

@property (strong, nonatomic, readonly) NSString *toString, *tagToString, *rectToString, *fTagToString;

@end
