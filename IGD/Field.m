//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"

@interface Field() {
    UIToolbar *rowOfKeys;
    UIBarButtonItem *prevButton, *calcButton, *nextButton;
    NSString *previousPlaceholder;
}
@end

@implementation Field

@dynamic rectToString;
- (NSString *)rectToString {
    return [NSString stringWithFormat:@"{x:%.2f, y:%.2f, w:%.2f, h:%.2f}", _rect.origin.x, _rect.origin.y, _rect.size.width, _rect.size.height];
}

@dynamic fTagToString;
- (NSString *)fTagToString {
	switch(_tag) {
        case PriceA: return @"PriceA";
        case NumItemsA: return @"NumItemsA";
        case UnitsEachA: return @"UnitsEachA";
        case PriceB: return @"PriceB";
        case NumItemsB: return @"NumItemsB";
        case UnitsEachB: return @"UnitsEachB";
        case Message: return @"Message";
        case Qty: return @"Qty";
        case Ad: return @"Ad";
        case FtagNotSet: return @"FtagNotSet";
        default: return @"OOPS!";
    }
}

@dynamic toString;
- (NSString *)toString {
	return [NSString stringWithFormat:@".rect:%@, f:%.2f, value:%@, tag:%@", self.rectToString, _f, _value, self.fTagToString];
}

@synthesize control = _control;
@synthesize value = _value;
- (void)setValue:(NSString *)v {
    _value = v;
    if ([self isButton]) {
        ((MyButton *)_control).bothTitles = _value;
    } else {
        ((UITextField *)_control).text = _value;
    }
}

@dynamic floatValue;
- (CGFloat)floatValue {
    CGFloat f = INFINITY;
    NSString *s = _value;
    if ([self isNumber]) {
        if ([self isCurrency]) {
            s = [_value stringByReplacingOccurrencesOfString:self.currencySymbol withString:@""];
        }
        f = [s floatValue];
    }
    return f;
}

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        //NSLog(@"%s", __func__);
#endif
        _rect = CGRectMake(0, 0, 0, 0);
        _f = [UIFont systemFontSize];
        _value = @"";
        _tag = FtagNotSet;
        _type = FieldTypeNotSet;
        _control = nil;
        _caller = nil;
        previousPlaceholder = @"";
    }
    return self;
}

+ (Field *)allocField {
    return [[Field alloc] init];
}

+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t caller:(id)c {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    Field *field = [[Field alloc] init];
    field.rect = r;
    field.f = f;
    field.value = v;
    field.tag = tag;
    field.type = t;
    field.control = nil; // allocate it later;
    field.caller = c;
    return field;
}

- (BOOL)isButton {
    return (_type == KeyType);
}

- (BOOL)isCurrency {
    return (_tag == PriceA || _tag == PriceB);
}

- (BOOL)isNumber {
    return (_tag == PriceA
            || _tag == PriceB
            || _tag == NumItemsA
            || _tag == NumItemsB
            || _tag == UnitsEachA
            || _tag == UnitsEachB
            || _tag == Qty);
}

- (BOOL)isSlider {
    return _tag == Slider;
}

- (BOOL)isQty {
    return _tag == Qty;
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
    [self.caller buttonPushed:sender];
}

- (void)makeButton {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    MyButton *b = [[MyButton alloc] initWithFrame:self.rect];
    [b addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor whiteColor], nil]];
    [b setBackgroundColors:[NSArray arrayWithObjects:FIELDCOLOR, CURFIELDCOLOR, [UIColor grayColor], nil]];
    b.titleLabel.font = [UIFont systemFontOfSize:self.f];
    b.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    b.titleLabel.textAlignment = NSTextAlignmentCenter;
    b.tag = self.tag;
    b.bothTitles = self.value;
    if (self.type == KeyType) {
        [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient3.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient3.png"] forState:UIControlStateSelected];
    }
    self.control = (UIControl *)b;
}

- (void)makeField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

    UITextField *t = [[UITextField alloc] initWithFrame:self.rect];
    t.delegate = self;
    t.font = [UIFont systemFontOfSize:self.f];
    t.textAlignment = NSTextAlignmentCenter;
    t.tag = self.tag;
    t.text = [self isCurrency] ? [self fmtPrice:self.floatValue d:2] : self.value;
    t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    t.textAlignment = NSTextAlignmentCenter;
    t.placeholder = @"";
    t.backgroundColor = [UIColor clearColor];
    t.enabled = [self isNumber];
    t.borderStyle = UITextBorderStyleNone;
    
    if (self.tag == Qty) {
        t.hidden = YES;
    }
    
    if (self.tag == HandleWidget) {
        t.enabled = YES;
    }
    self.control = (UIControl *)t;

    [self makeKeyboardToolBar];
}

- (void)updateQty:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
    [self.caller updateQty:v];
}
- (void)makeSlider {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    MySlider *s = [[MySlider alloc] initWithFrame:self.rect];
    self.value = @"1";
    s.continuous = YES;
    s.maximumValue = 20.0;
    s.minimumValue = self.value.floatValue;
    s.caller = self;
    s.hidden = YES;
    self.control = s;
}

- (void)updateSavings {
    [self.caller updateSavings];
}

- (void)makeKeyboardToolBar {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    rowOfKeys = [[UIToolbar alloc] init];
    rowOfKeys.barStyle = UIBarStyleBlack;
    [rowOfKeys sizeToFit];

    UIBarButtonItem *f = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    prevButton = [[UIBarButtonItem alloc] initWithTitle:PREVBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(buttonPushed:)];
    prevButton.style = UIBarButtonItemStyleBordered;
    prevButton.tag = PrevButton;

    calcButton = [[UIBarButtonItem alloc] initWithTitle:CALCBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(buttonPushed:)];
    calcButton.style = UIBarButtonItemStyleBordered;
    calcButton.tag = CalcButton;
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:NEXTBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(buttonPushed:)];
    nextButton.style = UIBarButtonItemStyleBordered;
    nextButton.tag = NextButton;
    
    [rowOfKeys setItems:@[prevButton, f, calcButton, f, nextButton]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (textField.enabled) {
        if (textField.tag == HandleWidget) {
            [self.caller showSettings];
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // could be a directTap...
    [self.caller gotoFieldWithControl:textField];
    textField.inputAccessoryView = rowOfKeys;
    textField.keyboardType = [self isPhone] ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
//    if (![self isPhone]) {
        [self.caller hideKeypad:self];
//    }
    textField.text = self.value;
    previousPlaceholder = textField.placeholder;
    textField.placeholder = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self buttonPushed:string];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    textField.text = [self isCurrency] ? [self fmtPrice:self.floatValue d:2] : self.value;
    textField.placeholder = previousPlaceholder;
    if ([self isQty]) {
        [self.caller updateSavings];
        [self.caller setSliderPosition:self.floatValue];
    }
    [self.caller showKeypad:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([self isQty]) {
        [self.caller updateSavings];
        [self.caller setSliderPosition:self.floatValue];
    }
    if (self.tag == NumItemsB) {
        [self buttonPushed:calcButton];
    } else {
        [self buttonPushed:nextButton];
    }
    return YES;
}

- (void)setSliderPosition:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
    [self.caller setSliderPosition:v];    
}
@end
