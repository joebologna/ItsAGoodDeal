//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"
#import "Lib/NSObject+Formatter.h"

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
        case BetterDealA: return @"BetterDealA";
        case BetterDealB: return @"BetterDealB";
        case PriceA: return @"PriceA";
        case QtyA: return @"QtyA";
        case SizeA: return @"SizeA";
        case Qty2BuyA: return @"Qty2BuyA";
        case PriceB: return @"PriceB";
        case QtyB: return @"QtyB";
        case SizeB: return @"SizeB";
        case Qty2BuyB: return @"Qty2BuyB";
        case Message: return @"Message";
        case CostField: return @"CostField";
        case SavingsField: return @"SavingsField";
        case MoreField: return @"MoreField";
        case CostLabel: return @"CostLabel";
        case SavingsLabel: return @"SavingsLabel";
        case MoreLabel: return @"MoreLabel";
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
        ((UITextField *)_control).text = _value;
        if ([self isNumber]) {
            if ([self isCurrency]) {
                NSString *s = [_value stringByReplacingOccurrencesOfString:self.currencySymbol withString:@""];
                _floatValue = 0.0f;
                NSString *c = @"";
                @try {
                    c = [_value substringToIndex:1];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@ caught", exception.description);
                }
                if (![c isEqualToString:@"."]) {
                    _floatValue = [s floatValue];
                }
            }
        }
    }
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
    return (_tag == ItemA || _tag == ItemB || _tag == CostField);
}

- (BOOL)isNumber {
    return (_tag == ItemA
            || _tag == ItemB
            || _tag == PriceA
            || _tag == PriceB
            || _tag == QtyA
            || _tag == QtyB
            || _tag == SizeA
            || _tag == SizeB
            || _tag == Qty2BuyA
            || _tag == Qty2BuyB
            || _tag == CostField);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.caller performSelector:@selector(fieldWasSelected:) withObject:self];
    return NO;
}

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
        case BetterDealA:
        case BetterDealB:
        case Message:
            t.placeholder = @"";
            t.enabled = NO;
            break;
        case PriceA:
        case PriceB:
        case QtyA:
        case SizeA:
        case Qty2BuyA:
        case QtyB:
        case SizeB:
        case Qty2BuyB:
            self.value = t.text = @"";
            break;
        case CostField:
        case SavingsField:
        case MoreField:
        case CostLabel:
        case SavingsLabel:
        case MoreLabel:
            t.enabled = NO;
            break;
    }
    
    self.control = (UIControl *)t;
}

@end
