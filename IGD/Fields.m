//
//  Fields.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Fields.h"
#import "Lib/NSObject+Formatter.h"

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

@dynamic toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".deviceType: %@", self.deviceTypeString];
}

@dynamic fieldValues;
- (NSString *)fieldValues {
    NSString *s = @"{\n";
    for (Field *f in self.inputFields) {
        s = [s stringByAppendingFormat:@"\t%@: %@, %@, %.2f\n", f.fTagToString, f.value, ((UITextField *)f.control).text, f.value.floatValue];
    }
	return [NSString stringWithFormat:@"%@}\n", s];
}

- (void)clearBackground {
    for (Field *f in self.inputFields) {
        ((UITextField *)f.control).backgroundColor = FIELDCOLOR;
    }
}

@synthesize curField = _curField;
- (void)setCurField:(Field *)c {
    UITextField *previous = (UITextField *)_curField.control;
    UITextField *selected = (UITextField *)c.control;
#ifdef DEBUG
    NSLog(@"%s, %@, %@", __func__, _curField.fTagToString, c.fTagToString);
#endif
    previous.backgroundColor = FIELDCOLOR;
    selected.backgroundColor = HIGHLIGHTCOLOR;
    if ([_curField isCurrency]) {
        _curField.value = [self fmtPrice:_curField.floatValue];
    }
    _curField = c;
    [self calcSavings];
}

- (void)fieldWasSelected:(Field *)field {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.curField = field;
}

#ifdef FEATURE_KEYBOARD

- (void)handleCustomKey:(UIBarButtonItem *)b {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([b.title isEqualToString:PREVBUTTON]) {
        [self gotoPrevField:YES];
    } else if ([b.title isEqualToString:CALCBUTTON]) {
        [self calcSavings];
    } else if ([b.title isEqualToString:NEXTBUTTON]) {
        [self gotoNextField:YES];
    } else {
        NSLog(@"Oops!");
    }
}

- (void)gotoNextField:(BOOL)grabKeyboard {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([self.curField isEqual:self.inputFields.lastObject]) {
        self.curField = self.inputFields[0];
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i + 1];
    }
    if (grabKeyboard) { [self.curField.control becomeFirstResponder]; }
}

- (void)gotoPrevField:(BOOL)grabKeyboard {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([self.curField isEqual:self.inputFields[0]]) {
        self.curField = self.inputFields.lastObject;
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i - 1];
    }
    if (grabKeyboard) { [self.curField.control becomeFirstResponder]; }
}

#else

- (void)gotoNextField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([self.curField isEqual:self.inputFields.lastObject]) {
        self.curField = self.inputFields[0];
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i + 1];
    }
}

#endif

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _deviceType = UnknownDeviceType;
        _itemA = nil,
        _itemB = nil,
        _priceA = nil,
        _priceB = nil,
        _numItemsA = nil,
        _numItemsB = nil,
        _unitsEachA = nil,
        _unitsEachB = nil,
        _message = nil;
        _ad = nil;
        _vc = nil;
    }
    return self;
}

- (Fields *)makeFields:(UIViewController *)vc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
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
    // this is the order that the Next button traverses.
    self.inputFields = [NSArray arrayWithObjects:
                        self.priceA,
                        self.numItemsA,
                        self.unitsEachA,
                        self.priceB,
                        self.numItemsB,
                        self.unitsEachB,
                        nil];

    self.allFields = [NSArray arrayWithObjects:
                      self.priceA,
                      self.priceB,
                      self.numItemsA,
                      self.numItemsB,
                      self.unitsEachA,
                      self.unitsEachB,
                      self.itemA,
                      self.itemB,
                      self.message,
                      nil];

    self.keys = [NSArray arrayWithObjects:
                 self.one,
                 self.two,
                 self.three,
                 self.four,
                 self.five,
                 self.six,
                 self.seven,
                 self.eight,
                 self.nine,
                 self.zero,
                 self.period,
                 self.clr,
                 self.store,
                 self.del,
                 self.next,
                 nil];

    return self;
}

// builders
- (void)buildIPhone4:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];

    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, 58, 136, 30) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(10, 58+38, 136, 30) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];

    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(174, 58, 136, 30) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(174, 58+38, 136, 30) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];

    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];

    f.one = [Field allocFieldWithRect:CGRectMake(20, 199, 64, 46) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc caller:self];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 199, 64, 46) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc caller:self];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 199, 64, 46) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc caller:self];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 199, 64, 46) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc caller:self];

    f.four = [Field allocFieldWithRect:CGRectMake(20, 252, 64, 46) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc caller:self];
    f.five = [Field allocFieldWithRect:CGRectMake(92, 252, 64, 46) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc caller:self];
    f.six = [Field allocFieldWithRect:CGRectMake(164, 252, 64, 46) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc caller:self];
    f.store = [Field allocFieldWithRect:CGRectMake(236, 252, 64, 46) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc caller:self];

    f.seven = [Field allocFieldWithRect:CGRectMake(20, 305, 64, 46) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc caller:self];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, 305, 64, 46) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc caller:self];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, 305, 64, 46) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc caller:self];
    f.del = [Field allocFieldWithRect:CGRectMake(236, 305, 64, 46) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc caller:self];

    f.period = [Field allocFieldWithRect:CGRectMake(20, 358, 64, 46) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc caller:self];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 358, 64, 46) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc caller:self];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 358, 136, 46) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
}

- (void)buildIPhone5:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 159, 156) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, 1, 158, 156) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 20, 136, 30) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, 58+38, 136, 30) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(10, 58+38, 136, 30) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(174, 20, 136, 30) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(174, 58, 64, 30) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(174, 58+38, 136, 30) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 201, 64, 66) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc caller:self];
    f.two = [Field allocFieldWithRect:CGRectMake(92, 201, 64, 66) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc caller:self];
    f.three = [Field allocFieldWithRect:CGRectMake(164, 201, 64, 66) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc caller:self];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, 201, 64, 66) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc caller:self];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 275, 64, 66) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc caller:self];
    f.five = [Field allocFieldWithRect:CGRectMake(92, 275, 64, 66) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc caller:self];
    f.six = [Field allocFieldWithRect:CGRectMake(164, 275, 64, 66) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc caller:self];
    f.store = [Field allocFieldWithRect:CGRectMake(236, 275, 64, 66) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc caller:self];
    
    f.seven = [Field allocFieldWithRect:CGRectMake(20, 349, 64, 66) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc caller:self];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, 349, 64, 66) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc caller:self];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, 349, 64, 66) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc caller:self];
    f.del = [Field allocFieldWithRect:CGRectMake(236, 349, 64, 66) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc caller:self];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 422, 64, 66) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc caller:self];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, 422, 64, 66) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc caller:self];
    f.next = [Field allocFieldWithRect:CGRectMake(164, 422, 136, 66) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
}

- (void)buildIPad:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, 1, 394, 352) andF:30 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(385, 1, 383, 352) andF:30 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];
    
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, 50, 366, 86) andF:48 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, 144, 366, 86) andF:48 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(199, 144, 366, 86) andF:48 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];
    
    f.priceB = [Field allocFieldWithRect:CGRectMake(393, 50, 366, 86) andF:48 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(393, 144, 366, 86) andF:48 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(510, 144, 366, 86) andF:48 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];
    
    f.message = [Field allocFieldWithRect:CGRectMake(1, 393, 766, 120) andF:50 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];
    
    f.one = [Field allocFieldWithRect:CGRectMake(20, 546, 176, 92) andF:48 andValue:@"1" andTag:One andType:KeyType andVC:f.vc caller:self];
    f.two = [Field allocFieldWithRect:CGRectMake(204, 546, 176, 92) andF:48 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc caller:self];
    f.three = [Field allocFieldWithRect:CGRectMake(388, 546, 176, 92) andF:48 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc caller:self];
    f.clr = [Field allocFieldWithRect:CGRectMake(572, 546, 176, 92) andF:48 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc caller:self];
    
    f.four = [Field allocFieldWithRect:CGRectMake(20, 644, 176, 92) andF:48 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc caller:self];
    f.five = [Field allocFieldWithRect:CGRectMake(204, 644, 176, 92) andF:48 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc caller:self];
    f.six = [Field allocFieldWithRect:CGRectMake(388, 644, 176, 92) andF:48 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc caller:self];
    f.store = [Field allocFieldWithRect:CGRectMake(572, 644, 176, 92) andF:36 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc caller:self];
    
    f.seven = [Field allocFieldWithRect:CGRectMake(20, 742, 176, 92) andF:48 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc caller:self];
    f.eight = [Field allocFieldWithRect:CGRectMake(204, 742, 176, 92) andF:48 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc caller:self];
    f.nine = [Field allocFieldWithRect:CGRectMake(388, 742, 176, 92) andF:48 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc caller:self];
    f.del = [Field allocFieldWithRect:CGRectMake(572, 742, 176, 92) andF:48 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc caller:self];
    
    f.period = [Field allocFieldWithRect:CGRectMake(20, 840, 176, 92) andF:48 andValue:@"." andTag:Period andType:KeyType andVC:f.vc caller:self];
    f.zero = [Field allocFieldWithRect:CGRectMake(204, 840, 176, 92) andF:48 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc caller:self];
    f.next = [Field allocFieldWithRect:CGRectMake(388, 840, 360, 92) andF:48 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
}

- (void)setView:(Field *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
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
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.allFields) {
        [self setView:f];
    }
    
    for (Field *f in self.keys) {
        [self setView:f];
    }
    
    [self clearBackground];
    self.curField = self.priceA;
}

// round to 2 decimal places
// #define r2(F) (roundf(F * 100.0) / 100.0)

- (void)calcSavings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    BOOL allSet = YES;
    for (Field *f in self.inputFields) {
        if (f.floatValue == 0.0) {
            allSet = NO;
            break;
        }
    }
    
    if (allSet) {
        float totalUnitsA = self.numItemsA.floatValue * self.unitsEachA.floatValue;
        float unitCostA = self.priceA.floatValue / totalUnitsA;
        
        float totalUnitsB = self.numItemsB.floatValue * self.unitsEachB.floatValue;
        float unitCostB = self.priceB.floatValue / totalUnitsB;
        
        float savingsPerUnit = 0.0;
        float totalSavings = 0.0;
        if ((unitCostA < unitCostB) && fabsf(unitCostA - unitCostB) > 0.01) {
            savingsPerUnit = unitCostB - unitCostA;
            totalSavings = savingsPerUnit * totalUnitsA;
            self.message.value = [NSString stringWithFormat:@"Buy A, You Save: %.2f", totalSavings];
        } else if ((unitCostA > unitCostB) && fabsf(unitCostA - unitCostB) > 0.01) {
            savingsPerUnit = unitCostA - unitCostB;
            totalSavings = savingsPerUnit * totalUnitsB;
            self.message.value = [NSString stringWithFormat:@"Buy B, You Save: %.2f", totalSavings];
        } else {
            self.message.value = @"Same Price!";
        }
    }
}
@end
