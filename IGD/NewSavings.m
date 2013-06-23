//
//  NewSavings.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/22/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "NewSavings.h"

@implementation NewSavings

@synthesize toString = _toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".qty2Purchase: %.2f, .betterPrice: %.2f, .normalizedMinQty: %.2f, .totalCost: %.2f, .totalCostA: %.2f, .totalCostB: %.2f, .savings: %.2f, .savingsA: %.2f, .savingsB: %.2f, .amountPurchased: %.2f, .amountPurchasedA: %.2f, .amountPurchasedB: %.2f, .percentSavings: %.2f, .percentSavingsA: %.2f, .percentSavingsB: %.2f, .itemA: %@, .itemB: %@", _qty2Purchase, self.betterPrice, self.normalizedMinQty, self.totalCost, self.totalCostA, self.totalCostB, self.savings, self.savingsA, self.savingsB, self.amountPurchased, self.amountPurchasedA, self.amountPurchasedB, self.percentSavings, self.percentSavingsA, self.percentSavingsB, self.itemA, self.itemB];
}

- (void)resetCalcs {
    _qty2Purchase = INFINITY;
}

- (BOOL)notReady {
    return _qty2Purchase == INFINITY || _itemA == nil || _itemB == nil || ![_itemA isValid] || ![_itemB isValid];
}

@synthesize itemA = _itemA;
- (void)setItemA:(Item *)itemA {
    _itemA = itemA;
}

@synthesize itemB = _itemB;
- (void)setItemB:(Item *)itemB {
    _itemB = itemB;
}

@synthesize betterPrice = _betterPrice;
- (float)betterPrice {
	return self.notReady ? INFINITY : MIN(_itemA.pricePerUnit, _itemB.pricePerUnit);
}

@synthesize normalizedMinQty = _normalizedMinQty;
- (float)normalizedMinQty {
	return self.notReady ? INFINITY : MAX(_itemA.minQty, _itemB.minQty);
}

@synthesize qty2Purchase = _qty2Purchase;
- (void)setQty2Purchase:(float)qty2Purchase {
    _qty2Purchase = qty2Purchase;
    if (self.notReady) {
        return;
    } else {
        _itemA.qty2Purchase = _itemB.qty2Purchase = _qty2Purchase;
    }
}

@synthesize totalCost = _totalCost;
- (float)totalCost {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.notReady ? INFINITY : _qty2Purchase * _itemA.pricePerItem;
    } else {
        return self.notReady ? INFINITY : _qty2Purchase * _itemB.pricePerItem;
    }
}
@synthesize totalCostA = _totalCostA;
- (float)totalCostA {
    return self.notReady ? INFINITY : _qty2Purchase * _itemA.pricePerItem;
}

@synthesize totalCostB = _totalCostB;
- (float)totalCostB {
    return self.notReady ? INFINITY : _qty2Purchase * _itemB.pricePerItem;
}

@synthesize savings = _savings;
- (float)savings {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.notReady ? INFINITY : _savingsA;
    } else {
        return self.notReady ? INFINITY : _savingsB;
    }
}

@synthesize savingsA = _savingsA;
- (float)savingsA {
    return self.notReady ? INFINITY : MAX(self.totalCostA, self.totalCostB) - self.totalCostA;
}

@synthesize savingsB = _savingsB;
- (float)savingsB {
    return self.notReady ? INFINITY : MAX(self.totalCostA, self.totalCostB) - self.totalCostB;
}

@synthesize amountPurchased = _amountPurchased;
- (float)amountPurchased {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.notReady ? INFINITY : self.amountPurchasedA;
    } else {
        return self.notReady ? INFINITY : self.amountPurchasedB;
    }
}

@synthesize amountPurchasedA = _amountPurchasedA;
- (float)amountPurchasedA {
    return self.notReady ? INFINITY : _qty2Purchase * _itemA.unitsPerItem;
}

@synthesize amountPurchasedB = _amountPurchasedB;
- (float)amountPurchasedB {
    return self.notReady ? INFINITY : _qty2Purchase * _itemB.unitsPerItem;
}

@synthesize percentSavings = _percentSavings;
-(float)percentSavings {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.notReady ? INFINITY : self.percentSavingsA;
    } else {
        return self.notReady ? INFINITY : self.percentSavingsB;
    }
}

@synthesize percentSavingsA = _percentSavingsA;
- (float)percentSavingsA {
    return self.notReady ? INFINITY : 1 - (_amountPurchasedA / self.amountPurchased);
}

@synthesize percentSavingsB = _percentSavingsB;
- (float)percentSavingsB {
    return self.notReady ? INFINITY : 1 - (_amountPurchasedB / self.amountPurchased);
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        [self resetCalcs];
        _itemA = _itemB = nil;
    }
    return self;
}

+ (NewSavings *)theNewSavings {
    return [[NewSavings alloc] init];
}

+ (NewSavings *)theNewSavingsWithItemA:(Item *)itemA withItemB:(Item *)itemB {
    NewSavings *newSavings = [[NewSavings alloc] init];
    newSavings.itemA = itemA;
    newSavings.itemB = itemB;
    return newSavings;
}

@end
