//
//  Item.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"%@ {.price: %.2f, .minQty: %.2f, .unitsPerItem: %.2f, .qty2Buy: %.2f, .pricePerUnit: %.2f, .pricePerItem: %.2f, .amountPurchased: %.2f}", self.name, self.price, self.minQty, self.unitsPerItem, self.qty2Buy, self.pricePerUnit, self.pricePerItem, self.amountPurchased];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _name = @"Item";
        _price = _minQty = _unitsPerItem = _qty2Buy = _pricePerUnit = _pricePerItem = _amountPurchased = 0.0;
    }
    return self;
}

+ (Item *)theItem {
    return [[Item alloc] init];
}

+ (Item *)theItemWithName:(NSString *)name price:(float)price minQty:(float)minQty unitsPerItem:(float)unitsPerItem qty2Buy:(float)qty2Buy {
    Item *item = [[Item alloc] init];
    item.name = name;
	item.price = price;
    item.minQty = minQty;
    item.unitsPerItem = unitsPerItem;
    item.qty2Buy = qty2Buy;
    // this is wrong, need to check for divide by 0 & update when price, qty, size or qty2Buy is updated
    item.pricePerItem = price / minQty;
    item.amountPurchased = item.unitsPerItem * qty2Buy;
    item.pricePerUnit = item.pricePerItem / item.qty2Buy;
    return item;
}

@end
