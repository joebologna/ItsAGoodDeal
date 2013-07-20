//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"

@implementation Field

@dynamic rectToString;
- (NSString *)rectToString {
    return [NSString stringWithFormat:@"{x:%.2f, y:%.2f, w:%.2f, h:%.2f}", _rect.origin.x, _rect.origin.y, _rect.size.width, _rect.size.height];
}

@dynamic fTagToString;
- (NSString *)fTagToString {
	switch(_tag) {
        case ItemA: return @"ItemA";
        case ItemB: return @"ItemB";
        case BetterDealA: return @"BetterDealA";
        case BetterDealB: return @"BetterDealB";
        case PriceA: return @"PriceA";
        case QtyA: return @"QtyA";
        case SizeA: return @"SizeA";
        case Qty2BuyA: return @"Qty2BuyA";
        case PriceB: return @"PriceB";
        case QtyB: return @"QtyB";
        case SizeB: return @"SizeB";
        case Qty2BuyB: return @"Qty2BuyB";
        case Message: return @"Message";
        case CostField: return @"CostField";
        case SavingsField: return @"SavingsField";
        case MoreField: return @"MoreField";
        case CostLabel: return @"CostLabel";
        case SavingsLabel: return @"SavingsLabel";
        case MoreLabel: return @"MoreLabel";
        case Ad: return @"Ad";
        case FtagNotSet: return @"FtagNotSet";
        default: return @"OOPS!";
    }
}

@dynamic toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".rect:%@, f:%.2f, label:%@, tag:%@", self.rectToString, _f, _label, self.fTagToString];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        //NSLog(@"%s", __func__);
#endif
        _rect = CGRectMake(0, 0, 0, 0);
        _f = [UIFont systemFontSize];
        _label = @"";
        _tag = FtagNotSet;
    }
    return self;
}

+ (Field *)allocField {
    return [[Field alloc] init];
}

+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andLabel:(NSString *)l andTag:(FTAG)tag {
    Field *t = [[Field alloc] init];
    t.rect = r;
    t.f = f;
    t.label = l;
    t.tag = tag;
    return t;
}

@end
