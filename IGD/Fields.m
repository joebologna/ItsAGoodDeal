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
    ((UITextField *)self.curField.control).text = [self.curField isCurrency] ? [self fmtPrice:self.curField.floatValue d:2] : self.curField.value;
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
        _ad = nil;
        _vc = nil;
    }
    return self;
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
                        _priceB,
                        _unitsEachA,
                        _numItemsA,
                        _unitsEachB,
                        _numItemsB,
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
                      _message,
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
                 _store,
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
    CGFloat h = ceilf(0.4 * height / 10);
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
    c1.origin.y = 0;
    c1.size.height = h;
    c1.size.width = ceilf(width/2 - fontSize * 1.5);
    _priceAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"Price A" andTag:PriceAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width + fontSize;
    _priceBL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"Price B" andTag:PriceBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h2;
    c1.size.width = ceilf(width/2 - fontSize * 1.5);
    _priceA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:PriceA andType:LabelField caller:self];
    c1.origin.x = c1.size.width + fontSize * 2;
    _priceB = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:PriceB andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _unitsEachAL = [Field allocFieldWithRect:c1 andF:fontSize * 0.6 andValue:@"# of Units" andTag:UnitsEachAL andType:LabelField caller:self];
    c1.origin.x += fontSize + c1.size.width;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _numItemsAL = [Field allocFieldWithRect:c1 andF:fontSize * 0.6 andValue:@"# of Items" andTag:NumItemsAL andType:LabelField caller:self];

    c1.origin.x += c1.size.width + fontSize;
    c1.size.height = h;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _unitsEachBL = [Field allocFieldWithRect:c1 andF:fontSize * 0.6 andValue:@"# of Units" andTag:UnitsEachBL andType:LabelField caller:self];
    c1.origin.x += fontSize + c1.size.width;
    _numItemsBL = [Field allocFieldWithRect:c1 andF:fontSize * 0.6 andValue:@"# of Items" andTag:NumItemsBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    c1.size.height = h2;
    _unitsEachA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:UnitsEachA andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = fontSize;
    _xAL = [Field allocFieldWithRect:c1 andF:fontSize andValue:@"x" andTag:XAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    _numItemsA = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:NumItemsA andType:LabelField caller:self];
    
    c1.origin.x += c1.size.width + fontSize;
    c1.size.width = ceilf((width - fontSize * 5)/4);
    c1.size.height = h2;
    _unitsEachB = [Field allocFieldWithRect:c1 andF:fontSize2 andValue:@"" andTag:UnitsEachB andType:LabelField caller:self];
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
    _unitCostAL = [Field allocFieldWithRect:c1 andF:fontSize*.75 andValue:@"" andTag:UnitCostAL andType:LabelField caller:self];
    c1.origin.x += c1.size.width;
    _unitCostBL = [Field allocFieldWithRect:c1 andF:fontSize*.75 andValue:@"" andTag:UnitCostBL andType:LabelField caller:self];
    
    c1.origin.y += c1.size.height;
    c1.origin.x = fontSize;
    c1.size.height = h;
    c1.size.width = width - fontSize * 2;
    _slider = [Field allocFieldWithRect:c1 andF:fontSize*.75 andValue:@"" andTag:Slider andType:LabelField caller:self];

    c1.origin.y += c1.size.height;
    c1.origin.x = 0;
    c1.size.height = h2;
    c1.size.width = width;
    _message = [Field allocFieldWithRect:c1 andF:fontSize * ([self isPhone] ? 1.1 : 1.5) andValue:@PROMPT andTag:Message andType:LabelField caller:self];
    
    // keypad
    CGPoint origin, size, spacing;
    float nextKeyWidth, nextKeyFontSize;
    origin = CGPointMake(20, c1.origin.y + c1.size.height);
    size = CGPointMake(64, 46);
    spacing = CGPointMake(8, 2);
    fontSize = 15;
    nextKeyWidth = 136;
    nextKeyFontSize = fontSize;
    if (self.deviceType == iPhone5) {
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
    assert(_vc != nil);
    if ([f isButton]) {
        [f makeButton];
    } else if ([f isSlider]) {
        [f makeSlider];
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

- (void)calcSavings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
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

    if (AisAllSet) {
        float unitCostA = self.priceA.floatValue / (self.unitsEachA.floatValue * self.numItemsA.floatValue);
        ((UITextField *)self.unitCostAL.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostA d:3]];
    }
    if (BisAllSet) {
        float unitCostB = self.priceB.floatValue / (self.unitsEachB.floatValue * self.numItemsB.floatValue);
        ((UITextField *)self.unitCostBL.control).text = [NSString stringWithFormat:@"%@/unit", [self fmtPrice:unitCostB d:3]];
    }
    if (allSet) {
        float totalCostA = self.priceA.floatValue * self.numItemsA.floatValue;
        float totalCostB = self.priceB.floatValue * self.numItemsB.floatValue;
        float totalSavings = fabsf(totalCostA - totalCostB);
        
        if (totalCostA < totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"Buy A, You Save: almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"Buy A, You Save: %@", [self fmtPrice:totalSavings d:2]];
            }
            ((UISlider *)self.slider.control).value = self.numItemsA.value.floatValue;
        } else if (totalCostA > totalCostB) {
            if (totalSavings < 0.01) {
                self.message.value = [NSString stringWithFormat:@"Buy B, You Save: almost %@0.01", self.currencySymbol];
            } else {
                self.message.value = [NSString stringWithFormat:@"Buy B, You Save: %@", [self fmtPrice:totalSavings d:2]];
            }
            ((UISlider *)self.slider.control).value = self.numItemsB.value.floatValue;
        } else {
            self.message.value = @"A is the same price as B";
        }
        ((UISlider *)self.slider.control).value = self.numItemsA.value.floatValue;
    }
    self.slider.control.hidden = !allSet;
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
}

- (void)newSliderValue:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
    [self.vc sliderMoved:v];
    float itemCostA = self.priceA.floatValue / self.numItemsA.floatValue;
    float itemCostB = self.priceB.floatValue / self.numItemsB.floatValue;
    int n = (int)lrintf(v);
    self.priceA.value = [NSString stringWithFormat:@"%.2f", itemCostA * n];
    self.priceB.value = [NSString stringWithFormat:@"%.2f", itemCostB * n];
    self.numItemsA.value = self.numItemsB.value = [NSString stringWithFormat:@"%d", n];
    [self calcSavings];
}
@end
