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

@interface NewSavings : NSObject

+ (NewSavings *)theNewSavings;
+ (NewSavings *)theNewSavingsWithItemA:(Item *)itemA withItemB:(Item *)itemB;

@property (unsafe_unretained, nonatomic, readonly) float betterPrice, normalizedMinQty, totalCost, totalCostA, totalCostB, savings, savingsA, savingsB, amountPurchased, amountPurchasedA, amountPurchasedB, percentSavings, percentSavingsA, percentSavingsB;
@property (unsafe_unretained, nonatomic) float qty2Purchase;
@property (strong, nonatomic) Item *itemA, *itemB;
@property (unsafe_unretained, nonatomic, readonly) CalcState calcState;
@property (unsafe_unretained, nonatomic, readonly) BOOL isReady;
@property (strong, nonatomic) NSString *calcStateString;
@property (strong, nonatomic) NSString *toString;

@end
