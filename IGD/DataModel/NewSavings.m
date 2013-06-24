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
	return [NSString stringWithFormat:@".qty2Purchase: %.2f, .betterPrice: %.2f, .normalizedMinQty: %.2f, .totalCost: %.2f, .totalCostA: %.2f, .totalCostB: %.2f, .savings: %.2f, .savingsA: %.2f, .savingsB: %.2f, .amountPurchased: %.2f, .amountPurchasedA: %.2f, .amountPurchasedB: %.2f, .percentSavings: %.2f, .percentSavingsA: %.2f, .percentSavingsB: %.2f, .percentMoreProductA: %.0f%%, .percentMoreProductB: %.0f%%, .itemA: %@, .itemB: %@, .betterItem: %@, .calcState: %@", _qty2Purchase, self.betterPricePerUnit, self.normalizedMinQty, self.totalCost, self.totalCostA, self.totalCostB, self.savings, self.savingsA, self.savingsB, self.amountPurchased, self.amountPurchasedA, self.amountPurchasedB, self.percentSavings*100.0, self.percentSavingsA*100.0, self.percentSavingsB*100.0, self.percentMoreProductA*100.0, self.percentMoreProductB*100.0, self.itemA.toString, self.itemB.toString, self.betterItem, [self getCalcStateString]];
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

@dynamic betterItem;
- (Item *)betterItem {
    if (_itemA == nil || _itemB == nil || _itemA.pricePerUnit == INFINITY || _itemB.pricePerUnit == INFINITY) {
        return nil;
    } else if (_itemA.pricePerItem <= _itemB.pricePerItem) {
        return _itemA;
    } else {
        return _itemB;
    }
}

@synthesize betterPricePerUnit = _betterPrice;
- (float)betterPricePerUnit {
	return self.isReady ? self.betterItem.pricePerUnit : INFINITY;
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
    return [_itemA isEqual:self.betterItem] ? self.totalCostA : self.totalCostB;
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
        return [_itemA isEqual:self.betterItem] ? self.savingsA : self.savingsB;
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
    return [_itemA isEqual:self.betterItem] ? self.amountPurchasedA : self.amountPurchasedB;
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
    return [self.betterItem isEqual:_itemA] ? self.percentSavingsA : self.percentSavingsB;
}

@dynamic percentSavingsA;
- (float)percentSavingsA {
    if (self.isReady) {
        return 1.0 - (self.savingsA / MAX(self.savingsA, self.savingsB));
    }
    return INFINITY;
}

@dynamic percentSavingsB;
- (float)percentSavingsB {
    if (self.isReady) {
        return 1.0 - (self.savingsA / MAX(self.savingsA, self.savingsB));
    }
    return INFINITY;
}

@dynamic percentMoreProductA;
- (float)percentMoreProductA {
    if (self.isReady) {
        return (_itemA.amountPurchased / MAX(_itemA.amountPurchased, _itemB.amountPurchased)) - 1.0;
    } else {
        return INFINITY;
    }
}

@dynamic percentMoreProductB;
- (float)percentMoreProductB {
    if (self.isReady) {
        return (_itemB.amountPurchased / MAX(_itemA.amountPurchased, _itemB.amountPurchased)) - 1.0;
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
