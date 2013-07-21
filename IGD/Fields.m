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
        _vc = nil;
    }
    return self;
}

- (Fields *)makeFields:(UIViewController *)vc {
    self.vc = vc;
    // iPhone 4 = 480, iPhone 5 = 568, iPad > 568
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height <= 480) {
        self.deviceType = iPhone4;
    } else if (height > 480 && height <= 568) {
        self.deviceType = iPhone5;
    } else {
        self.deviceType = iPad;
    }
    switch (self.deviceType) {
        case iPhone4:
            [self buildIPhone4:self];
            break;
        case iPhone5:
            [self buildIPhone5:self];
            break;
        case iPad:
            [self buildIPad:self];
            break;
            
        default:
            break;
    }
    self.inputFields = [NSArray arrayWithObjects:self.priceA, self.priceB, self.qtyA, self.qtyB, self.sizeA, self.sizeB, self.qty2BuyA, self.qty2BuyB, nil];
    self.allFields = [NSArray arrayWithObjects:self.priceA, self.priceB, self.qtyA, self.qtyB, self.sizeA, self.sizeB, self.qty2BuyA, self.qty2BuyB, self.itemA, self.itemB, self.betterDealA, self.betterDealB, self.message, self.costField, self.savingsField, self.moreField, self.costLabel, self.savingsLabel, self.moreLabel, nil];
    self.keys = [NSArray arrayWithObjects:self.one, self.two, self.three, self.four, self.five, self.six, self.seven, self.eight, self.nine, self.zero, self.period, self.clr, self.store, self.del, self.next, nil];
    return self;
}

// builders
- (void)buildIPhone4:(Fields *)f {
    NSLog(@"%s", __func__);
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc];

    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 126, 138, 30) andF:8 andValue:@"" andTag:BetterDealA andType:LabelField andVC:f.vc];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(174, 126, 138, 30) andF:8 andValue:@"" andTag:BetterDealB andType:LabelField andVC:f.vc];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andValue:@"Price A" andTag:PriceA andType:LabelField andVC:f.vc];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 58, 64, 30) andF:17 andValue:@"MinQty" andTag:QtyA andType:LabelField andVC:f.vc];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(82, 58, 64, 30) andF:17 andValue:@"Size" andTag:SizeA andType:LabelField andVC:f.vc];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(38, 96, 80, 30) andF:17 andValue:@"# to Buy" andTag:Qty2BuyA andType:LabelField andVC:f.vc];

    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andValue:@"Price B" andTag:PriceB andType:LabelField andVC:f.vc];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(174, 58, 64, 30) andF:17 andValue:@"MinQty" andTag:QtyB andType:LabelField andVC:f.vc];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(246, 58, 64, 30) andF:17 andValue:@"Size" andTag:SizeB andType:LabelField andVC:f.vc];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(202, 96, 80, 30) andF:17 andValue:@"# to Buy" andTag:Qty2BuyB andType:LabelField andVC:f.vc];

    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@"Enter Price, Min Qty & Size of Items" andTag:Message andType:LabelField andVC:f.vc];

    f.costField = [Field allocFieldWithRect:CGRectMake(1, 158, 106, 30) andF:15 andValue:@"Cost Field" andTag:CostField andType:LabelField andVC:f.vc];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(106, 158, 107, 30) andF:15 andValue:@"Savings Field" andTag:SavingsField andType:LabelField andVC:f.vc];
    f.moreField = [Field allocFieldWithRect:CGRectMake(212, 158, 106, 30) andF:15 andValue:@"More Field" andTag:MoreField andType:LabelField andVC:f.vc];

    f.costLabel = [Field allocFieldWithRect:CGRectMake(1, 188, 106, 10) andF:9 andValue:@"Cost" andTag:CostLabel andType:LabelField andVC:f.vc];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(106, 188, 107, 10) andF:9 andValue:@"Savings" andTag:SavingsLabel andType:LabelField andVC:f.vc];
    f.moreLabel = [Field allocFieldWithRect:CGRectMake(212, 188, 106, 10) andF:9 andValue:@"More" andTag:MoreLabel andType:LabelField andVC:f.vc];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 199, 64, 46) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 199, 64, 46) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 199, 64, 46) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 199, 64, 46) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc];

    f.four = [Field allocFieldWithRect:CGRectMake(20, 252, 64, 46) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc];
    f.five = [Field allocFieldWithRect:CGRectMake(92, 252, 64, 46) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc];
    f.six = [Field allocFieldWithRect:CGRectMake(164, 252, 64, 46) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc];
    f.store = [Field allocFieldWithRect:CGRectMake(236, 252, 64, 46) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc];

    f.seven = [Field allocFieldWithRect:CGRectMake(20, 305, 64, 46) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, 305, 64, 46) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, 305, 64, 46) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc];
    f.del = [Field allocFieldWithRect:CGRectMake(236, 305, 64, 46) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc];

    f.period = [Field allocFieldWithRect:CGRectMake(20, 358, 64, 46) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 358, 64, 46) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 358, 136, 46) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc];
}

- (void)buildIPhone5:(Fields *)f {
    NSLog(@"%s", __func__);

    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc];
    
    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:8 andValue:@"" andTag:BetterDealA andType:LabelField andVC:f.vc];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:8 andValue:@"" andTag:BetterDealB andType:LabelField andVC:f.vc];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andValue:@"Price A" andTag:PriceA andType:LabelField andVC:f.vc];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 58, 64, 30) andF:17 andValue:@"MinQty" andTag:QtyA andType:LabelField andVC:f.vc];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(82, 58, 64, 30) andF:17 andValue:@"Size" andTag:SizeA andType:LabelField andVC:f.vc];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(38, 96, 80, 30) andF:17 andValue:@"# to Buy" andTag:Qty2BuyA andType:LabelField andVC:f.vc];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andValue:@"Price B" andTag:PriceB andType:LabelField andVC:f.vc];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(174, 58, 64, 30) andF:17 andValue:@"MinQty" andTag:QtyB andType:LabelField andVC:f.vc];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(246, 58, 64, 30) andF:17 andValue:@"Size" andTag:SizeB andType:LabelField andVC:f.vc];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(202, 96, 80, 30) andF:17 andValue:@"# to Buy" andTag:Qty2BuyB andType:LabelField andVC:f.vc];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@"Enter Price, Min Qty & Size of Items" andTag:Message andType:LabelField andVC:f.vc];
    
    f.costField = [Field allocFieldWithRect:CGRectMake(1, 158, 106, 30) andF:17 andValue:@"Cost Field" andTag:CostField andType:LabelField andVC:f.vc];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(106, 158, 107, 30) andF:17 andValue:@"Savings Field" andTag:SavingsField andType:LabelField andVC:f.vc];
    f.moreField = [Field allocFieldWithRect:CGRectMake(212, 158, 106, 30) andF:17 andValue:@"More Field" andTag:MoreField andType:LabelField andVC:f.vc];
    
    f.costLabel = [Field allocFieldWithRect:CGRectMake(1, 186, 106, 10) andF:9 andValue:@"Cost" andTag:CostLabel andType:LabelField andVC:f.vc];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(106, 186, 107, 10) andF:9 andValue:@"Savings" andTag:SavingsLabel andType:LabelField andVC:f.vc];
    f.moreLabel = [Field allocFieldWithRect:CGRectMake(212, 186, 106, 10) andF:9 andValue:@"More" andTag:MoreLabel andType:LabelField andVC:f.vc];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 201, 64, 66) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 201, 64, 66) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 201, 64, 66) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 201, 64, 66) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 275, 64, 66) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc];
    f.five = [Field allocFieldWithRect:CGRectMake(92, 275, 64, 66) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc];
    f.six = [Field allocFieldWithRect:CGRectMake(164, 275, 64, 66) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc];
    f.store = [Field allocFieldWithRect:CGRectMake(236, 275, 64, 66) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc];
    
    f.seven = [Field allocFieldWithRect:CGRectMake(20, 349, 64, 66) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, 349, 64, 66) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, 349, 64, 66) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc];
    f.del = [Field allocFieldWithRect:CGRectMake(236, 349, 64, 66) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 422, 64, 66) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 422, 64, 66) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 422, 136, 66) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc];
}

- (void)buildIPad:(Fields *)f {
    NSLog(@"%s", __func__);
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 394, 352) andF:30 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc];
    f.itemB = [Field allocFieldWithRect:CGRectMake(385, 1, 383, 352) andF:30 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc];
    
    f.betterDealA = [Field allocFieldWithRect:CGRectMake(10, 324, 384, 30) andF:18 andValue:@"" andTag:BetterDealA andType:LabelField andVC:f.vc];
    f.betterDealB = [Field allocFieldWithRect:CGRectMake(384, 324, 384, 30) andF:18 andValue:@"" andTag:BetterDealB andType:LabelField andVC:f.vc];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 50, 366, 86) andF:48 andValue:@"Price A" andTag:PriceA andType:LabelField andVC:f.vc];
    f.qtyA = [Field allocFieldWithRect:CGRectMake(10, 144, 177, 86) andF:48 andValue:@"MinQty" andTag:QtyA andType:LabelField andVC:f.vc];
    f.sizeA = [Field allocFieldWithRect:CGRectMake(199, 144, 177, 86) andF:48 andValue:@"Size" andTag:SizeA andType:LabelField andVC:f.vc];
    f.qty2BuyA = [Field allocFieldWithRect:CGRectMake(105, 238, 177, 86) andF:48 andValue:@"# to Buy" andTag:Qty2BuyA andType:LabelField andVC:f.vc];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(393, 50, 366, 86) andF:48 andValue:@"Price B" andTag:PriceB andType:LabelField andVC:f.vc];
    f.qtyB = [Field allocFieldWithRect:CGRectMake(393, 144, 177, 86) andF:48 andValue:@"MinQty" andTag:QtyB andType:LabelField andVC:f.vc];
    f.sizeB = [Field allocFieldWithRect:CGRectMake(582, 144, 177, 86) andF:48 andValue:@"Size" andTag:SizeB andType:LabelField andVC:f.vc];
    f.qty2BuyB = [Field allocFieldWithRect:CGRectMake(488, 238, 177, 86) andF:48 andValue:@"# to Buy" andTag:Qty2BuyB andType:LabelField andVC:f.vc];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 393, 766, 75) andF:17 andValue:@"Enter Price, Min Qty & Size of Items" andTag:Message andType:LabelField andVC:f.vc];
    
    f.costField = [Field allocFieldWithRect:   CGRectMake(1,   393, 256, 67) andF:40 andValue:@"Cost Field" andTag:CostField andType:LabelField andVC:f.vc];
    f.savingsField = [Field allocFieldWithRect:CGRectMake(256, 393, 257, 67) andF:40 andValue:@"Savings Field" andTag:SavingsField andType:LabelField andVC:f.vc];
    f.moreField = [Field allocFieldWithRect:   CGRectMake(512, 393, 255, 67) andF:40 andValue:@"More Field" andTag:MoreField andType:LabelField andVC:f.vc];
    
    f.costLabel = [Field allocFieldWithRect:   CGRectMake(1,   468, 256, 28) andF:25 andValue:@"Cost" andTag:CostLabel andType:LabelField andVC:f.vc];
    f.savingsLabel = [Field allocFieldWithRect:CGRectMake(256, 468, 257, 28) andF:25 andValue:@"Savings" andTag:SavingsLabel andType:LabelField andVC:f.vc];
    f.moreLabel = [Field allocFieldWithRect:   CGRectMake(512, 468, 255, 28) andF:25 andValue:@"More" andTag:MoreLabel andType:LabelField andVC:f.vc];

    f.one = [Field allocFieldWithRect:CGRectMake(20, 546, 176, 92) andF:48 andValue:@"1" andTag:One andType:KeyType andVC:f.vc];
    f.two = [Field allocFieldWithRect:CGRectMake(204, 546, 176, 92) andF:48 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc];
    f.three = [Field allocFieldWithRect:CGRectMake(388, 546, 176, 92) andF:48 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc];
    f.clr = [Field allocFieldWithRect:CGRectMake(572, 546, 176, 92) andF:48 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 644, 176, 92) andF:48 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc];
    f.five = [Field allocFieldWithRect:CGRectMake(204, 644, 176, 92) andF:48 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc];
    f.six = [Field allocFieldWithRect:CGRectMake(388, 644, 176, 92) andF:48 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc];
    f.store = [Field allocFieldWithRect:CGRectMake(572, 644, 176, 92) andF:36 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc];
    
    f.seven = [Field allocFieldWithRect:CGRectMake(20, 742, 176, 92) andF:48 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc];
    f.eight = [Field allocFieldWithRect:CGRectMake(204, 742, 176, 92) andF:48 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc];
    f.nine = [Field allocFieldWithRect:CGRectMake(388, 742, 176, 92) andF:48 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc];
    f.del = [Field allocFieldWithRect:CGRectMake(572, 742, 176, 92) andF:48 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 840, 176, 92) andF:48 andValue:@"." andTag:Period andType:KeyType andVC:f.vc];
    f.zero = [Field allocFieldWithRect:CGRectMake(204, 840, 176, 92) andF:48 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc];
    f.next = [Field allocFieldWithRect:CGRectMake(388, 840, 360, 92) andF:48 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc];
}

- (void)setView:(Field *)f {
    NSLog(@"%s", __func__);
    assert(self.vc != nil);
    if ([f isButton]) {
        [f makeButton];
    } else {
        [f makeField];
    }
    NSLog(@"%s, %@!!!", __func__, self.vc);
    [self.vc.view addSubview:f.control];
}

- (void)populateScreen {
    NSLog(@"%s", __func__);
    for (Field *f in self.allFields) {
        [self setView:f];
    }
    
    for (Field *f in self.keys) {
        [self setView:f];
    }
}
@end
