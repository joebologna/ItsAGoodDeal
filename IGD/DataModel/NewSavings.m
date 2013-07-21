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
	return [NSString stringWithFormat:@".qty2Purchase: %.2f, .betterPrice: %.2f, .normalizedMinQty: %.2f, .totalCost: %.2f, .totalCostA: %.2f, .totalCostB: %.2f, .savings: %.2f, .savingsA: %.2f, .savingsB: %.2f, .amountPurchased: %.2f, .amountPurchasedA: %.2f, .amountPurchasedB: %.2f, .percentSavings: %.2f, .percentSavingsA: %.2f, .percentSavingsB: %.2f, .percentMoreProductA: %.0f%%, .percentMoreProductB: %.0f%%, .itemA: %@, .itemB: %@, .cheaperItem: %@, .calcState: %@", _qty2Purchase, self.betterPricePerUnit.pricePerUnit, self.normalizedMinQty, self.totalCost, self.totalCostA, self.totalCostB, self.savings, self.savingsA, self.savingsB, self.amountPurchased, self.amountPurchasedA, self.amountPurchasedB, self.percentSavings*100.0, self.percentSavingsA*100.0, self.percentSavingsB*100.0, self.percentMoreProductA*100.0, self.percentMoreProductB*100.0, self.itemA.toString, self.itemB.toString, self.cheaperItem, [self getCalcStateString]];
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
                float r = remainderf(_qty2Purchase, MAX(_itemA.minQty, _itemB.minQty));
                if (r == 0.0) {
                    _calcState = CalcComplete;
                } else {
                    _calcState = NeedQty2Purchase;
                }
            } else {
                _calcState = NeedQty2Purchase;
            }
        }
    }
    return _calcState;
}

- (NSString *)getCalcStateString {
    NSString *s = @"Dunno";
    switch (_calcState) {
        case  NotReady:
            s = @"NotReady";
        case NeedQty2Purchase:
            s = @"NeetQty2Purchase";
        case CalcComplete:
            s = @"CalcComplete";
    }
    return s;
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

@dynamic cheaperItem;
- (Item *)cheaperItem {
    if (_itemA == nil || _itemB == nil || _itemA.pricePerItem == INFINITY || _itemB.pricePerItem == INFINITY) {
        return nil;
    } else if (_itemA.pricePerItem <= _itemB.pricePerItem) {
        return _itemA;
    } else {
        return _itemB;
    }
}

// return the item with a betterPrice per Unit
@dynamic betterPricePerUnit;
- (Item *)betterPricePerUnit {
    if (_itemA == nil || _itemB == nil || _itemA.pricePerUnit == INFINITY || _itemB.pricePerUnit == INFINITY) {
        return nil;
    } else if (_itemA.pricePerUnit <= _itemB.pricePerUnit) {
        return _itemA;
    } else {
        return _itemB;
    }
}

@synthesize normalizedMinQty = _normalizedMinQty;
- (float)normalizedMinQty {
	return self.isReady ? MAX(_itemA.minQty, _itemB.minQty) : INFINITY;
}

@synthesize qty2Purchase = _qty2Purchase;
- (void)setQty2Purchase:(float)qty2Purchase {
#ifdef REQUIRE_MULTIPLE
    if (qty2Purchase != INFINITY && qty2Purchase != 0.0) {
        if (remainderf(qty2Purchase, self.normalizedMinQty) == 0.0) {
            _qty2Purchase = qty2Purchase;
            _itemA.qty2Purchase = _itemB.qty2Purchase = _qty2Purchase;
            _calcState = CalcComplete;
        } else {
            _calcState = NeedQty2Purchase;
        }
    }
#else
    if (qty2Purchase != INFINITY && qty2Purchase != 0.0) {
        _qty2Purchase = qty2Purchase;
        _itemA.qty2Purchase = _itemB.qty2Purchase = _qty2Purchase;
        _calcState = CalcComplete;
    }
#endif
}

@dynamic totalCost;
- (float)totalCost {
    return [_itemA isEqual:self.cheaperItem] ? self.totalCostA : self.totalCostB;
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
    if (self.isReady) {
        return [_itemA isEqual:self.cheaperItem] ? self.savingsA : self.savingsB;
    }
    return INFINITY;
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
    return [_itemA isEqual:self.cheaperItem] ? self.amountPurchasedA : self.amountPurchasedB;
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
    return [self.cheaperItem isEqual:_itemA] ? self.percentSavingsA : self.percentSavingsB;
}

@dynamic percentSavingsA;
- (float)percentSavingsA {
    if (self.isReady) {
        return 1.0 - (self.totalCostA / MAX(self.totalCostA, self.totalCostB));
    }
    return INFINITY;
}

@dynamic percentSavingsB;
- (float)percentSavingsB {
    if (self.isReady) {
        return 1.0 - (self.totalCostB / MAX(self.totalCostA, self.totalCostB));
    }
    return INFINITY;
}

@dynamic percentMoreProductA;
- (float)percentMoreProductA {
    if (self.isReady) {
        return (_itemA.amountPurchased / _itemB.amountPurchased) - 1.0;
//        return (_itemA.amountPurchased / MAX(_itemA.amountPurchased, _itemB.amountPurchased)) - 1.0;
    } else {
        return INFINITY;
    }
}

@dynamic percentMoreProductB;
- (float)percentMoreProductB {
    if (self.isReady) {
        return (_itemB.amountPurchased / _itemA.amountPurchased) - 1.0;
//        return (_itemB.amountPurchased / MAX(_itemA.amountPurchased, _itemB.amountPurchased)) - 1.0;
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
