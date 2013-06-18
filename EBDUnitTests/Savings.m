//
//  Savings.m
//  EvenBetterDeal
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
        NSLog(@"%s", __func__);
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
    NSLog(@"%s", __func__);
    return (self.itemA.unitCost <= self.itemB.unitCost) ? self.itemA : self.itemB;
}

- (Item *)getWorst {
    NSLog(@"%s", __func__);
    return (self.itemA.unitCost >= self.itemB.unitCost) ? self.itemA : self.itemB;
}

- (NSString *)getCalcResultString {
    switch (self.calcResult) {
        case CalcIncomplete:
            return @"CalcIncomplete";
        case NeedQty2Buy:
            return @"NeedQty2Buy";
        case CalcComplete:
            return @"CalcComplete";
    }
}

- (CalcResult)calcSavings {
    NSLog(@"%s", __func__);
    float minQty = MAX(self.itemA.qty, self.itemB.qty);
    
    if (self.itemA.qty == NO_QTY || self.itemB.qty == NO_QTY) {
        self.calcResult = CalcIncomplete;
    } else if (self.itemA.qty <= 0 || self.itemB.qty <= 0 || self.itemA.qty2Buy != self.itemB.qty2Buy || minQty <= 0 || self.itemA.qty2Buy < minQty || self.itemB.qty2Buy < minQty) {
        self.calcResult = NeedQty2Buy;
    } else {
        Item *best = self.getBest;
        Item *worst = self.getWorst;
        self.moneySaved = (worst.pricePerItem - best.pricePerItem) * best.qty2Buy;
        // move cost to Item class, access savings via self.getBest.cost
        self.cost = best.pricePerItem * best.qty2Buy;
        self.sizeDiff = best.sizeBought - worst.sizeBought;
        self.percentFewerUnits = (1 - (best.sizeBought / worst.sizeBought)) * 100;
        self.percentMoreProduct = 100 - self.percentFewerUnits;
        self.adjMoneySaved = self.moneySaved * (best.sizeBought / worst.sizeBought);
        self.calcResult = CalcComplete;
        [self logSelf:self];
    }
    return self.calcResult;
}

- (NSString *)getResult {
    NSString *result = @"No result yet";
    if (self.moneySaved >= 0.001) {
        result = [NSString stringWithFormat:@"%@ is Better, Cost %.2f, Savings %.2f", self.getBest.name, self.cost, self.moneySaved];
    } else {
        if (self.percentMoreProduct >= 1) {
            result = [NSString stringWithFormat:@"A = B, Cost %.2f, %.0f%% More Product", self.cost, self.percentMoreProduct];
        } else if (self.percentMoreProduct <= -1) {
            // this may never happen
            result = [NSString stringWithFormat:@"A = B, Cost %.2f, %.0f%% Less Product", self.cost, -self.percentMoreProduct];
        } else {
            result = [NSString stringWithFormat:@"Same Deal, Cost %.2f", self.cost];
        }
    }
    return result;
}

@end
