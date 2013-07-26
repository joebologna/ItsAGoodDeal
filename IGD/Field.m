//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"

#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
@interface Field() {
    UIToolbar *rowOfKeys;
    UIBarButtonItem *prevButton, *calcButton, *nextButton;
    NSString *previousPlaceholder;
}
@end
#endif

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
        case PriceA: return @"PriceA";
        case NumItemsA: return @"NumItemsA";
        case UnitsEachA: return @"UnitsEachA";
        case PriceB: return @"PriceB";
        case NumItemsB: return @"NumItemsB";
        case UnitsEachB: return @"UnitsEachB";
        case Message: return @"Message";
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
        _vc = nil;
        _caller = nil;
        previousPlaceholder = @"";
    }
    return self;
}

+ (Field *)allocField {
    return [[Field alloc] init];
}

+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t andVC:(UIViewController *)vc caller:(id)c {
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
    field.vc = vc;
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
            || _tag == UnitsEachB);
}

- (void)buttonPushed:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.vc performSelector:@selector(buttonPushed:) withObject:sender];
}

- (void)toolBarButtonPushed:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self buttonPushed:sender];
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
        //b.titleLabel.text = self.value;
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
    t.text = self.value;
    t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    t.textAlignment = NSTextAlignmentCenter;
    t.placeholder = self.value;
    t.backgroundColor = [UIColor clearColor];
    t.enabled = YES;
    
    switch (t.tag) {
        case ItemA:
        case ItemB:
            t.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            t.borderStyle = UITextBorderStyleLine;
        case Message:
            t.placeholder = @"";
            t.enabled = NO;
            break;
        case PriceA:
        case PriceB:
        case NumItemsA:
        case UnitsEachA:
        case NumItemsB:
        case UnitsEachB:
            self.value = t.text = @"";
            break;
    }
    
    if (t.tag == UnitCostA || t.tag == UnitCostB) {
        t.enabled = NO;
    }
    
    self.control = (UIControl *)t;

#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
    [self makeKeyboardToolBar];
#endif // KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
}

#ifdef KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED

- (void)makeKeyboardToolBar {
    rowOfKeys = [[UIToolbar alloc] init];
    rowOfKeys.barStyle = UIBarStyleBlack;
    [rowOfKeys sizeToFit];

    UIBarButtonItem *f = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    prevButton = [[UIBarButtonItem alloc] initWithTitle:PREVBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(toolBarButtonPushed:)];
    prevButton.style = UIBarButtonItemStyleBordered;
    prevButton.tag = PrevButton;

    calcButton = [[UIBarButtonItem alloc] initWithTitle:CALCBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(toolBarButtonPushed:)];
    calcButton.style = UIBarButtonItemStyleBordered;
    calcButton.tag = CalcButton;
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:NEXTBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(toolBarButtonPushed:)];
    nextButton.style = UIBarButtonItemStyleBordered;
    nextButton.tag = NextButton;
    
    [rowOfKeys setItems:@[prevButton, f, calcButton, f, nextButton]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (textField.enabled) {
        if ([self isPhone]) {
            return YES;
        } else {
            //handle direct tap.
            [self.caller performSelector:@selector(gotoFieldWithControl:) withObject:textField];
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // could be a directTap...
    [self.caller performSelector:@selector(gotoFieldWithControl:) withObject:textField];
    if ([self isPhone]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.inputAccessoryView = rowOfKeys;
    }
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
    textField.text = [self isCurrency] ? [self fmtPrice:self.floatValue] : self.value;
    textField.placeholder = previousPlaceholder;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (self.tag == UnitsEachB) {
        [self toolBarButtonPushed:calcButton];
    } else {
        [self toolBarButtonPushed:nextButton];
    }
    return YES;
}

#else
// !KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // clear field on direct tap
    self.value = @"";
    [self.caller performSelector:@selector(fieldWasSelected:) withObject:self];
    return NO;
}

// !KEYBOARD_FEATURE_CALLS_BUTTON_PUSHED
#endif

@end
