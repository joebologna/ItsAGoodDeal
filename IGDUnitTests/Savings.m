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
        self.itemA = [Item theItemWithName:@"A" price:INFINITY minQty:INFINITY unitsPerItem:INFINITY];
        self.itemB = [Item theItemWithName:@"B" price:INFINITY minQty:INFINITY unitsPerItem:INFINITY];
        self.moneySaved = INFINITY;
        self.sizeDiff = INFINITY;
        self.percentFewerUnits = INFINITY;
        self.percentMoreProduct = INFINITY;
        self.adjMoneySaved = INFINITY;
        self.calcResult = CalcIncomplete;
        self.cost = INFINITY;
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
    return (self.itemA.pricePerUnit <= self.itemB.pricePerUnit) ? self.itemA : self.itemB;
}

- (Item *)getWorst {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    return (self.itemA.pricePerUnit >= self.itemB.pricePerUnit) ? self.itemA : self.itemB;
}

- (NSString *)getCalcResultString {
    switch (self.calcResult) {
        case CalcIncomplete:
            return @"CalcIncomplete";
        case NeedQty2Purchase:
            return @"NeedQty2Purchase";
        case NeedValidQty2Purchase:
            return @"NeedValidQty2Purchase";
        case CalcComplete:
            return @"CalcComplete";
    }
}

- (CalcResult)calcSavings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

    BOOL ok = [self.itemA.name isEqualToString:@"A"] && ![self.itemA allInputsValid] && ![self.itemA allOutputsValid] &&  self.itemA.qty2Purchase == INFINITY;
    ok = ok & [self.itemB.name isEqualToString:@"B"] && ![self.itemB allInputsValid] && ![self.itemB allOutputsValid] &&  self.itemB.qty2Purchase == INFINITY;

    if (ok) {
        self.calcResult = CalcIncomplete;
    } else if (![self.itemA qty2PurchaseValid] || ![self.itemB qty2PurchaseValid]) {
        self.calcResult = NeedQty2Purchase;
    } else {
        // this code make sure the qty2Purchase is multiple of the minQty supplied
        float rA = remainderf(self.itemA.qty2Purchase, self.itemA.minQty);
        float rB = remainderf(self.itemB.qty2Purchase, self.itemB.minQty);
        if (rA != 0.0f || rB != 0.0f) {
            self.calcResult = NeedValidQty2Purchase;
        } else {
            Item *best = self.getBest;
            Item *worst = self.getWorst;
            self.moneySaved = (worst.pricePerItem - best.pricePerItem) * best.qty2Purchase;
            // move cost to Item class, access savings via self.getBest.cost
            self.cost = best.pricePerItem * best.qty2Purchase;
            self.sizeDiff = best.amountPurchased - worst.amountPurchased;
            self.percentFewerUnits = (1 - (worst.amountPurchased / best.amountPurchased)) * 100.0f;
            self.percentMoreProduct = (1 - (best.amountPurchased / worst.amountPurchased)) * 100.0f;
            self.adjMoneySaved = self.moneySaved * (best.amountPurchased / worst.amountPurchased);
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
