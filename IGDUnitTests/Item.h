//
//  Item.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Formatter.h"

#define NO_QTY -1

@interface Item : NSObject <Logging>


@property (copy, nonatomic) NSString *name;
@property (unsafe_unretained, nonatomic) float price, minQty, unitsPerItem, pricePerUnit, pricePerItem, qty2Buy, amountPurchased;

@property (strong, nonatomic) NSString *toString;

+ (Item *)theItem;
+ (Item *)theItemWithName:(NSString *)name price:(float)price minQty:(float)minQty unitsPerItem:(float)unitsPerItem qty2Buy:(float)qty2Buy;

@end
