//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"
#import "Lib/NSObject+Formatter.h"

#ifdef KEYBOARD_FEATURE
@interface Field() {
    UIToolbar *rowOfKeys;
    UIBarButtonItem *prevButton, *calcButton, *nextButton;
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
        ((MyButton *)_control).titleLabel.text = _value;
    } else {
        if (![_value isEqualToString:@""] && [self isCurrency]) {
            ((UITextField *)_control).text = [self fmtPrice:[_value floatValue]];
        } else {
            ((UITextField *)_control).text = _value;
        }
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

#ifdef KEYBOARD_FEATURE
- (void)textFieldDidBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // clear field on direct tap
    // need to update curField
    if ([textField isEqual:self.control]) {
        self.value = @"";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.inputAccessoryView = rowOfKeys;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.caller performSelector:@selector(handleDirectTap:) withObject:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.value = textField.text;
//    textField.text = self.value;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    //[self handleCustomKey:calcButton];
    [textField resignFirstResponder];
    return YES;
}

#else          // !KEYBOARD_FEATURE
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // clear field on direct tap
    self.value = @"";
    [self.caller performSelector:@selector(fieldWasSelected:) withObject:self];
    return NO;
}
#endif          // !KEYBOARD_FEATURE

- (void)buttonPushed:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.vc performSelector:@selector(buttonPushed:) withObject:sender];
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
    
    self.control = (UIControl *)t;

#ifdef KEYBOARD_FEATURE
    [self makeKeyboardToolBar];
#endif
}

#ifdef KEYBOARD_FEATURE

- (void)handleCustomKey:(UIBarButtonItem *)b {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([b isEqual:calcButton]) [self.control resignFirstResponder];
    self.value = ((UITextField *)self.control).text;
    [self.caller handleCustomKey:b];
}

- (void)makeKeyboardToolBar {
    rowOfKeys = [[UIToolbar alloc] init];
    rowOfKeys.barStyle = UIBarStyleBlack;
    [rowOfKeys sizeToFit];

    UIBarButtonItem *f = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    prevButton = [[UIBarButtonItem alloc] initWithTitle:PREVBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(handleCustomKey:)];
    prevButton.style = UIBarButtonItemStyleBordered;

    calcButton = [[UIBarButtonItem alloc] initWithTitle:CALCBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(handleCustomKey:)];
    calcButton.style = UIBarButtonItemStyleBordered;
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:NEXTBUTTON style:UIBarButtonItemStylePlain target:self action:@selector(handleCustomKey:)];
    nextButton.style = UIBarButtonItemStyleBordered;
    
    [rowOfKeys setItems:@[prevButton, f, calcButton, f, nextButton]];
}

#endif
@end
