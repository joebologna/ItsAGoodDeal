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
    _curField = c;
    [self calcSavings];
}

- (void)fieldWasSelected:(Field *)field {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.curField = field;
}

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
#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
    [_curField.control becomeFirstResponder];
#endif
}

- (void)gotoPrevField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([self.curField isEqual:self.inputFields[0]]) {
        self.curField = self.inputFields.lastObject;
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i - 1];
    }
#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
    [_curField.control becomeFirstResponder];
#endif
}

- (void)gotoFieldWithControl:(UITextField *)t {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.inputFields) {
        if ([f.control isEqual:t]) {
            self.curField = f;
            // it should already be firstResponder.
            return;
        }
    }
}

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
                      self.unitCostA,
                      self.unitCostB,
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

#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
- (void)hideKeypad:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.keys) {
        f.control.hidden = YES;
    }
}

- (void)showKeypad:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.keys) {
        f.control.hidden = NO;
    }
}
#endif

// builders
- (void)buildIPhone4:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
    float y, yHeight, ySpacing, fieldWidth = 159;
    y = 1;
    yHeight = 156;
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, y, fieldWidth - 1, yHeight) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];

    y = 20;
    yHeight = 30;
    ySpacing = yHeight + 8;
    fieldWidth = 136;
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 5;
    y += ySpacing;
    f.unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostA andType:LabelField andVC:f.vc caller:self];
    
    y = 20;
    ySpacing = yHeight + 8;
    f.priceB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 5;
    y += ySpacing;
    f.unitCostB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostB andType:LabelField andVC:f.vc caller:self];

    f.message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];

    y = 200;
    yHeight = 46;
    ySpacing = yHeight + 2;
    f.one = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc caller:self];
    f.two = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc caller:self];
    f.three = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc caller:self];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc caller:self];

    y += ySpacing;
    f.four = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc caller:self];
    f.five = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc caller:self];
    f.six = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc caller:self];
    f.store = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc caller:self];

    y += ySpacing;
    f.seven = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc caller:self];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc caller:self];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc caller:self];
    f.del = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc caller:self];

    y += ySpacing;
    f.period = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc caller:self];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc caller:self];
    f.next = [Field allocFieldWithRect:CGRectMake(164, y, 136, yHeight) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
}

- (void)buildIPhone5:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

    float y, yHeight, ySpacing, fieldWidth = 159;
    y = 1;
    yHeight = 186;
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(161, y, fieldWidth - 1, yHeight) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];
    
    y = 20;
    yHeight = 42;
    ySpacing = yHeight + 8;
    fieldWidth = 136;
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth,yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 16;
    y += ySpacing;
    f.unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostA andType:LabelField andVC:f.vc caller:self];

    y = 20;
    ySpacing = yHeight + 8;
    f.priceB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 16;
    y += ySpacing;
    f.unitCostB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostB andType:LabelField andVC:f.vc caller:self];

    y = 200;
    f.message = [Field allocFieldWithRect:CGRectMake(1, y, 318, 80) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];
    
    y = 200 + 88;
    yHeight = 46;
    ySpacing = yHeight + 2;
    f.one = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:f.vc caller:self];
    f.two = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:f.vc caller:self];
    f.three = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:f.vc caller:self];
    f.clr = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:f.vc caller:self];

    y += ySpacing;
    f.four = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:f.vc caller:self];
    f.five = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:f.vc caller:self];
    f.six = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:f.vc caller:self];
    f.store = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:f.vc caller:self];
    
    y += ySpacing;
    f.seven = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:f.vc caller:self];
    f.eight = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:f.vc caller:self];
    f.nine = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:f.vc caller:self];
    f.del = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:f.vc caller:self];
    
    y += ySpacing;
    f.period = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:f.vc caller:self];
    f.zero = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:f.vc caller:self];
    f.next = [Field allocFieldWithRect:CGRectMake(164, y, 136, yHeight) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
}

- (void)buildIPad:(Fields *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

    float y, yHeight, ySpacing, fieldWidth = 385;
    y = 1;
    yHeight = 382;
    f.itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:30 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:f.vc caller:self];
    f.itemB = [Field allocFieldWithRect:CGRectMake(fieldWidth + 1, y, fieldWidth - 1, yHeight) andF:30 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:f.vc caller:self];
    
    y = 60;
    yHeight = 86;
    ySpacing = yHeight + 8;
    fieldWidth = 366;
    f.priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"Price" andTag:PriceA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 24;
    y += ySpacing;
    f.unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:28 andValue:@"" andTag:UnitCostA andType:LabelField andVC:f.vc caller:self];

    y = 60;
    ySpacing = yHeight + 8;
    f.priceB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"Price" andTag:PriceB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.numItemsB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:f.vc caller:self];
    y += ySpacing;
    f.unitsEachB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:f.vc caller:self];
    ySpacing -= 24;
    y += ySpacing;
    f.unitCostB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:28 andValue:@"" andTag:UnitCostB andType:LabelField andVC:f.vc caller:self];

    f.message = [Field allocFieldWithRect:CGRectMake(1, 413, 766, 120) andF:40 andValue:@PROMPT andTag:Message andType:LabelField andVC:f.vc caller:self];
    
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
    f.next = [Field allocFieldWithRect:CGRectMake(388, 840, 360, 92) andF:36 andValue:@NEXT andTag:Next andType:KeyType andVC:f.vc caller:self];
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
            self.message.value = [NSString stringWithFormat:@"Buy A, You Save: %@", [self fmtPrice:totalSavings]];
        } else if ((unitCostA > unitCostB) && fabsf(unitCostA - unitCostB) > 0.01) {
            savingsPerUnit = unitCostA - unitCostB;
            totalSavings = savingsPerUnit * totalUnitsB;
            self.message.value = [NSString stringWithFormat:@"Buy B, You Save: %@", [self fmtPrice:totalSavings]];
        } else {
            self.message.value = @"A is the same price as B";
        }
        ((UITextField *)self.unitCostA.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostA]];
        ((UITextField *)self.unitCostB.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostB]];
    }
}

@end
