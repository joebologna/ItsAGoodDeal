//
//  NewSavings.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/22/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

typedef enum {
    NotReady, NeedQty2Purchase, CalcComplete
} CalcState;

@interface Savings : NSObject

+ (Savings *)theNewSavings;
+ (Savings *)savingsWithItemA:(Item *)itemA withItemB:(Item *)itemB;
- (NSString *)getCalcStateString;

@property (unsafe_unretained, nonatomic, readonly) float normalizedMinQty, totalCost, totalCostA, totalCostB, savings, savingsA, savingsB, amountPurchased, amountPurchasedA, amountPurchasedB, percentSavings, percentSavingsA, percentSavingsB, percentMoreProductA, percentMoreProductB;
@property (unsafe_unretained, nonatomic) float qty2Purchase;
@property (strong, nonatomic) Item *itemA, *itemB, *betterPricePerUnit;
@property (unsafe_unretained, nonatomic, readonly) CalcState calcState;
@property (unsafe_unretained, nonatomic, readonly) BOOL isReady;
@property (strong, nonatomic, readonly) Item *cheaperItem;
@property (strong, nonatomic) NSString *toString;

@end
