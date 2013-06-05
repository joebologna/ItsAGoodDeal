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

- (void)makeFields {
    fieldStruct fields[] = {
        { 10, 10, 144, FIELDSIZE, "Price", "" }, { 164, 10, 144, FIELDSIZE, "Price", "" },
        { 10, 20 + FIELDSIZE, 144, FIELDSIZE, "# of Units", "" }, { 164, 20 + FIELDSIZE, 144, FIELDSIZE, "# of Units", "" },
        { 10, 30 + 2 * FIELDSIZE, 144, FIELDSIZE, "# of Units", "" },
        { 10, 40 + 3 * FIELDSIZE, 144, FIELDSIZE, "Unit Price", "" }, { 164, 40 + 3 * FIELDSIZE, 144, FIELDSIZE, "Unit Price", "" }
    };
    
    fieldStruct *deviceFields[] = {
        fields, fields, fields
    };
    
    for (int i = 0; i < sizeof(fields)/sizeof(fieldStruct); i++) {
        [self makeField:[NSString stringWithUTF8String:fields[i].text] label:[NSString stringWithUTF8String:deviceFields[deviceType][i].label] rect:CGRectMake(deviceFields[deviceType][i].x, deviceFields[deviceType][i].y, deviceFields[deviceType][i].w, deviceFields[deviceType][i].h)];
    }
    
    buttonStruct buttons[] = {
        { 0 * 4 + 10 + 48 * 0, 0 * 48 + 48 + 4 * FIELDSIZE, 48, 48, "1" },
        { 1 * 4 + 10 + 48 * 1, 0 * 48 + 48 + 4 * FIELDSIZE, 48, 48, "2" },
        { 2 * 4 + 10 + 48 * 2, 0 * 48 + 48 + 4 * FIELDSIZE, 48, 48, "3" },
        { 3 * 4 + 10 + 48 * 3, 0 * 48 + 48 + 4 * FIELDSIZE, 48, 48, "C" },
        { 0 * 4 + 10 + 48 * 0, 1 * 48 + 28 + 5 * FIELDSIZE, 48, 48, "4" },
        { 1 * 4 + 10 + 48 * 1, 1 * 48 + 28 + 5 * FIELDSIZE, 48, 48, "5" },
        { 2 * 4 + 10 + 48 * 2, 1 * 48 + 28 + 5 * FIELDSIZE, 48, 48, "6" },
        { 3 * 4 + 10 + 48 * 3, 1 * 48 + 28 + 5 * FIELDSIZE, 48, 48, "Help" },
        { 0 * 4 + 10 + 48 * 0, 2 * 48 + 8 + 6 * FIELDSIZE, 48, 48, "7" },
        { 1 * 4 + 10 + 48 * 1, 2 * 48 + 8 + 6 * FIELDSIZE, 48, 48, "8" },
        { 2 * 4 + 10 + 48 * 2, 2 * 48 + 8 + 6 * FIELDSIZE, 48, 48, "9" },
        { 3 * 4 + 10 + 48 * 3, 2 * 48 + 8 + 6 * FIELDSIZE, 48, 48, "Del" },
        { 0 * 4 + 10 + 48 * 0, 3 * 48 + -12 + 7 * FIELDSIZE, 48, 48, "." },
        { 1 * 4 + 10 + 48 * 1, 3 * 48 + -12 + 7 * FIELDSIZE, 48, 48, "0" },
        { 2 * 4 + 10 + 48 * 2, 3 * 48 + -12 + 7 * FIELDSIZE, 48, 48, "Next" },
        { 3 * 4 + 10 + 48 * 3, 3 * 48 + -12 + 7 * FIELDSIZE, 48, 48, "..." }
    };

    buttonStruct *deviceButtons[] = {
        buttons, buttons, buttons
    };

    for (int i = 0; i < sizeof(buttons)/sizeof(buttonStruct); i++) {
        [self makeButton:[NSString stringWithUTF8String:deviceButtons[deviceType][i].label] rect:CGRectMake(deviceButtons[deviceType][i].x, deviceButtons[deviceType][i].y, deviceButtons[deviceType][i].w, deviceButtons[deviceType][i].h)];
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

- (void)makeButton:(NSString *)label rect:(CGRect)rect  {
    UITextField *tf = [[UITextField alloc] initWithFrame:rect];
    tf.text = label;
    tf.font = [UIFont systemFontOfSize:fontSizes.button];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.backgroundColor = fieldColor;
    tf.delegate = self;
    [self.view addSubview:tf];
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
