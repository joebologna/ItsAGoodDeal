//
//  NewSavings.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/22/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface NewSavings : NSObject

+ (NewSavings *)theNewSavings;
+ (NewSavings *)theNewSavingsWithItemA:(Item *)itemA withItemB:(Item *)itemB;

- (BOOL)notReady;

@property (unsafe_unretained, nonatomic, readonly) float betterPrice, normalizedMinQty, totalCost, totalCostA, totalCostB, savings, savingsA, savingsB, amountPurchased, amountPurchasedA, amountPurchasedB, percentSavings, percentSavingsA, percentSavingsB;
@property (unsafe_unretained, nonatomic) float qty2Purchase;
@property (strong, nonatomic) Item *itemA, *itemB;
@property (strong, nonatomic) NSString *toString;

@end
