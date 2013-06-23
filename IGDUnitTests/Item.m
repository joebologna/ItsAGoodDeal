//
//  Item.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

/*
 Inputs: name, price, minQty
 Updates: qty2Purchase
 Automatic Calculations: unitsPerItem, pricePerUnit, pricePerItem, amountPurchased
 
 Setters update the automatic calculations. Unset properties are INFINITY to detect when automatic calculations should be performed.
 */

#import "Item.h"

@implementation Item

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"%@ {.price: %.2f, .minQty: %.2f, .unitsPerItem: %.2f, .pricePerUnit: %.2f, .pricePerItem: %.2f, .qty2Purchase: %.2f, .amountPurchased: %.2f}", _name, _price, _minQty, _unitsPerItem, _pricePerUnit, _pricePerItem, _qty2Purchase, _amountPurchased];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _name = @"Item";
        _price = _minQty = _unitsPerItem = _pricePerUnit = _pricePerItem = _qty2Purchase = _amountPurchased = INFINITY;
    }
    return self;
}

@synthesize price = _price;
- (void)setPrice:(float)price {
    if (price > 0.0 && price != INFINITY) {
        _price = price;
        if (_unitsPerItem > 0.0 && _unitsPerItem != INFINITY) {
            _pricePerUnit = _price / _unitsPerItem;
        }
        if (_minQty > 0.0 && _minQty != INFINITY) {
            _pricePerItem = _price / _minQty;
        }
    }
}

@synthesize minQty = _minQty;
- (void)setMinQty:(float)minQty {
    if (minQty > 0.0 && minQty != INFINITY) {
        _minQty = minQty;
        [self setPrice:_price];
    }
}

@synthesize unitsPerItem = _unitsPerItem;
- (void)setUnitsPerItem:(float)unitsPerItem {
    if (unitsPerItem > 0.0 && unitsPerItem != INFINITY) {
        _unitsPerItem = unitsPerItem;
        [self setPrice:_price];
        [self setQty2Purchase:_qty2Purchase];
    }
}

@synthesize qty2Purchase = _qty2Purchase;
- (void)setQty2Purchase:(float)qty2Purchase {
    if (qty2Purchase > 0.0 && qty2Purchase != INFINITY) {
        if (_unitsPerItem > 0.0 && _unitsPerItem != INFINITY) {
            _qty2Purchase = qty2Purchase;
            _amountPurchased = _unitsPerItem / _qty2Purchase;
            [self setPrice:_price];
        }
    }
};

+ (Item *)theItem {
    return [[Item alloc] init];
}

+ (Item *)theItemWithName:(NSString *)name price:(float)price minQty:(float)minQty unitsPerItem:(float)unitsPerItem {
    Item *item = [[Item alloc] init];
    item.name = name;
	item.price = price;
    item.minQty = minQty;
    item.unitsPerItem = unitsPerItem;
    return item;
}

- (BOOL)allInputsValid {
    return _price != INFINITY && _minQty != INFINITY && _unitsPerItem != INFINITY;
}

- (BOOL)allOutputsValid {
    return _pricePerUnit != INFINITY && _pricePerItem != INFINITY && _amountPurchased != INFINITY;
}

- (BOOL)qty2PurchaseValid {
    return [self allInputsValid] && [self allOutputsValid] && _qty2Purchase != INFINITY;
}

- (BOOL)isValid {
    return [self qty2PurchaseValid];
}

@end
