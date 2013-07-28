//
//  Fields.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Fields.h"

@implementation Fields

@dynamic toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".deviceType: %@, %@", self.getDeviceTypeString, self.fieldValues];
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

- (void)gotoNextField:(BOOL)grabKeyboard {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue] : self.curField.value;
    if ([self.curField isEqual:self.inputFields.lastObject]) {
        self.curField = self.inputFields[0];
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i + 1];
    }
#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
    if (grabKeyboard) [_curField.control becomeFirstResponder];
#endif
}

- (void)gotoPrevField:(BOOL)grabKeyboard {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue] : self.curField.value;
    if ([self.curField isEqual:self.inputFields[0]]) {
        self.curField = self.inputFields.lastObject;
    } else {
        NSInteger i = [self.inputFields indexOfObject:self.curField];
        self.curField = self.inputFields[i - 1];
    }
#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
    if (grabKeyboard) [_curField.control becomeFirstResponder];
#endif
}

- (void)gotoFieldWithControl:(UITextField *)t {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue] : self.curField.value;
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
    self.deviceType = [self getDeviceType];
    [self buildScreen];

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
- (void)buildScreen {
#ifdef DEBUG
    NSLog(@"%s, %@", __func__, self.getDeviceTypeString);
#endif
    float y, yHeight, ySpacing, fieldWidth;
    if (self.deviceType == iPhone4) {
        fieldWidth = 159;
        y = 1;
        yHeight = 156;
        _itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:_vc caller:self];
        _itemB = [Field allocFieldWithRect:CGRectMake(161, y, fieldWidth - 1, yHeight) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:_vc caller:self];
        
        y = 20;
        yHeight = 30;
        ySpacing = yHeight + 8;
        fieldWidth = 136;
        _priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:_vc caller:self];
        ySpacing -= 5;
        y += ySpacing;
        _unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostA andType:LabelField andVC:_vc caller:self];
        
        y = 20;
        ySpacing = yHeight + 8;
        _priceB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:_vc caller:self];
        ySpacing -= 5;
        y += ySpacing;
        _unitCostB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostB andType:LabelField andVC:_vc caller:self];
        
        _message = [Field allocFieldWithRect:CGRectMake(1, 158, 318, 40) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:_vc caller:self];
        
        y = 200;
        yHeight = 46;
        ySpacing = yHeight + 2;
        _one = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:_vc caller:self];
        _two = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:_vc caller:self];
        _three = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:_vc caller:self];
        _clr = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _four = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:_vc caller:self];
        _five = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:_vc caller:self];
        _six = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:_vc caller:self];
        _del = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _seven = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:_vc caller:self];
        _eight = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:_vc caller:self];
        _nine = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:_vc caller:self];
        _store = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _period = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:_vc caller:self];
        _zero = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:_vc caller:self];
        _next = [Field allocFieldWithRect:CGRectMake(164, y, 136, yHeight) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:_vc caller:self];
    } else if (self.deviceType == iPhone5) {
        fieldWidth = 159;
        y = 1;
        yHeight = 186;
        _itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:14 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:_vc caller:self];
        _itemB = [Field allocFieldWithRect:CGRectMake(161, y, fieldWidth - 1, yHeight) andF:14 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:_vc caller:self];
        
        y = 20;
        yHeight = 42;
        ySpacing = yHeight + 8;
        fieldWidth = 136;
        _priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth,yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:_vc caller:self];
        ySpacing -= 16;
        y += ySpacing;
        _unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostA andType:LabelField andVC:_vc caller:self];
        
        y = 20;
        ySpacing = yHeight + 8;
        _priceB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"Price" andTag:PriceB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:17 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:_vc caller:self];
        ySpacing -= 16;
        y += ySpacing;
        _unitCostB = [Field allocFieldWithRect:CGRectMake(174, y, fieldWidth, yHeight) andF:13 andValue:@"" andTag:UnitCostB andType:LabelField andVC:_vc caller:self];
        
        y = 200;
        _message = [Field allocFieldWithRect:CGRectMake(1, y, 318, 80) andF:17 andValue:@PROMPT andTag:Message andType:LabelField andVC:_vc caller:self];
        
        y = 200 + 88;
        yHeight = 46;
        ySpacing = yHeight + 2;
        _one = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"1" andTag:One andType:KeyType andVC:_vc caller:self];
        _two = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"2" andTag:Two andType:KeyType andVC:_vc caller:self];
        _three = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"3" andTag:Three andType:KeyType andVC:_vc caller:self];
        _clr = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@CLR andTag:Clr andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _four = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"4" andTag:Four andType:KeyType andVC:_vc caller:self];
        _five = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"5" andTag:Five andType:KeyType andVC:_vc caller:self];
        _six = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"6" andTag:Six andType:KeyType andVC:_vc caller:self];
        _del = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@DEL andTag:Del andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _seven = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"7" andTag:Seven andType:KeyType andVC:_vc caller:self];
        _eight = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"8" andTag:Eight andType:KeyType andVC:_vc caller:self];
        _nine = [Field allocFieldWithRect:CGRectMake(164, y, 64, yHeight) andF:15 andValue:@"9" andTag:Nine andType:KeyType andVC:_vc caller:self];
        _store = [Field allocFieldWithRect:CGRectMake(236, y, 64, yHeight) andF:15 andValue:@STORE andTag:Store andType:KeyType andVC:_vc caller:self];
        
        y += ySpacing;
        _period = [Field allocFieldWithRect:CGRectMake(20, y, 64, yHeight) andF:15 andValue:@"." andTag:Period andType:KeyType andVC:_vc caller:self];
        _zero = [Field allocFieldWithRect:CGRectMake(92, y, 64, yHeight) andF:15 andValue:@"0" andTag:Zero andType:KeyType andVC:_vc caller:self];
        _next = [Field allocFieldWithRect:CGRectMake(164, y, 136, yHeight) andF:15 andValue:@NEXT andTag:Next andType:KeyType andVC:_vc caller:self];
    } else if (self.deviceType == iPad) {
        fieldWidth = 385;
        y = 1;
        yHeight = 382;
        _itemA = [Field allocFieldWithRect:CGRectMake(1, y, fieldWidth, yHeight) andF:30 andValue:@"Deal A" andTag:ItemA andType:LabelField andVC:_vc caller:self];
        _itemB = [Field allocFieldWithRect:CGRectMake(fieldWidth + 1, y, fieldWidth - 1, yHeight) andF:30 andValue:@"Deal B" andTag:ItemB andType:LabelField andVC:_vc caller:self];
        
        y = 60;
        yHeight = 86;
        ySpacing = yHeight + 8;
        fieldWidth = 366;
        _priceA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"Price" andTag:PriceA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"# of Items" andTag:NumItemsA andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:48 andValue:@"# of Units Each" andTag:UnitsEachA andType:LabelField andVC:_vc caller:self];
        ySpacing -= 24;
        y += ySpacing;
        _unitCostA = [Field allocFieldWithRect:CGRectMake(10, y, fieldWidth, yHeight) andF:28 andValue:@"" andTag:UnitCostA andType:LabelField andVC:_vc caller:self];
        
        y = 60;
        ySpacing = yHeight + 8;
        _priceB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"Price" andTag:PriceB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _numItemsB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"# of Items" andTag:NumItemsB andType:LabelField andVC:_vc caller:self];
        y += ySpacing;
        _unitsEachB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:48 andValue:@"# of Units Each" andTag:UnitsEachB andType:LabelField andVC:_vc caller:self];
        ySpacing -= 24;
        y += ySpacing;
        _unitCostB = [Field allocFieldWithRect:CGRectMake(393, y, fieldWidth, yHeight) andF:28 andValue:@"" andTag:UnitCostB andType:LabelField andVC:_vc caller:self];
        
        _message = [Field allocFieldWithRect:CGRectMake(1, 413, 766, 120) andF:40 andValue:@PROMPT andTag:Message andType:LabelField andVC:_vc caller:self];
        
        _one = [Field allocFieldWithRect:CGRectMake(20, 546, 176, 92) andF:48 andValue:@"1" andTag:One andType:KeyType andVC:_vc caller:self];
        _two = [Field allocFieldWithRect:CGRectMake(204, 546, 176, 92) andF:48 andValue:@"2" andTag:Two andType:KeyType andVC:_vc caller:self];
        _three = [Field allocFieldWithRect:CGRectMake(388, 546, 176, 92) andF:48 andValue:@"3" andTag:Three andType:KeyType andVC:_vc caller:self];
        _clr = [Field allocFieldWithRect:CGRectMake(572, 546, 176, 92) andF:48 andValue:@CLR andTag:Clr andType:KeyType andVC:_vc caller:self];
        
        _four = [Field allocFieldWithRect:CGRectMake(20, 644, 176, 92) andF:48 andValue:@"4" andTag:Four andType:KeyType andVC:_vc caller:self];
        _five = [Field allocFieldWithRect:CGRectMake(204, 644, 176, 92) andF:48 andValue:@"5" andTag:Five andType:KeyType andVC:_vc caller:self];
        _six = [Field allocFieldWithRect:CGRectMake(388, 644, 176, 92) andF:48 andValue:@"6" andTag:Six andType:KeyType andVC:_vc caller:self];
        _del = [Field allocFieldWithRect:CGRectMake(572, 644, 176, 92) andF:48 andValue:@DEL andTag:Del andType:KeyType andVC:_vc caller:self];
        
        _seven = [Field allocFieldWithRect:CGRectMake(20, 742, 176, 92) andF:48 andValue:@"7" andTag:Seven andType:KeyType andVC:_vc caller:self];
        _eight = [Field allocFieldWithRect:CGRectMake(204, 742, 176, 92) andF:48 andValue:@"8" andTag:Eight andType:KeyType andVC:_vc caller:self];
        _nine = [Field allocFieldWithRect:CGRectMake(388, 742, 176, 92) andF:48 andValue:@"9" andTag:Nine andType:KeyType andVC:_vc caller:self];
        _store = [Field allocFieldWithRect:CGRectMake(572, 742, 176, 92) andF:48 andValue:@STORE andTag:Store andType:KeyType andVC:_vc caller:self];
        
        _period = [Field allocFieldWithRect:CGRectMake(20, 840, 176, 92) andF:48 andValue:@"." andTag:Period andType:KeyType andVC:_vc caller:self];
        _zero = [Field allocFieldWithRect:CGRectMake(204, 840, 176, 92) andF:48 andValue:@"0" andTag:Zero andType:KeyType andVC:_vc caller:self];
        _next = [Field allocFieldWithRect:CGRectMake(388, 840, 360, 92) andF:36 andValue:@NEXT andTag:Next andType:KeyType andVC:_vc caller:self];
    } else {
        abort();
    }
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

- (void)calcSavings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    BOOL allSet = YES;
    for (Field *f in self.inputFields) {
        if (f.floatValue == 0.0) {
            allSet = NO;
            self.message.value = @PROMPT;
            self.unitCostA.value = self.unitCostB.value = @"";
            break;
        }
    }
    
    if (allSet) {
        float unitCostA = self.priceA.floatValue / self.unitsEachA.floatValue;
        float totalCostA = self.priceA.floatValue * self.numItemsA.floatValue;
        
        float unitCostB = self.priceB.floatValue / self.unitsEachB.floatValue;
        float totalCostB = self.priceB.floatValue * self.numItemsB.floatValue;
        
        float totalSavings = fabsf(totalCostA - totalCostB);
        
        if (totalCostA < totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"Buy A, You Save: almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"Buy A, You Save: %@", [self fmtPrice:totalSavings]];
            }
        } else if (totalCostA > totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"Buy B, You Save: almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"Buy B, You Save: %@", [self fmtPrice:totalSavings]];
            }
        } else {
            self.message.value = @"A is the same price as B";
        }
        ((UITextField *)self.unitCostA.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostA]];
        ((UITextField *)self.unitCostB.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostB]];
    }
}

@end
