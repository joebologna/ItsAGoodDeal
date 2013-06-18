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
    return [NSString stringWithFormat:@"Savings: {\n\t.itemA: %@,\n\t.itemB: %@\n},\nmoneySaved: %.2f, sizeDiff: %.2f", self.itemA.toString, self.itemB.toString, self.moneySaved, self.sizeDiff];
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
        self.itemA = [Item theItemWithName:@"Item A" price:0 qty:0 size:0 qty2Buy:0];
        self.itemB = [Item theItemWithName:@"Item B" price:0 qty:0 size:0 qty2Buy:0];
        self.moneySaved = 0;
        self.sizeDiff = 0;
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

- (void)calcSavings {
    NSLog(@"%s", __func__);
    float minQty = MAX(self.itemA.qty, self.itemB.qty);
    
    if (self.itemA.qty <= 0 || self.itemB.qty <= 0 || self.itemA.qty2Buy != self.itemB.qty2Buy || minQty <= 0 || self.itemA.qty2Buy < minQty || self.itemB.qty2Buy < minQty) {
        [NSException raise:@"Incorrect Qty" format:@"qty2Buy < minQty:\n%@", self.toString];
    }
    
    Item *best = self.getBest;
    Item *worst = self.getWorst;
    self.moneySaved = (worst.pricePerItem - best.pricePerItem) * best.qty2Buy;
    
    self.sizeDiff = best.size - worst.size;
    [self logSelf:self];
}

@end
