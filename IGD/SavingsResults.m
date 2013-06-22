//
//  SavingsResults.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/22/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "SavingsResults.h"

@implementation SavingsResults

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"{.betterPrice: %.2f, .qty2Purchase: %.2f, .totalCost: %.2f, .savings: %.2f, .amountPurchased: %.2f, .percentSavings: %.2f}", self.betterPrice, self.qty2Purchase, self.totalCost, self.savings, self.amountPurchased, self.percentSavings];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _betterPrice = _normalizedMinQty = _qty2Purchase = _totalCost = _savings = _amountPurchased = _percentSavings = 0.0;
    }
    return self;
}

+ (SavingsResults *)theSavingsResults {
    return [[SavingsResults alloc] init];
}
@end
