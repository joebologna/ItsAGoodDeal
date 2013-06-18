//
//  Item.m
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"%@ {.price: %.2f, .qty: %.2f, .size: %.2f, .qty2Buy: %.2f, .unitCost: %.2f, .pricePerItem: %.2f, .sizeBought: %.2f}", self.name, self.price, self.qty, self.size, self.qty2Buy, self.unitCost, self.pricePerItem, self.sizeBought];
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
        self.name = @"Item";
        self.price = 0;
        self.qty = 0;
        self.size = 0;
        self.qty2Buy = 0;
        self.unitCost = 0;
        self.pricePerItem = 0;
        self.sizeBought = 0;
    }
    return self;
}

+ (Item *)theItem {
    return [[Item alloc] init];
}

+ (Item *)theItemWithName:(NSString *)name price:(float)price qty:(float)qty size:(float)size qty2Buy:(float)qty2Buy {
    Item *item = [[Item alloc] init];
    item.price = price;
    item.name = name;
    item.qty = qty;
    item.size = size;
    item.qty2Buy = qty2Buy;
    item.pricePerItem = price / qty;
    item.unitCost = item.pricePerItem / size;
    item.sizeBought = size * qty2Buy;
    return item;
}

@end
