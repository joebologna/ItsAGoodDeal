//
//  Fields.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Fields.h"
#import "Grid.h"

@interface Fields() {
    BOOL debug;
}

@end

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
    //[self calcSavings];
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
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue d:2] : self.curField.value;
    if (self.curField.tag >= NumItemsB) {
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
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue d:2] : self.curField.value;
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
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue d:2] : self.curField.value;
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
        _priceAL = nil;
        _priceBL = nil;
        _priceA = nil;
        _priceB = nil;
        _unitsEachAL = nil;
        _numItemsAL = nil;
        _unitsEachBL = nil;
        _numItemsBL = nil;
        _unitsEachA = nil;
        _xAL = nil;
        _numItemsA = nil;
        _unitsEachB = nil;
        _xBL = nil;
        _numItemsB = nil;
        _unitCostAL = nil;
        _unitCostBL = nil;
        _message = nil;
        _slider = nil;
        _qty = nil;
        _ad = nil;
        _vc = nil;
#ifdef DEBUG
        debug = YES;
#else
        debug = NO;
#endif
    }
    return self;
}

- (UIViewController *)getVC {
    return _vc;
}

- (Fields *)makeFields:(id)vc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    _vc = vc;
    self.deviceType = [self getDeviceType];
    
    [self buildScreen];

    // this is the order that the Next button traverses.
    self.inputFields = [NSArray arrayWithObjects:
                        _priceA,
                        _unitsEachA,
                        _numItemsA,
                        _priceB,
                        _unitsEachB,
                        _numItemsB,
                        _qty,
                        nil];

    self.allFields = [NSArray arrayWithObjects:
                      _priceAL,
                      _priceBL,
                      _priceA,
                      _priceB,
                      _unitsEachAL,
                      _numItemsAL,
                      _unitsEachBL,
                      _numItemsBL,
                      _unitsEachA,
                      _xAL,
                      _numItemsA,
                      _unitsEachB,
                      _xBL,
                      _numItemsB,
                      _unitCostAL,
                      _unitCostBL,
                      _slider,
                      _qty,
                      _message,
                      _handle,
                      nil];

    self.keys = [NSArray arrayWithObjects:
                 _one,
                 _two,
                 _three,
                 _four,
                 _five,
                 _six,
                 _seven,
                 _eight,
                 _nine,
                 _zero,
                 _period,
                 _clr,
                 _del,
                 _next,
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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat h = ceilf(0.4 * height / 10.5);
    CGFloat h2 = h * 2;
    CGFloat fontSize;

    switch (self.deviceType) {
        case iPhone4:
            fontSize = ceilf(h * .6);
            break;
        case iPhone5:
            fontSize = ceilf(h * .6);
            break;
        case iPad:
            fontSize = ceilf(h * .6);
            break;
        case UnknownDeviceType:
            fontSize = ceilf(h * .6);
            break;
    }

    CGFloat fontSize2 = ceilf(h2 * .6);
    
    CGRect c1 = CGRectMake(0, 0, 0, 0);
    c1.origin.x = fontSize;
    c1.origin.y = 20;
    c1.size.height = h;
    c1.size.width = ceilf(width/2 - fontSize * 1.5);
    _priceAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"Price A" andTag:PriceAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width + fontSize;
    _priceBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"Price B" andTag:PriceBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h2;
    c1.size.width = ceilf(width/2 - fontSize * 1.5);
    _priceA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:debug ? @"2.99" : @"" andTag:PriceA andType:LabelField caller:self];
    c1.origin.x = c1.size.width + fontSize * 2;
    _priceB = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:debug ? @"1.99" : @"" andTag:PriceB andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _unitsEachAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"# of Units" andTag:UnitsEachAL andType:LabelField caller:self];
    c1.origin.x += fontSize + c1.size.width;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _numItemsAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"# of Items" andTag:NumItemsAL andType:LabelField caller:self];

    c1.origin.x += c1.size.width + fontSize;
    c1.size.height = h;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _unitsEachBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"# of Units" andTag:UnitsEachBL andType:LabelField caller:self];
    c1.origin.x += fontSize + c1.size.width;
    _numItemsBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"# of Items" andTag:NumItemsBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    c1.size.height = h2;
    _unitsEachA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:debug ? @"7.5" : @"" andTag:UnitsEachA andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = fontSize;
    _xAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"x" andTag:XAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _numItemsA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:debug ? @"2" : @"" andTag:NumItemsA andType:LabelField caller:self];
    
    c1.origin.x += c1.size.width + fontSize;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    c1.size.height = h2;
    _unitsEachB = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:debug ? @"8" : @"" andTag:UnitsEachB andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = fontSize;
    _xBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"x" andTag:XBL andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _numItemsB = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:NumItemsB andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = 0;
    c1.size.height = h;
    c1.size.width = ceilf(width/2);
    _unitCostAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"" andTag:UnitCostAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    _unitCostBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"" andTag:UnitCostBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h;
    c1.size.width = 0.75 * (width - fontSize * 3);
    _slider = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"" andTag:Slider andType:LabelField caller:self];

    c1.origin.x = fontSize * 2 + c1.size.width;
    c1.size.height = h;
    c1.size.width = 0.25 * (width - fontSize * 4);
    _qty = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"" andTag:Qty andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = 0;
    c1.size.height = h2 + 2;
    c1.size.width = width;
    _message = [Field allocFieldWithRect:c1 andF:fontSize * ([self isPhone] ? 1 : 1.2) andValue:@PROMPT andTag:Message andType:LabelField caller:self];
    
    // keypad
    CGPoint origin, size, spacing;
    float nextKeyWidth, nextKeyFontSize;
    origin = CGPointMake(20, c1.origin.y + c1.size.height);
    size = CGPointMake(64, 48);
    spacing = CGPointMake(8, 2);
    fontSize = 15;
    nextKeyWidth = 136;
    nextKeyFontSize = fontSize;
    if (self.deviceType == iPhone5) {
        size = CGPointMake(64, 62);
        origin = CGPointMake(20, c1.origin.y + c1.size.height);
    }
    if (self.deviceType == iPad) {
        origin = CGPointMake(20, c1.origin.y + c1.size.height);
        size = CGPointMake(176, 110);
        fontSize = 48;
        nextKeyWidth = 360;
        nextKeyFontSize = 36;
    }
    
    Grid *grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:4 andCols:4];
    
    int row = 0;
    int col = 0;
    _one = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"1" andTag:One andType:KeyType caller:self];
    _two = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"2" andTag:Two andType:KeyType caller:self];
    _three = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"3" andTag:Three andType:KeyType caller:self];
    _clr = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"C" andTag:Clr andType:KeyType caller:self];
    
    col = 0; row++;
    _four = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"4" andTag:Four andType:KeyType caller:self];
    _five = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"5" andTag:Five andType:KeyType caller:self];
    _six = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"6" andTag:Six andType:KeyType caller:self];
    
    col = 0; row++;
    _seven = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"7" andTag:Seven andType:KeyType caller:self];
    _eight = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"8" andTag:Eight andType:KeyType caller:self];
    _nine = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"9" andTag:Nine andType:KeyType caller:self];
    
    col = 0; row++;
    _period = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"." andTag:Period andType:KeyType caller:self];
    _zero = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"0" andTag:Zero andType:KeyType caller:self];
    _del = [Field allocFieldWithRect:[grid getRectAtX:row andY:col++] andF:fontSize andValue:@"Del" andTag:Del andType:KeyType caller:self];
    CGRect r = [grid getRectAtX:row andY:col];
    r.origin.y -= 2 * r.size.height + 2 * spacing.y;
    r.size.height = 3 * r.size.height + 3 * spacing.y;
    _next = [Field allocFieldWithRect:r andF:nextKeyFontSize andValue:@"Next" andTag:Next andType:KeyType caller:self];
    
    r = [grid getRectAtX:3 andY:2];
    r.origin.y += spacing.y + size.y;
    r.origin.x -= fontSize*3/2 + spacing.x / 2;
    r.size.width = fontSize*3;
    r.size.height = fontSize;
    _handle = [Field allocFieldWithRect:r andF:fontSize andValue:@"" andTag:HandleWidget andType:LabelField caller:self];
    _menuthingNotBought = r.origin.y;
    _menuthingBought = _menuthingNotBought + 0.75 * h;
}

- (void)setView:(Field *)f {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    assert(_vc != nil);
    if ([f isButton]) {
        [f makeButton];
    } else if ([f isSlider]) {
        [f makeSlider];
    } else if ([f isHandle]) {
        [f makeHandle];
    } else {
        [f makeField];
    }
    [_vc addControl:f.control];
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

- (void)calcSavings:(BOOL)useQty {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
    BOOL AisAllSet = self.priceA.floatValue != 0.0 && self.unitsEachA.floatValue != 0.0 && self.numItemsA.floatValue != 0.0;
    BOOL BisAllSet = self.priceB.floatValue != 0.0 && self.unitsEachB.floatValue != 0.0 && self.numItemsB.floatValue != 0.0;
    BOOL allSet = AisAllSet && BisAllSet;
    float unitCostA = 0;
    float unitCostB = 0;
    float numUnitsA = 0;
    float numUnitsB = 0;

    if (AisAllSet) {
        numUnitsA = (self.unitsEachA.floatValue * self.numItemsA.floatValue);
        unitCostA = self.priceA.floatValue / numUnitsA;
        ((UITextField *)self.unitCostAL.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostA d:3]];
    }
    if (BisAllSet) {
        numUnitsB = (self.unitsEachB.floatValue * self.numItemsB.floatValue);
        unitCostB = self.priceB.floatValue / numUnitsB;
        ((UITextField *)self.unitCostBL.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostB d:3]];
    }
    float unitCostDiff = fabsf(unitCostA - unitCostB);
    if (allSet) {
        if (useQty && self.qty.floatValue > 0) {
            float v;
            v = self.priceA.floatValue * (self.qty.floatValue / self.numItemsA.floatValue);
            self.priceA.value = [self fmtPrice:v d:2];
            v = self.priceB.floatValue * (self.qty.floatValue / self.numItemsB.floatValue);
            self.priceB.value = [self fmtPrice:v d:2];
            self.numItemsA.value = self.qty.value;
            self.numItemsB.value = self.qty.value;
            numUnitsA = (self.unitsEachA.floatValue * self.numItemsA.floatValue);
            numUnitsB = (self.unitsEachB.floatValue * self.numItemsB.floatValue);
        }
        if (unitCostA < unitCostB) {
            float totalSavings = unitCostDiff * numUnitsA;
            float totalCost = unitCostA * numUnitsA;
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"%.0f items of A cost %@, saves almost %@0.01", self.numItemsA.floatValue, [self fmtPrice:totalCost d:2], self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"%.0f items of A cost %@, saves %@", self.numItemsA.floatValue, [self fmtPrice:totalCost d:2], [self fmtPrice:totalSavings d:2]];
            }
        } else if (unitCostA > unitCostB) {
            float totalSavings = unitCostDiff * numUnitsB;
            float totalCost = unitCostB * numUnitsB;
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"%.0f items of B cost %@, saves almost %@0.01", self.numItemsB.floatValue, [self fmtPrice:totalCost d:2], self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"%.0f items of B cost %@, saves %@", self.numItemsB.floatValue, [self fmtPrice:totalCost d:2], [self fmtPrice:totalSavings d:2]];
            }
        } else {
            float totalCost = unitCostA * numUnitsA;
            self.message.value = [NSString stringWithFormat:@"A cost the same as B, cost %@", [self fmtPrice:totalCost d:2]];
        }

    } else {
        self.message.value = @PROMPT;
    }
    self.slider.control.hidden = self.qty.control.hidden = !allSet;
}

- (void)buttonPushed:(id)sender {
#ifdef DEBUG
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"%s:%d:%@", __func__, ((UIButton *)sender).tag, ((UIButton *)sender).titleLabel.text);
    } else if ([sender isKindOfClass:[UISlider class]]) {
            NSLog(@"%s:%d:%.2f", __func__, ((UISlider *)sender).tag, ((UISlider *)sender).value);
    } else {
        NSLog(@"%s:%@", __func__, sender);
    }
#endif
    [_vc buttonPushed:sender];
    BOOL AisAllSet = self.priceA.floatValue != 0.0 && self.unitsEachA.floatValue != 0.0 && self.numItemsA.floatValue != 0.0;
    BOOL BisAllSet = self.priceB.floatValue != 0.0 && self.unitsEachB.floatValue != 0.0 && self.numItemsB.floatValue != 0.0;
    BOOL allSet = AisAllSet && BisAllSet;
    if (!allSet) {
        self.message.value = @PROMPT;
        self.slider.control.hidden = self.qty.control.hidden = YES;
        self.qty.value = @"";
    }
}

- (void)setNumItems:(NSString *)v {
#ifdef DEBUG
    NSLog(@"%s:%@", __func__, v);
#endif
    self.numItemsA.value = self.numItemsB.value = self.qty.value = v;
}

- (void)setSliderPosition:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
    ((UISlider *)self.slider.control).value = v;
    ((UISlider *)self.slider.control).maximumValue = 2 * v;
    if (((UISlider *)self.slider.control).maximumValue < 10.0) {
        ((UISlider *)self.slider.control).maximumValue = 10.0;
    }
}

- (void)updateQty:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
    if (v < 1) {
        v = 1;
    }
    NSString *s = [NSString stringWithFormat:@"%.0f", v];
    self.qty.value = s;
}

- (void)updateSavings {
    [self calcSavings:YES]; // use Qty
}

- (void)showSettings {
    [self.vc showSettings];
}
@end
