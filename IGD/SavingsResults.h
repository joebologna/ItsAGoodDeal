//
//  SavingsResults.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/22/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavingsResults : NSObject

+ (SavingsResults *)theSavingsResults;

@property (unsafe_unretained, nonatomic) float betterPrice, normalizedMinQty, qty2Purchase, totalCost, savings, amountPurchased, percentSavings;
@property (strong, nonatomic) NSString *toString;

@end
