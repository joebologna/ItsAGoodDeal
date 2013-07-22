//
//  Field.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Field.h"

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
    }
    return self;
}

+ (Field *)allocField {
    return [[Field alloc] init];
}

+ (Field *)allocFieldWithRect:(CGRect)r andF:(CGFloat)f andValue:(NSString *)v andTag:(FTAG)tag andType:(FieldType)t andVC:(UIViewController *)vc{
    Field *field = [[Field alloc] init];
    field.rect = r;
    field.f = f;
    field.value = v;
    field.tag = tag;
    field.type = t;
    field.control = nil; // allocate it later;
    field.vc = vc;
    return field;
}

- (BOOL)isButton {
    return (_type == KeyType);
}

- (void)buttonPushed:(id)sender {
    [self.vc performSelector:@selector(buttonPushed:) withObject:sender];
}

- (void)makeButton {
    NSLog(@"%s", __func__);
    MyButton *b = [[MyButton alloc] initWithFrame:self.rect];
    [b addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor whiteColor], nil]];
    //[b setBackgroundColors:[NSArray arrayWithObjects:fieldColor, curFieldColor, [UIColor grayColor], nil]];
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
    NSLog(@"%s", __func__);

    UITextField *t = [[UITextField alloc] initWithFrame:self.rect];
    t.font = [UIFont systemFontOfSize:self.f];
    t.textAlignment = NSTextAlignmentCenter;
    t.tag = self.tag;
    t.text = self.value;
    t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    t.placeholder = self.value;
    t.backgroundColor = [UIColor clearColor];
    t.borderStyle = UITextBorderStyleLine;
    
    switch (t.tag) {
        case ItemA:
        case ItemB:
            t.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        case BetterDealA:
        case BetterDealB:
        case Message:
            t.placeholder = @"";
            break;
        case QtyA:
        case SizeA:
        case Qty2BuyA:
        case QtyB:
        case SizeB:
        case Qty2BuyB:
            t.text = @"";
            break;
        case PriceA:
        case PriceB:
        case CostField:
        case SavingsField:
        case MoreField:
        case CostLabel:
        case SavingsLabel:
        case MoreLabel:
            break;
    }
    
    self.control = (UIControl *)t;
}

@end
