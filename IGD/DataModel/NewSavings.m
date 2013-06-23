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
	return [NSString stringWithFormat:@".qty2Purchase: %.2f, .betterPrice: %.2f, .normalizedMinQty: %.2f, .totalCost: %.2f, .totalCostA: %.2f, .totalCostB: %.2f, .savings: %.2f, .savingsA: %.2f, .savingsB: %.2f, .amountPurchased: %.2f, .amountPurchasedA: %.2f, .amountPurchasedB: %.2f, .percentSavings: %.2f, .percentSavingsA: %.2f, .percentSavingsB: %.2f, .percentMoreA: %.0f%%, .percentMoreB: %.0f%%, .itemA: %@, .itemB: %@, .calcState: %@", _qty2Purchase, self.betterPrice, self.normalizedMinQty, self.totalCost, self.totalCostA, self.totalCostB, self.savings, self.savingsA, self.savingsB, self.amountPurchased, self.amountPurchasedA, self.amountPurchasedB, self.percentSavings, self.percentSavingsA, self.percentSavingsB, self.percentMoreA, self.percentMoreB, self.itemA.toString, self.itemB.toString, [self getCalcStateString]];
}

@synthesize isReady = _isReady;
- (BOOL)isReady {
    _isReady = ([self getCalcState] == CalcComplete || _calcState == NeedQty2Purchase);
    return _isReady;
}

@synthesize calcState = _calcState;
- (CalcState)getCalcState {
    _calcState = NotReady;
    if (_itemA != nil && _itemB != nil) {
        if ([_itemA allInputsValid] && [_itemB allInputsValid]) {
            if (_qty2Purchase != INFINITY) {
                _calcState = CalcComplete;
            } else {
                _calcState = NeedQty2Purchase;
            }
        }
    }
    return _calcState;
}

@dynamic calcStateString;
- (NSString *)getCalcStateString {
    switch (_calcState) {
        case  NotReady:
            return @"NotReady";
        case NeedQty2Purchase:
            return @"NeetQty2Purchase";
        case CalcComplete:
            return @"CalcComplete";
    }
}

- (void)resetCalcs {
    _qty2Purchase = INFINITY;
    _calcState = NotReady;
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
	return self.isReady ? MIN(_itemA.pricePerUnit, _itemB.pricePerUnit) : INFINITY;
}

@synthesize normalizedMinQty = _normalizedMinQty;
- (float)normalizedMinQty {
	return self.isReady ? MAX(_itemA.minQty, _itemB.minQty) : INFINITY;
}

@synthesize qty2Purchase = _qty2Purchase;
- (void)setQty2Purchase:(float)qty2Purchase {
    _qty2Purchase = qty2Purchase;
    _itemA.qty2Purchase = _itemB.qty2Purchase = _qty2Purchase;
    _calcState = CalcComplete;
}

@dynamic totalCost;
- (float)totalCost {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.totalCostA;
    } else {
        return self.totalCostB;
    }
}

@dynamic totalCostA;
- (float)totalCostA {
    return self.isReady ? _qty2Purchase * _itemA.pricePerItem : INFINITY;
}

@dynamic totalCostB;
- (float)totalCostB {
    return self.isReady ? _qty2Purchase * _itemB.pricePerItem : INFINITY;
}

@dynamic savings;
- (float)savings {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.isReady ? self.savingsA : INFINITY;
    } else {
        return self.isReady ? self.savingsB : INFINITY;
    }
}

@dynamic savingsA;
- (float)savingsA {
    return self.isReady ? MAX(self.totalCostA, self.totalCostB) - self.totalCostA : INFINITY;
}

@dynamic savingsB;
- (float)savingsB {
    return self.isReady ? MAX(self.totalCostA, self.totalCostB) - self.totalCostB : INFINITY;
}

@dynamic amountPurchased;
- (float)amountPurchased {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.amountPurchasedA;
    } else {
        return self.amountPurchasedB;
    }
}

@dynamic amountPurchasedA;
- (float)amountPurchasedA {
    return self.isReady ? _qty2Purchase * _itemA.unitsPerItem : INFINITY;
}

@dynamic amountPurchasedB;
- (float)amountPurchasedB {
    return self.isReady ? _qty2Purchase * _itemB.unitsPerItem : INFINITY;
}

@dynamic percentSavings;
-(float)percentSavings {
    // A has a better price because the unitPrice is less
    if (_itemA.pricePerUnit < _itemB.pricePerUnit) {
        return self.percentSavingsA;
    } else {
        return self.percentSavingsB;
    }
}

@dynamic percentSavingsA;
- (float)percentSavingsA {
    if (self.isReady) {
        if (TCE(self.savingsA, 0.0)) {
            return 0.0;
        } else {
            return 1.0 - (self.savingsA / MAX(self.savingsA, self.savingsB));
        }
    } else {
        return INFINITY;
    }
}

@dynamic percentSavingsB;
- (float)percentSavingsB {
    if (self.isReady) {
        if (TCE(self.savingsB, 0.0)) {
            return 0.0;
        } else {
            return 1.0 - (self.savingsB / MAX(self.savingsA, self.savingsB));
        }
    } else {
        return INFINITY;
    }
}

@dynamic percentMoreA;
- (float)percentMoreA {
    if (self.isReady) {
        return (_itemA.pricePerUnit / MAX(_itemA.pricePerUnit, _itemB.pricePerUnit)) - 1.0;
    } else {
        return INFINITY;
    }
}

@dynamic percentMoreB;
- (float)percentMoreB {
    if (self.isReady) {
        return (_itemB.pricePerUnit / MAX(_itemA.pricePerUnit, _itemB.pricePerUnit)) - 1.0;
    } else {
        return INFINITY;
    }
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _itemA = _itemB = nil;
        [self resetCalcs];
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
    return newSavings.isReady ? newSavings : nil;
}

@end
