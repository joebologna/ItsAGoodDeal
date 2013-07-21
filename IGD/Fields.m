//
//  Fields.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Fields.h"

@implementation Fields

@dynamic deviceTypeString;
- (NSString *)deviceTypeString {
    switch(_deviceType) {
        case iPhone4: return @"iPhone4";
        case iPhone5: return @"iPhone5";
        case iPad: return @"iPad";
        case UnknownDeviceType: return @"UnknownDeviceType";
        default: return @"Ooops!";
    }
}

@synthesize toString = _toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".deviceType: %@", self.deviceTypeString];
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _deviceType = UnknownDeviceType;

        _itemA = nil; _itemB = nil;
        _betterDealA = nil; _betterDealB = nil;

        _priceA = nil;
        _qtyA = nil; _sizeA = nil;
        _qty2BuyA = nil;

        _priceB = nil;
        _qtyB = nil; _sizeB = nil;
        _qty2BuyB = nil;

        _message = nil;

        _costField = nil; _savingsField = nil; _moreField = nil;
        _costLabel = nil; _savingsLabel = nil; _moreLabel = nil;

        _ad = nil;
    }
    return self;
}

+ (Fields *)allocFields {
    return [[Fields alloc] init];
}

+ (Fields *)allocFieldsWithDeviceType:(DeviceType)d {
    Fields *f = [[Fields alloc] init];
    f.deviceType = d;
    switch (d) {
        case iPhone4:
            [self buildIPhone4:f];
            break;
        case iPhone5:
            [self buildIPhone5:f];
            break;
        case iPad:
            [self buildIPad:f];
            break;
            
        default:
            break;
    }
    return f;
}

// builders
+ (void)buildIPhone4:(Fields *)f {
    NSLog(@"%s", __func__);
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andLabel:@"Deal A" andTag:ItemA];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andLabel:@"Deal B" andTag:ItemB];

    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:8 andLabel:@"" andTag:BetterDealA];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:8 andLabel:@"" andTag:BetterDealB];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andLabel:@"Price A" andTag:PriceA];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 58, 64, 30) andF:17 andLabel:@"MinQty" andTag:QtyA];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(82, 58, 64, 30) andF:17 andLabel:@"Size" andTag:SizeA];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(38, 96, 80, 30) andF:17 andLabel:@"# to Buy" andTag:Qty2BuyA];

    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andLabel:@"Price B" andTag:PriceB];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(174, 58, 64, 30) andF:17 andLabel:@"MinQty" andTag:QtyB];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(246, 58, 64, 30) andF:17 andLabel:@"Size" andTag:SizeB];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(202, 96, 80, 30) andF:17 andLabel:@"# to Buy" andTag:Qty2BuyB];

    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andLabel:@"Enter Price, Min Qty & Size of Items" andTag:Message];

    f.costField = [Field allocFieldWithRect:CGRectMake(1, 158, 106, 30) andF:15 andLabel:@"Cost Field" andTag:CostField];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(106, 158, 107, 30) andF:15 andLabel:@"Savings Field" andTag:SavingsField];
    f.moreField = [Field allocFieldWithRect:CGRectMake(212, 158, 106, 30) andF:15 andLabel:@"More Field" andTag:MoreField];

    f.costLabel = [Field allocFieldWithRect:CGRectMake(1, 186, 106, 10) andF:9 andLabel:@"Cost" andTag:CostLabel];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(106, 186, 107, 30) andF:9 andLabel:@"Savings" andTag:SavingsLabel];
    f.moreLabel = [Field allocFieldWithRect:CGRectMake(212, 186, 106, 10) andF:9 andLabel:@"More" andTag:MoreLabel];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 199, 64, 46) andF:15 andLabel:@"1" andTag:One];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 199, 64, 46) andF:15 andLabel:@"2" andTag:Two];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 199, 64, 46) andF:15 andLabel:@"3" andTag:Three];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 199, 64, 46) andF:15 andLabel:@"3" andTag:Clr];

    f.four = [Field allocFieldWithRect:CGRectMake(20, 272, 64, 46) andF:15 andLabel:@"4" andTag:Four];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 272, 64, 46) andF:15 andLabel:@"5" andTag:Five];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 272, 64, 46) andF:15 andLabel:@"6" andTag:Six];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 272, 64, 46) andF:15 andLabel:@CLR andTag:Store];

    f.four = [Field allocFieldWithRect:CGRectMake(20, 325, 64, 46) andF:15 andLabel:@"7" andTag:Seven];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 325, 64, 46) andF:15 andLabel:@"8" andTag:Eight];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 325, 64, 46) andF:15 andLabel:@"9" andTag:Nine];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 325, 64, 46) andF:15 andLabel:@DEL andTag:Del];

    f.period = [Field allocFieldWithRect:CGRectMake(20, 358, 64, 46) andF:15 andLabel:@"." andTag:Period];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 358, 64, 46) andF:15 andLabel:@"0" andTag:Zero];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 358, 136, 46) andF:15 andLabel:@NEXT andTag:Next];
}

+ (void)buildIPhone5:(Fields *)f {
    NSLog(@"%s", __func__);

    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andLabel:@"Deal A" andTag:ItemA];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andLabel:@"Deal B" andTag:ItemB];
    
    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:8 andLabel:@"" andTag:BetterDealA];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:8 andLabel:@"" andTag:BetterDealB];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andLabel:@"Price A" andTag:PriceA];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 58, 64, 30) andF:17 andLabel:@"MinQty" andTag:QtyA];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(82, 58, 64, 30) andF:17 andLabel:@"Size" andTag:SizeA];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(38, 96, 80, 30) andF:17 andLabel:@"# to Buy" andTag:Qty2BuyA];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andLabel:@"Price B" andTag:PriceB];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(174, 58, 64, 30) andF:17 andLabel:@"MinQty" andTag:QtyB];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(246, 58, 64, 30) andF:17 andLabel:@"Size" andTag:SizeB];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(202, 96, 80, 30) andF:17 andLabel:@"# to Buy" andTag:Qty2BuyB];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andLabel:@"Enter Price, Min Qty & Size of Items" andTag:Message];
    
    f.costField = [Field allocFieldWithRect:CGRectMake(1, 158, 106, 30) andF:17 andLabel:@"Cost Field" andTag:CostField];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(106, 158, 107, 30) andF:17 andLabel:@"Savings Field" andTag:SavingsField];
    f.moreField = [Field allocFieldWithRect:CGRectMake(212, 158, 106, 30) andF:17 andLabel:@"More Field" andTag:MoreField];
    
    f.costLabel = [Field allocFieldWithRect:CGRectMake(1, 186, 106, 10) andF:9 andLabel:@"Cost" andTag:CostLabel];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(106, 186, 107, 30) andF:9 andLabel:@"Savings" andTag:SavingsLabel];
    f.moreLabel = [Field allocFieldWithRect:CGRectMake(212, 186, 106, 10) andF:9 andLabel:@"More" andTag:MoreLabel];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 201, 64, 66) andF:15 andLabel:@"1" andTag:One];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 201, 64, 66) andF:15 andLabel:@"2" andTag:Two];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 201, 64, 66) andF:15 andLabel:@"3" andTag:Three];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 201, 64, 66) andF:15 andLabel:@"3" andTag:Clr];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 275, 64, 66) andF:15 andLabel:@"4" andTag:Four];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 275, 64, 66) andF:15 andLabel:@"5" andTag:Five];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 275, 64, 66) andF:15 andLabel:@"6" andTag:Six];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 275, 64, 66) andF:15 andLabel:@CLR andTag:Store];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 349, 64, 66) andF:15 andLabel:@"7" andTag:Seven];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 349, 64, 66) andF:15 andLabel:@"8" andTag:Eight];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 349, 64, 66) andF:15 andLabel:@"9" andTag:Nine];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 349, 64, 66) andF:15 andLabel:@DEL andTag:Del];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 422, 64, 66) andF:15 andLabel:@"." andTag:Period];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 422, 64, 66) andF:15 andLabel:@"0" andTag:Zero];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 422, 136, 66) andF:15 andLabel:@NEXT andTag:Next];
}

+ (void)buildIPad:(Fields *)f {
    NSLog(@"%s", __func__);
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 394, 352) andF:30 andLabel:@"Deal A" andTag:ItemA];
    f.itemB = [Field allocFieldWithRect:CGRectMake(385, 1, 383, 352) andF:30 andLabel:@"Deal B" andTag:ItemB];
    
    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 324, 384, 30) andF:18 andLabel:@"" andTag:BetterDealA];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(384, 324, 384, 30) andF:18 andLabel:@"" andTag:BetterDealB];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 50, 366, 86) andF:48 andLabel:@"Price A" andTag:PriceA];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 144, 177, 86) andF:48 andLabel:@"MinQty" andTag:QtyA];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(199, 144, 177, 86) andF:48 andLabel:@"Size" andTag:SizeA];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(105, 258, 177, 86) andF:17 andLabel:@"# to Buy" andTag:Qty2BuyA];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(393, 50, 366, 86) andF:48 andLabel:@"Price B" andTag:PriceB];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(393, 144, 177, 86) andF:48 andLabel:@"MinQty" andTag:QtyB];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(582, 144, 177, 86) andF:48 andLabel:@"Size" andTag:SizeB];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(488, 238, 177, 86) andF:48 andLabel:@"# to Buy" andTag:Qty2BuyB];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andLabel:@"Enter Price, Min Qty & Size of Items" andTag:Message];
    
    f.costField = [Field allocFieldWithRect:CGRectMake(1, 403, 766, 67) andF:40 andLabel:@"Cost Field" andTag:CostField];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(256, 403, 257, 67) andF:40 andLabel:@"Savings Field" andTag:SavingsField];
    f.moreField = [Field allocFieldWithRect:CGRectMake(212, 158, 106, 30) andF:40 andLabel:@"More Field" andTag:MoreField];
    
    f.costLabel = [Field allocFieldWithRect:CGRectMake(1, 460, 256, 28) andF:25 andLabel:@"Cost" andTag:CostLabel];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(256, 460, 257, 28) andF:25 andLabel:@"Savings" andTag:SavingsLabel];
    f.moreLabel = [Field allocFieldWithRect:CGRectMake(512, 460, 255, 28) andF:25 andLabel:@"More" andTag:MoreLabel];

    f.one = [Field allocFieldWithRect:CGRectMake(20, 546, 176, 92) andF:48 andLabel:@"1" andTag:One];
    f.two = [Field allocFieldWithRect:CGRectMake(204, 546, 176, 92) andF:48 andLabel:@"2" andTag:Two];
    f.three = [Field allocFieldWithRect:CGRectMake(388, 546, 176, 92) andF:48 andLabel:@"3" andTag:Three];
    f.clr = [Field allocFieldWithRect:CGRectMake(572, 546, 176, 92) andF:48 andLabel:@"3" andTag:Clr];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 634, 176, 92) andF:48 andLabel:@"4" andTag:Four];
    f.two = [Field allocFieldWithRect:CGRectMake(204, 634, 176, 92) andF:48 andLabel:@"5" andTag:Five];
    f.three = [Field allocFieldWithRect:CGRectMake(388, 634, 176, 92) andF:48 andLabel:@"6" andTag:Six];
    f.clr = [Field allocFieldWithRect:CGRectMake(572, 634, 176, 92) andF:48 andLabel:@CLR andTag:Store];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 742, 176, 92) andF:48 andLabel:@"7" andTag:Seven];
    f.two = [Field allocFieldWithRect:CGRectMake(204, 742, 176, 92) andF:48 andLabel:@"8" andTag:Eight];
    f.three = [Field allocFieldWithRect:CGRectMake(388, 742, 176, 92) andF:48 andLabel:@"9" andTag:Nine];
    f.clr = [Field allocFieldWithRect:CGRectMake(572, 742, 176, 92) andF:48 andLabel:@DEL andTag:Del];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 840, 176, 92) andF:48 andLabel:@"." andTag:Period];
    f.zero = [Field allocFieldWithRect:CGRectMake(204, 840, 176, 92) andF:48 andLabel:@"0" andTag:Zero];
    f.next = [Field allocFieldWithRect:CGRectMake(388, 840, 136, 66) andF:48 andLabel:@NEXT andTag:Next];
}

@end
