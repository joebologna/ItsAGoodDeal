//
//  Fields.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Fields.h"
#import "Grid.h"

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
        ((UITextField *)f.control).borderStyle = UITextBorderStyleBezel;
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
    previous.borderStyle = UITextBorderStyleBezel;
    selected.backgroundColor = HIGHLIGHTCOLOR;
    selected.borderStyle = UITextBorderStyleLine;
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
    if (grabKeyboard) {
        [_curField.control becomeFirstResponder];
    }
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
    if (grabKeyboard) {
        [_curField.control becomeFirstResponder];
    }
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
        _message2 = nil;
        _message3 = nil;
        _ad = nil;
        _vc = nil;
    }
    return self;
}

- (Fields *)makeFields:(id)vc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.vc = vc;
    self.deviceType = [self getDeviceType];
    
    [self buildScreen];

    // this is the order that the Next button traverses.
    self.inputFields = [NSArray arrayWithObjects:
                        self.priceA,
                        self.unitsEachA,
                        self.numItemsA,
                        self.priceB,
                        self.unitsEachB,
                        self.numItemsB,
                        nil];

    self.allFields = [NSArray arrayWithObjects:
                      self.priceA,
                      self.unitsEachA,
                      self.numItemsA,
                      self.xlabelA,
                      self.priceB,
                      self.unitsEachB,
                      self.numItemsB,
                      self.xlabelB,
                      self.itemA,
                      self.itemB,
                      self.unitCostA,
                      self.unitCostB,
                      self.message,
                      self.message2,
                      self.message3,
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

// builders
- (void)buildScreen {
#ifdef DEBUG
    NSLog(@"%s, %@", __func__, self.getDeviceTypeString);
#endif
    
    // items
    CGPoint origin, size, spacing;
    float fontSize;
    origin = CGPointMake(1, 1);
    size = CGPointMake(158, 154);
    spacing = CGPointMake(2, 0);
    fontSize = 14;
    if (self.deviceType == iPhone5) {
        size.y = 196;
    }
    if (self.deviceType == iPad) {
        size = CGPointMake(768/2 - 2, 1024/3 + 50);
        fontSize = 30;
    }
    
    Grid *grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:1 andCols:2];
    
    int row = 0;
    int col = 0;
    _itemA = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"Price A" andTag:ItemA andType:LabelField caller:self];
    _itemB = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"Price B" andTag:ItemB andType:LabelField caller:self];
    
    origin = CGPointMake(10, 20);
    size = CGPointMake(136, 30);
    spacing = CGPointMake(28, 8);
    fontSize = 17;
    if (self.deviceType == iPhone5) {
        size.y = 42;
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(10, 60);
        size = CGPointMake(768/2 - 24, 1024/12);
        fontSize = 34;
    }
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:2 andCols:2];
    
    row = 0;
    col = 0;
    _priceA = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:PriceA andType:LabelField caller:self];
    _priceB = [Field allocFieldWithRect:[grid getRectAtX:row andY:col] andF:fontSize andValue:@"" andTag:PriceB andType:LabelField caller:self];
    
    CGRect tmp = [grid getRectAtX:0 andY:0];
    origin = CGPointMake(tmp.origin.x, tmp.origin.y);
    size = CGPointMake(136/2 - 8, 30);
    spacing = CGPointMake(16, 8);
    fontSize = 17;
    if (self.deviceType == iPhone5) {
        size.y = 42;
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(10, 60);
        size = CGPointMake(768/2 - 24, 1024/12);
        fontSize = 34;
    }
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:3 andCols:4];
    
    row = 1;
    col = 0;
    _unitsEachA = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:UnitsEachA andType:LabelField caller:self];
    _unitsEachB = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:UnitsEachB andType:LabelField caller:self];
    
    origin = CGPointMake(tmp.origin.x + 12, tmp.origin.y);
    size = CGPointMake(136/2 - 8, 30);
    spacing = CGPointMake(16, 8);
    fontSize = 17;
    if (self.deviceType == iPhone5) {
        size.y = 42;
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(10, 60);
        size = CGPointMake(768/2 - 24, 1024/12);
        fontSize = 34;
    }
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:3 andCols:4];
    row = 1; col = 2;
    _numItemsA = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:NumItemsA andType:LabelField caller:self];
    _numItemsB = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:NumItemsB andType:LabelField caller:self];
    tmp = [grid getRectAtX:1 andY:0];
    tmp.origin.x = size.x - spacing.x + 4;
    _xlabelA = [Field allocFieldWithRect:tmp andF:fontSize andValue:@"X" andTag:XLabelA andType:LabelField caller:self];
    tmp = [grid getRectAtX:1 andY:3];
    tmp.origin.x = size.x * 4 - 28;
    _xlabelB = [Field allocFieldWithRect:tmp andF:fontSize andValue:@"X" andTag:XLabelB andType:LabelField caller:self];
    
    // unit cost
    origin = CGPointMake(10, 128);
    size = CGPointMake(136, 30);
    spacing = CGPointMake(28, 3);
    fontSize = 13;
    if (self.deviceType == iPhone5) {
        origin = CGPointMake(10, 166);
        fontSize = 17;
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(10, 342);
        size = CGPointMake(768/2 - 24, 30);
        fontSize = 24;
    }
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:4 andCols:4];
    
    row = 0;
    col = 0;
    _unitCostA = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:UnitCostA andType:LabelField caller:self];
    _unitCostB = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"" andTag:UnitCostB andType:LabelField caller:self];
    
    // messages
    fontSize = 17;
    origin = CGPointMake(1, 158);
    size = CGPointMake(318, 24);
    if (self.deviceType == iPhone5) {
        origin = CGPointMake(1, 202);
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(1, 413);
        size = CGPointMake(766, 120);
        fontSize = 40;
    }
    spacing = CGPointMake(0, 0);
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:3 andCols:1];
    
    _message = [Field allocFieldWithRect:[grid getRectAtX:0 andY:0] andF:fontSize andValue:@PROMPT andTag:Message andType:LabelField caller:self];
    _message2 = [Field allocFieldWithRect:[grid getRectAtX:1 andY:0] andF:fontSize andValue:@"" andTag:Message2 andType:LabelField caller:self];
    _message3 = [Field allocFieldWithRect:[grid getRectAtX:2 andY:0] andF:fontSize andValue:@"" andTag:Message2 andType:LabelField caller:self];
    
    // keypad
    float nextKeyWidth, nextKeyFontSize;
    origin = CGPointMake(20, 200);
    size = CGPointMake(64, 46);
    spacing = CGPointMake(8, 2);
    fontSize = 15;
    nextKeyWidth = 136;
    nextKeyFontSize = fontSize;
    if (self.deviceType == iPhone5) {
        origin = CGPointMake(20, 288);
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(20, 546);
        size = CGPointMake(176, 92);
        fontSize = 48;
        nextKeyWidth = 360;
        nextKeyFontSize = 36;
    }
    
    grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:4 andCols:4];
    
    row = 0;
    col = 0;
    _one = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"1" andTag:One andType:KeyType caller:self];
    _two = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"2" andTag:Two andType:KeyType caller:self];
    _three = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"3" andTag:Three andType:KeyType caller:self];
    _clr = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@CLR andTag:Clr andType:KeyType caller:self];
    
    col = 0; row++;
    _four = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"4" andTag:Four andType:KeyType caller:self];
    _five = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"5" andTag:Five andType:KeyType caller:self];
    _six = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"6" andTag:Six andType:KeyType caller:self];
    _del = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@DEL andTag:Del andType:KeyType caller:self];
    
    col = 0; row++;
    _seven = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"7" andTag:Seven andType:KeyType caller:self];
    _eight = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"8" andTag:Eight andType:KeyType caller:self];
    _nine = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"9" andTag:Nine andType:KeyType caller:self];
    _store = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@STORE andTag:Store andType:KeyType caller:self];
    
    col = 0; row++;
    _period = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"." andTag:Period andType:KeyType caller:self];
    _zero = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"0" andTag:Zero andType:KeyType caller:self];
    CGRect r = [grid getRectAtX:row andY:col++];
    r.size.width = nextKeyWidth;
    _next = [Field allocFieldWithRect:r andF:nextKeyFontSize andValue:@NEXT andTag:Next andType:KeyType caller:self];
    
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
    [self.vc addControl:f.control];
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
    
    self.message2.value = self.message3.value = @"";
    if (![self.priceA.value isEqualToString:@""]) {
        if ([self.numItemsA.value isEqualToString:@""]) {
            self.numItemsA.value = @"1";
        }
    }
    if (![self.priceB.value isEqualToString:@""]) {
        if ([self.numItemsB.value isEqualToString:@""]) {
            self.numItemsB.value = @"1";
        }
    }
    
    BOOL AisAllSet = self.priceA.floatValue != 0.0 && self.unitsEachA.floatValue != 0.0 && self.numItemsA.floatValue != 0.0;
    BOOL BisAllSet = self.priceB.floatValue != 0.0 && self.unitsEachB.floatValue != 0.0 && self.numItemsB.floatValue != 0.0;
    BOOL allSet = AisAllSet && BisAllSet;
    float unitCostA, unitCostB;

    if (AisAllSet) {
        unitCostA = self.priceA.floatValue / (self.unitsEachA.floatValue * self.numItemsA.floatValue);
        ((UITextField *)self.unitCostA.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostA]];
    } else {
        ((UITextField *)self.unitCostA.control).text = @"";
    }
    if (BisAllSet) {
        unitCostB = self.priceB.floatValue / (self.unitsEachB.floatValue * self.numItemsB.floatValue);
        ((UITextField *)self.unitCostB.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostB]];
    } else {
        ((UITextField *)self.unitCostB.control).text = @"";
    }
    if (allSet) {
        float totalCostA = self.priceA.floatValue * self.numItemsA.floatValue;
        float totalCostB = self.priceB.floatValue * self.numItemsB.floatValue;
        float totalSavings = fabsf(totalCostA - totalCostB);
        
        if (totalCostA < totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = @"";//[NSString stringWithFormat:@"Buy A, You Save almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = @"";//[NSString stringWithFormat:@"Buy A, You Save %@", [self fmtPrice:totalSavings]];
            }
        } else if (totalCostA > totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = @"";//[NSString stringWithFormat:@"Buy B, You Save almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = @"";//[NSString stringWithFormat:@"Buy B, You Save %@", [self fmtPrice:totalSavings]];
            }
        } else {
            self.message.value = @"A is the same price as B";
        }
        if (unitCostA < unitCostB) {
            self.message2.value = [NSString stringWithFormat:@"A is %.1f%% cheaper than B", 100 *(1-(unitCostA/unitCostB))];
            self.message3.value = @"A is a better deal";
        } else if (unitCostA > unitCostB) {
            self.message2.value = [NSString stringWithFormat:@"B is %.1f%% cheaper than A", 100 *(1-(unitCostB/unitCostA))];
            self.message3.value = @"B is a better deal";
        } else {
            self.message2.value = @"A and B are equal";
        }
    }
}

- (void)buttonPushed:(id)sender {
    [self.vc buttonPushed:sender];
}

@end
