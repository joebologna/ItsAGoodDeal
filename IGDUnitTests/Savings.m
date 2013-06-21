//
//  Savings.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Savings.h"
#import "NSObject+Formatter.h"

@implementation Savings

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"Savings: {\n\t.itemA: %@,\n\t.itemB: %@\n},\nmoneySaved: %.2f, sizeDiff: %.2f, percentFewerUnits: %.2f, adjMoneySaved: %.2f, calcResult: %@, cost: %.2f, percentMoreProduct: %.2f", self.itemA.toString, self.itemB.toString, self.moneySaved, self.sizeDiff, self.percentFewerUnits, self.adjMoneySaved, self.getCalcResultString, self.cost, self.percentMoreProduct];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        self.itemA = [Item theItemWithName:@"Item A" price:0 qty:0 size:0 qty2Buy:NO_QTY];
        self.itemB = [Item theItemWithName:@"Item B" price:0 qty:0 size:0 qty2Buy:NO_QTY];
        self.moneySaved = 0;
        self.sizeDiff = 0;
        self.percentFewerUnits = 0;
        self.percentMoreProduct = 0;
        self.adjMoneySaved = 0;
        self.calcResult = CalcIncomplete;
        self.cost = 0;
    }
    return self;
}

+ (Savings *)theSavings {
    return [[Savings alloc] init];
}

+ (Savings *)theSavingsWithItemA:(Item *)itemA itemB:(Item *)itemB {
    Savings *savings = [[Savings alloc] init];
    savings.itemA = itemA;
    savings.itemB = itemB;
    return savings;
}

- (Item *)getBest {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    return (self.itemA.unitCost <= self.itemB.unitCost) ? self.itemA : self.itemB;
}

- (Item *)getWorst {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    return (self.itemA.unitCost >= self.itemB.unitCost) ? self.itemA : self.itemB;
}

- (NSString *)getCalcResultString {
    switch (self.calcResult) {
        case CalcIncomplete:
            return @"CalcIncomplete";
        case NeedQty2Buy:
            return @"NeedQty2Buy";
        case NeedValidQty2Buy:
            return @"NeedValidQty2Buy";
        case CalcComplete:
            return @"CalcComplete";
    }
}

- (CalcResult)calcSavings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    float minQty = MAX(self.itemA.qty, self.itemB.qty);
    
    if (self.itemA.price == 0.0f || self.itemA.qty == 0.0f || self.itemA.size == 0.0f || self.itemA.qty == NO_QTY ||
        self.itemB.price == 0.0f || self.itemB.qty == 0.0f || self.itemB.size == 0.0f || self.itemB.qty == NO_QTY) {
        self.calcResult = CalcIncomplete;
    } else if (self.itemA.qty <= 0.0f || self.itemB.qty <= 0.0f || self.itemA.qty2Buy != self.itemB.qty2Buy || minQty <= 0.0f || self.itemA.qty2Buy < minQty || self.itemB.qty2Buy < minQty) {
        self.calcResult = NeedQty2Buy;
    } else {
        float rA = remainderf(self.itemA.qty2Buy, self.itemA.qty);
        float rB = remainderf(self.itemB.qty2Buy, self.itemB.qty);
        if (rA != 0.0f || rB != 0.0f) {
            self.calcResult = NeedValidQty2Buy;
        } else {
            Item *best = self.getBest;
            Item *worst = self.getWorst;
            self.moneySaved = (worst.pricePerItem - best.pricePerItem) * best.qty2Buy;
            // move cost to Item class, access savings via self.getBest.cost
            self.cost = best.pricePerItem * best.qty2Buy;
            self.sizeDiff = best.sizeBought - worst.sizeBought;
            self.percentFewerUnits = (1 - (worst.sizeBought / best.sizeBought)) * 100.0f;
            self.percentMoreProduct = (1 - (best.sizeBought / worst.sizeBought)) * 100.0f;
            self.adjMoneySaved = self.moneySaved * (best.sizeBought / worst.sizeBought);
            self.calcResult = CalcComplete;
            [self logSelf:self];
        }
    }
    return self.calcResult;
}

- (NSDictionary *)getResults {
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
              @"", kCost,
              @"not results yet", kSavings,
              @"", kMore, nil];
    if (self.moneySaved >= 0.001f) {
        result = [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSString stringWithFormat:@"%.2f", self.cost], kCost,
                  [NSString stringWithFormat:@"%.2f", self.moneySaved], kSavings,
                  [NSString stringWithFormat:@"%.0f%%", self.percentMoreProduct], kMore, nil];
    } else {
        if (self.percentMoreProduct >= 1.0f) {
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSString stringWithFormat:@"%.2f", self.cost], kCost,
                      [NSString stringWithFormat:@"%.2f", self.moneySaved], kSavings,
                      [NSString stringWithFormat:@"%.0f%%", self.percentMoreProduct], kMore, nil];
        } else if (self.percentMoreProduct <= -1) {
            // this may never happen
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSString stringWithFormat:@"%.2f", self.cost], kCost,
                      [NSString stringWithFormat:@"%.2f", self.moneySaved], kSavings,
                      [NSString stringWithFormat:@"%.0f%%", self.percentMoreProduct], kMore, nil];
        } else {
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSString stringWithFormat:@"%.2f", self.cost], kCost,
                      [NSString stringWithFormat:@"%.2f", self.moneySaved], kSavings,
                      @"0", kMore, nil];
        }
    }
    return result;
}

@end
