//
//  ViewController.m
//  EBD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "ViewController.h"
#import "MyButton.h"
#import <iAd/iAd.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FIELDSIZE fieldsize
#define BUTTONSIZE buttonsize

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

@interface ViewController () <ADBannerViewDelegate> {
    UIColor *fieldColor, *curFieldColor;
    DeviceType deviceType;
    FontSizes fontSizes;
    CGFloat fieldsize, buttonsize;
}

@end

@implementation ViewController

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"%s", __func__);
    [banner setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    [banner setHidden:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog(@"%s, Nothing to do", __func__);
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"%s, Nothing to do", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ((ADBannerView *)[self.view viewWithTag:999]).delegate = self;
    
    // iPhone 4 = 480, iPhone 5 = 568, iPad > 568
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    fontSizes.text = fontSizes.label = 12;
    fontSizes.button = 40;
    if (height <= 480) {
        deviceType = iPhone4;
        fieldsize = 36.0;
        buttonsize = 48.0;
    } else if (height > 480 && height <= 568) {
        deviceType = iPhone5;
        fieldsize = 36.0;
        buttonsize = 48.0;
    } else {
        deviceType = iPad;
        fieldsize = 72.0;
        buttonsize = 108.0;
    }
    
    fieldColor = UIColorFromRGB(0x86e4ae);
    curFieldColor = UIColorFromRGB(0x86ffaf);

    self.view.backgroundColor = [UIColor colorWithRed:0.326184 green:0.914025 blue:0.620324 alpha:1];
    [self makeFields];
}

#define FIELD(x, y, w, t) { x, ((y * 25) + (y - 1) * FIELDSIZE), w, FIELDSIZE, t, "" }
#define LARGEFIELD 144
#define SMALLFIELD 104

- (void)makeFields {
    fieldStruct fields4[] = {
        FIELD(10, 0.9, LARGEFIELD, "Price"), FIELD(164, 0.9, LARGEFIELD, "Price"),
        FIELD(10, 1.825, SMALLFIELD, "# of Units"), FIELD(200, 1.825, SMALLFIELD, "# of Units"),
        FIELD(105, 2.5, SMALLFIELD, "Quantity"),
        FIELD(10, 3.3, LARGEFIELD, "Unit Price"), FIELD(164, 3.3, LARGEFIELD, "Unit Price")
    };
    
    fieldStruct fields5[] = {
        FIELD(10, 1, LARGEFIELD, "Price"), FIELD(164, 1, LARGEFIELD, "Price"),
        FIELD(10, 2, SMALLFIELD, "# of Units"), FIELD(200, 2, SMALLFIELD, "# of Units"),
        FIELD(105, 2.8, SMALLFIELD, "Quantity"),
        FIELD(10, 3.8, LARGEFIELD, "Unit Price"), FIELD(164, 3.8, LARGEFIELD, "Unit Price")
    };
    
    fieldStruct fieldsiP[] = {
        FIELD(10, 1, LARGEFIELD*2.5, "Price"), FIELD(10 + 154*2.5, 1, LARGEFIELD*2.5, "Price"),
        FIELD(10, 2, SMALLFIELD*2.5, "# of Units"), FIELD(10 + 190*2.5, 2, SMALLFIELD*2.5, "# of Units"),
        FIELD(10 + 95*2.5, 2.8, SMALLFIELD*2.5, "Quantity"),
        FIELD(10, 3.8, LARGEFIELD*2.5, "Unit Price"), FIELD(10 + 154*2.5, 3.8, LARGEFIELD*2.5, "Unit Price")
    };
    
    fieldStruct *deviceFields[] = {
        fields4, fields5, fieldsiP
    };
    
    for (int i = 0; i < sizeof(fields4)/sizeof(fieldStruct); i++) {
        CGRect rect = CGRectMake(deviceFields[deviceType][i].x,
                                 deviceFields[deviceType][i].y,
                                 deviceFields[deviceType][i].w,
                                 deviceFields[deviceType][i].h);
        [self makeButton:
         [NSString stringWithUTF8String:deviceFields[deviceType][i].text]
                   label:[NSString stringWithUTF8String:deviceFields[deviceType][i].label] rect:rect];
    }
    
#define BUTTON(m, x, y, o, t)  { m + x * 4 + 10 + BUTTONSIZE * x, 64 + y * BUTTONSIZE + o + ((4 + y) * FIELDSIZE), BUTTONSIZE, BUTTONSIZE, t }
#define LASTBUTTON(m, x, y, o, t)  { m + x * 4 + 10 + BUTTONSIZE * x, 64 + y * BUTTONSIZE + o + ((4 + y) * FIELDSIZE), BUTTONSIZE + 102, BUTTONSIZE, t }
#define LM 46

    buttonStruct buttons4[] = {
        BUTTON(LM, 0, 0, -4, "1"), BUTTON(LM, 1, 0, -4, "2"), BUTTON(LM, 2, 0, -4, "3"), BUTTON(LM, 3, 0, -4, "C"),
        BUTTON(LM, 0, 1, -36, "4"), BUTTON(LM, 1, 1, -36, "5"), BUTTON(LM, 2, 1, -36, "6"), BUTTON(LM, 3, 1, -36, "Help"),
        BUTTON(LM, 0, 2, -68, "7"), BUTTON(LM, 1, 2, -68, "8"), BUTTON(LM, 2, 2, -68, "9"), BUTTON(LM, 3, 2, -68, "Del"),
        BUTTON(LM, 0, 3, -100, "."), BUTTON(LM, 1, 3, -100, "0"), LASTBUTTON(LM, 2, 3, -100, "Next")
    };

    buttonStruct buttons5[] = {
        BUTTON(LM, 0, 0, BUTTONSIZE, "1"), BUTTON(LM, 1, 0, BUTTONSIZE, "2"), BUTTON(LM, 2, 0, BUTTONSIZE, "3"), BUTTON(LM, 3, 0, BUTTONSIZE, "C"),
        BUTTON(LM, 0, 1, 16, "4"), BUTTON(LM, 1, 1, 16, "5"), BUTTON(LM, 2, 1, 16, "6"), BUTTON(LM, 3, 1, 16, "Help"),
        BUTTON(LM, 0, 2, -16, "7"), BUTTON(LM, 1, 2, -16, "8"), BUTTON(LM, 2, 2, -16, "9"), BUTTON(LM, 3, 2, -16, "Del"),
        BUTTON(LM, 0, 3, -48, "."), BUTTON(LM, 1, 3, -48, "0"), LASTBUTTON(LM, 2, 3, -100, "Next")
    };

    buttonStruct buttonsiP[] = {
        BUTTON(LM*2, 0, 0, 48, "1"), BUTTON(LM, 1, 0, 48, "2"), BUTTON(LM, 2, 0, 48, "3"), BUTTON(LM, 3, 0, 48, "C"),
        BUTTON(LM*2, 0, 1, 16, "4"), BUTTON(LM, 1, 1, 16, "5"), BUTTON(LM, 2, 1, 16, "6"), BUTTON(LM, 3, 1, 16, "Help"),
        BUTTON(LM*2, 0, 2, -16, "7"), BUTTON(LM, 1, 2, -16, "8"), BUTTON(LM, 2, 2, -16, "9"), BUTTON(LM, 3, 2, -16, "Del"),
        BUTTON(LM*2, 0, 3, -48, "."), BUTTON(LM, 1, 3, -48, "0"), LASTBUTTON(LM, 2, 3, -48, "Next")
    };
    
    buttonStruct *deviceButtons[] = {
        buttons4, buttons5, buttonsiP
    };

    for (int i = 0; i < sizeof(buttons4)/sizeof(buttonStruct); i++) {
        CGRect rect = CGRectMake(deviceButtons[deviceType][i].x,
                                 deviceButtons[deviceType][i].y,
                                 deviceButtons[deviceType][i].w,
                                 deviceButtons[deviceType][i].h);
        [self makeButton:[NSString stringWithUTF8String:deviceButtons[deviceType][i].label] label:nil rect:rect];
    }
    
}

- (void)makeButton:(NSString *)text label:(NSString *)label rect:(CGRect)rect  {
    // if a label is missing it's on the keypad, therefore it needs a gradient
    MyButton *b = [[MyButton alloc] initWithFrame:rect];
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor whiteColor], nil]];
    [b setBackgroundColors:[NSArray arrayWithObjects:self.view.backgroundColor, self.view.backgroundColor, self.view.backgroundColor, nil]];
    [b setTitle:text forState:UIControlStateNormal];
    [b setTitle:text forState:UIControlStateSelected];
    if (label == nil) {
        if ([text isEqualToString:@"Next"]) {
            [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient2.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient2.png"] forState:UIControlStateSelected];
        } else {
            [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient.png"] forState:UIControlStateSelected];
        }
    } else {
        [b setBackgroundColor:fieldColor];
    }
    b.frame = rect;
    [self.view addSubview:b];
    
    if (label != nil) {
        CGFloat labelSize = rect.size.height;
        UILabel *l = [[UILabel alloc] initWithFrame:rect];
        l.font = [UIFont systemFontOfSize:fontSizes.label * .8];
        l.text = label;
        l.textAlignment = NSTextAlignmentCenter;
        l.transform = CGAffineTransformMakeTranslation(0, -labelSize * 0.8);
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
