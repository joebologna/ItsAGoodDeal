//
//  ViewController.m
//  EBD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "ViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FIELDSIZE 24.0

typedef enum {
    iPhone4 = 0, iPhone5 = 1, iPad =2
} DeviceType;

typedef struct {
    CGFloat text, label, button;
} FontSizes;

typedef struct {
    CGFloat x, y, w, h;
    char *label, *text;
} fieldStruct;

typedef struct {
    CGFloat x, y, w, h;
    char *label;
} buttonStruct;

@interface ViewController() {
    UIColor *fieldColor, *curFieldColor;
    DeviceType deviceType;
    FontSizes fontSizes;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iPhone 4 = 480, iPhone 5 = 568, iPad > 568
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    fontSizes.text = fontSizes.label = 12;
    fontSizes.button = 40;
    if (height <= 480) {
        deviceType = iPhone4;
    } else if (height > 480 && height <= 568) {
        deviceType = iPhone5;
    } else {
        deviceType = iPad;
    }
    
    fieldColor = UIColorFromRGB(0x86e4ae);
    curFieldColor = UIColorFromRGB(0x86ffaf);

    self.view.backgroundColor = [UIColor colorWithRed:0.326184 green:0.914025 blue:0.620324 alpha:1];
    [self makeFields];
}

#define FIELD(x, y, w, t) { x, ((y * 10) + (y - 1) * FIELDSIZE), w, FIELDSIZE, t, "" }

- (void)makeFields {
    fieldStruct fields[] = {
        FIELD(10, 1, 144, "Price"), FIELD(164, 1, 144, "Price"),
        FIELD(10, 2, 144, "# of Units"), FIELD(164, 2, 144, "# of Units"),
        FIELD(10, 3, 144, "Quantity"),
        FIELD(10, 4, 144, "Unit Price"), FIELD(164, 4, 144, "Unit Price")
    };
    
    fieldStruct *deviceFields[] = {
        fields, fields, fields
    };
    
    for (int i = 0; i < sizeof(fields)/sizeof(fieldStruct); i++) {
        CGRect rect = CGRectMake(deviceFields[deviceType][i].x,
                                 deviceFields[deviceType][i].y,
                                 deviceFields[deviceType][i].w,
                                 deviceFields[deviceType][i].h);
        [self makeButton:
         [NSString stringWithUTF8String:deviceFields[deviceType][i].text]
                   label:[NSString stringWithUTF8String:deviceFields[deviceType][i].label] rect:rect];
    }
    
#define BUTTON(x, y, o, t)  { x * 4 + 10 + 48 * x, y * 48 + o + ((4 + y) * FIELDSIZE), 48, 48, t }
    
    buttonStruct buttons[] = {
        BUTTON(0, 0, 48, "1"),
        BUTTON(1, 0, 48, "2"),
        BUTTON(2, 0, 48, "3"),
        BUTTON(3, 0, 48, "C"),
        BUTTON(0, 1, 28, "4"),
        BUTTON(1, 1, 28, "5"),
        BUTTON(2, 1, 28, "6"),
        BUTTON(3, 1, 28, "Help"),
        BUTTON(0, 2, 8, "7"),
        BUTTON(1, 2, 8, "8"),
        BUTTON(2, 2, 8, "9"),
        BUTTON(3, 2, 8, "Del"),
        BUTTON(0, 3, -12, "."),
        BUTTON(1, 3, -12, "0"),
        BUTTON(2, 3, -12, "Next"),
        BUTTON(3, 3, -12, "...")
    };

    buttonStruct *deviceButtons[] = {
        buttons, buttons, buttons
    };

    for (int i = 0; i < sizeof(buttons)/sizeof(buttonStruct); i++) {
        CGRect rect = CGRectMake(deviceButtons[deviceType][i].x,
                                 deviceButtons[deviceType][i].y,
                                 deviceButtons[deviceType][i].w,
                                 deviceButtons[deviceType][i].h);
        [self makeButton:[NSString stringWithUTF8String:deviceButtons[deviceType][i].label] label:nil rect:rect];
    }
    
}

- (void)makeField:(NSString *)text label:(NSString *)label rect:(CGRect)rect  {
    CGFloat fieldSize = rect.size.height;
    UITextField *tf = [[UITextField alloc] initWithFrame:rect];
    tf.text = text;
    tf.font = [UIFont systemFontOfSize:fontSizes.text];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.backgroundColor = fieldColor;
    tf.delegate = self;
    [self.view addSubview:tf];

    UILabel *l = [[UILabel alloc] initWithFrame:rect];
    l.font = [UIFont systemFontOfSize:fontSizes.label / 2];
    l.text = label;
    l.textAlignment = NSTextAlignmentCenter;
    l.transform = CGAffineTransformMakeTranslation(0, -fieldSize * .6);
    l.backgroundColor = [UIColor clearColor];
    [self.view addSubview:l];
}

- (void)makeButton:(NSString *)text label:(NSString *)label rect:(CGRect)rect  {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:text forState:UIControlStateNormal];
    [b setTitle:text forState:UIControlStateSelected];
    b.frame = rect;
    [self.view addSubview:b];
    
    if (label != nil) {
        CGFloat fieldSize = rect.size.height;
        UILabel *l = [[UILabel alloc] initWithFrame:rect];
        l.font = [UIFont systemFontOfSize:fontSizes.label / 2];
        l.text = label;
        l.textAlignment = NSTextAlignmentCenter;
        l.transform = CGAffineTransformMakeTranslation(0, -fieldSize * .6);
        l.backgroundColor = [UIColor clearColor];
        [self.view addSubview:l];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = @"1";
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
