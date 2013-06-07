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

#define FTAG 100
#define BTAG 200

typedef enum {
    PriceA = FTAG, NumUnitsA = FTAG + 1,
    PriceB = FTAG + 2, NumUnitsB = FTAG + 3,
    Quantity = FTAG + 4,
    UnitPriceA = FTAG + 5, UnitPriceB = FTAG + 6,
    Result = FTAG + 7
} Field;

#define nInputFields (Quantity - FTAG + 1)

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
    NSMutableArray *fieldValues;
    UIColor *fieldColor, *curFieldColor;
    DeviceType deviceType;
    FontSizes fontSizes;
    CGFloat fieldsize, buttonsize;
    NSInteger curField;
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
    if (height <= 480) {
        deviceType = iPhone4;
        fieldsize = 30.0;
        buttonsize = 48.0;
        fontSizes.text = fontSizes.label = 12;
        fontSizes.button = 20;
    } else if (height > 480 && height <= 568) {
        deviceType = iPhone5;
        fieldsize = 36.0;
        buttonsize = 48.0;
        fontSizes.text = fontSizes.label = 12;
        fontSizes.button = 20;
    } else {
        deviceType = iPad;
        fieldsize = 72.0;
        buttonsize = 128.0;
        fontSizes.text = fontSizes.label = 24;
        fontSizes.button = 48;
    }
    
    fieldColor = UIColorFromRGB(0x86e4ae);
    curFieldColor = UIColorFromRGB(0x86ffcf);

    self.view.backgroundColor = [UIColor colorWithRed:0.326184 green:0.914025 blue:0.620324 alpha:1];
    [self makeFields];
    [self initGUI];
}

- (void)initGUI {
    fieldValues = [NSMutableArray array];
    for (int i = PriceA; i <= Result; i++) {
        [fieldValues addObject:@""];
    }
    curField = FTAG;
    [self updateFields];
}

- (void)updateFields {
    for (int tag = PriceA; tag <= Result; tag++) {
        NSInteger i = tag - FTAG;
        MyButton *b = (MyButton *)[self.view viewWithTag:tag];
        [b setTitle:fieldValues[i] forState:UIControlStateNormal];
        [b setTitle:fieldValues[i] forState:UIControlStateSelected];
        [b setBackgroundColor:(tag == curField) ? curFieldColor : fieldColor];
    }
}

#define FIELD(x, y, w, t) { x, ((y * 25) + (y - 1) * FIELDSIZE), w, FIELDSIZE, t, "" }
#define LARGEFIELD 144
#define SMALLFIELD 104

- (void)makeFields {
    fieldStruct fields4[] = {
        FIELD(10, 0.8, LARGEFIELD, "Price"), FIELD(10, 1.7, SMALLFIELD, "# of Units"),
        FIELD(164, 0.8, LARGEFIELD, "Price"), FIELD(202, 1.7, SMALLFIELD, "# of Units"),
        FIELD(105, 2.3, SMALLFIELD, "Quantity"),
        FIELD(10, 3.1, LARGEFIELD, "Unit Price"), FIELD(164, 3.1, LARGEFIELD, "Unit Price"),
        FIELD(10, 4.0, LARGEFIELD*2+10, "Result")
    };
    
    fieldStruct fields5[] = {
        FIELD(10, 1, LARGEFIELD, "Price"), FIELD(10, 1.825, SMALLFIELD, "# of Units"),
        FIELD(164, 1, LARGEFIELD, "Price"), FIELD(200, 1.825, SMALLFIELD, "# of Units"),
        FIELD(105, 2.8, SMALLFIELD, "Quantity"),
        FIELD(10, 3.8, LARGEFIELD, "Unit Price"), FIELD(164, 3.8, LARGEFIELD, "Unit Price"),
        FIELD(10, 4.3, LARGEFIELD*2+10, "Result")
    };
    
    fieldStruct fieldsiP[] = {
        FIELD(20, 1.1, LARGEFIELD*2.5, "Price"), FIELD(20, 2.2, SMALLFIELD*2.5, "# of Units"), 
        FIELD(20 + 154*2.4, 1.1, LARGEFIELD*2.5, "Price"), FIELD(20 + 8 + 190*2.4, 2.2, SMALLFIELD*2.5, "# of Units"),
        FIELD(20 + 95*2.5 - 4, 3.0, SMALLFIELD*2.5, "Quantity"),
        FIELD(20, 4.0, LARGEFIELD*2.5, "Unit Price"), FIELD(20 + 154*2.4, 4.0, LARGEFIELD*2.5, "Unit Price"),
        FIELD(10, 4.3, LARGEFIELD*2, "Result")
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
                   label:[NSString stringWithUTF8String:deviceFields[deviceType][i].label] rect:rect tag:(FTAG + i)];
    }
    
#define BUTTON(m, x, y, o, t)  { m + x * 4 + 10 + BUTTONSIZE * x, 64 + y * BUTTONSIZE + o + ((4 + y) * FIELDSIZE), BUTTONSIZE, BUTTONSIZE, t }
#define LASTBUTTON(m, x, y, o, t)  { m + x * 4 + 10 + BUTTONSIZE * x, 64 + y * BUTTONSIZE + o + ((4 + y) * FIELDSIZE), BUTTONSIZE + ((deviceType == iPad) ? 136 : 52), BUTTONSIZE, t }
#define LM 46

    buttonStruct buttons4[] = {
        BUTTON(LM, 0, 0, 38, "1"), BUTTON(LM, 1, 0, 38, "2"), BUTTON(LM, 2, 0, 38, "3"), BUTTON(LM, 3, 0, 38, "C"),
        BUTTON(LM, 0, 1, 12, "4"), BUTTON(LM, 1, 1, 12, "5"), BUTTON(LM, 2, 1, 12, "6"), BUTTON(LM, 3, 1, 12, "Help"),
        BUTTON(LM, 0, 2, -34, "7"), BUTTON(LM, 1, 2, -14, "8"), BUTTON(LM, 2, 2, -14, "9"), BUTTON(LM, 3, 2, -14, "Del"),
        BUTTON(LM, 0, 3, -56, "."), BUTTON(LM, 1, 3, -56, "0"), LASTBUTTON(LM, 2, 3, -56, "Next")
    };

    buttonStruct buttons5[] = {
        BUTTON(LM, 0, 0, BUTTONSIZE, "1"), BUTTON(LM, 1, 0, BUTTONSIZE, "2"), BUTTON(LM, 2, 0, BUTTONSIZE, "3"), BUTTON(LM, 3, 0, BUTTONSIZE, "C"),
        BUTTON(LM, 0, 1, 16, "4"), BUTTON(LM, 1, 1, 16, "5"), BUTTON(LM, 2, 1, 16, "6"), BUTTON(LM, 3, 1, 16, "Help"),
        BUTTON(LM, 0, 2, -16, "7"), BUTTON(LM, 1, 2, -16, "8"), BUTTON(LM, 2, 2, -16, "9"), BUTTON(LM, 3, 2, -16, "Del"),
        BUTTON(LM, 0, 3, -48, "."), BUTTON(LM, 1, 3, -48, "0"), LASTBUTTON(LM, 2, 3, -100, "Next")
    };

    buttonStruct buttonsiP[] = {
        BUTTON(LM*2+20, 0, 0, 48, "1"), BUTTON(LM*2+20, 1, 0, 48, "2"), BUTTON(LM*2+20, 2, 0, 48, "3"), BUTTON(LM*2+20, 3, 0, 48, "C"),
        BUTTON(LM*2+20, 0, 1, -20, "4"), BUTTON(LM*2+20, 1, 1, -20, "5"), BUTTON(LM*2+20, 2, 1, -20, "6"), BUTTON(LM*2+20, 3, 1, -20, "Help"),
        BUTTON(LM*2+20, 0, 2, -88, "7"), BUTTON(LM*2+20, 1, 2, -88, "8"), BUTTON(LM*2+20, 2, 2, -88, "9"), BUTTON(LM*2+20, 3, 2, -88, "Del"),
        BUTTON(LM*2+20, 0, 3, -156, "."), BUTTON(LM*2+20, 1, 3, -156, "0"), LASTBUTTON(LM*2+20, 2, 3, -156, "Next")
    };
    
    buttonStruct *deviceButtons[] = {
        buttons4, buttons5, buttonsiP
    };

    for (int i = 0; i < sizeof(buttons4)/sizeof(buttonStruct); i++) {
        CGRect rect = CGRectMake(deviceButtons[deviceType][i].x,
                                 deviceButtons[deviceType][i].y,
                                 deviceButtons[deviceType][i].w,
                                 deviceButtons[deviceType][i].h);
        [self makeButton:[NSString stringWithUTF8String:deviceButtons[deviceType][i].label] label:nil rect:rect tag:(BTAG + i)];
    }
    
}

- (void)buttonPushed:(MyButton *)sender {
//    NSLog(@"%s, %d", __func__, sender.tag);
    
    if (sender.tag >= FTAG && sender.tag < BTAG) {
        MyButton *b = (MyButton *)[self.view viewWithTag:curField];
        [b setBackgroundColor:curFieldColor];
        b = (MyButton *)[self.view viewWithTag:sender.tag];
        [b setBackgroundColor:fieldColor];
        curField = sender.tag;
        fieldValues[curField - FTAG] = @"";
        [self updateFields];
    } else if (sender.tag >= BTAG) {
        NSString *key = @"";
        switch (sender.tag) {
            case BTAG:
                key = @"1";
                break;
                
            case BTAG + 1:
                key = @"2";
                break;
                
            case BTAG + 2:
                key = @"3";
                break;
                
            case BTAG + 3:
                key = @"C";
                break;
                
            case BTAG + 4:
                key = @"4";
                break;
                
            case BTAG + 5:
                key = @"5";
                break;
                
            case BTAG + 6:
                key = @"6";
                break;
                
            case BTAG + 7:
                key = @"Help";
                break;
                
            case BTAG + 8:
                key = @"7";
                break;
                
            case BTAG + 9:
                key = @"8";
                break;
                
            case BTAG + 10:
                key = @"9";
                break;
                
            case BTAG + 11:
                key = @"Del";
                break;
                
            case BTAG + 12:
                key = @".";
                break;
                
            case BTAG + 13:
                key = @"0";
                break;
                
            case BTAG + 14:
                key = @"Next";
                break;
                
            default:
                break;
        }
        NSString *s = fieldValues[curField - FTAG];
        if ([key isEqualToString:@"Del"]) {
            if (s.length > 0) {
                s = [s substringToIndex:s.length - 1];
                [fieldValues replaceObjectAtIndex:curField - FTAG withObject:s];
                [self updateFields];
            }
        } else if ([key isEqualToString:@"C"]) {
            [self initGUI];
        } else if ([key isEqualToString:@"Del"]) {
            if (curField == NumUnitsA && [fieldValues[NumUnitsA] length] == 0) {
                fieldValues[NumUnitsA - FTAG] = @"1";
                MyButton *b = (MyButton *)[self.view viewWithTag:NumUnitsA];
                [b setTitle:@"1" forState:UIControlStateNormal];
                [b setTitle:@"1" forState:UIControlStateSelected];
            } else if (curField == NumUnitsB && [fieldValues[NumUnitsB] length] == 0) {
                fieldValues[NumUnitsB - FTAG] = @"1";
                MyButton *b = (MyButton *)[self.view viewWithTag:NumUnitsB];
                [b setTitle:@"1" forState:UIControlStateNormal];
                [b setTitle:@"1" forState:UIControlStateSelected];
            }
        } else if ([key isEqualToString:@"Next"]) {
            if (curField == NumUnitsA && [fieldValues[NumUnitsA - FTAG] length] == 0) {
                fieldValues[NumUnitsA - FTAG] = @"1";
            } else if (curField == NumUnitsB && [fieldValues[NumUnitsB - FTAG] length] == 0) {
                fieldValues[NumUnitsB - FTAG] = @"1";
            }
            NSInteger i = curField - FTAG;
            i = ((i + 1) % nInputFields);
            curField = FTAG + i;

            BOOL curFieldWasQuantity;
            curFieldWasQuantity = curField == Quantity;
            int nFilled = 0;
            for (int i = 0; i < nInputFields; i++) {
                if ([(NSString *)fieldValues[i] length] > 0) {
                    nFilled++;
                }
            }
            // allow Qty to be empty, calculate it
            if (nFilled == nInputFields || (nFilled == nInputFields -1 && [fieldValues[Quantity - FTAG] length] == 0) || curFieldWasQuantity) {
                [self showResult:curFieldWasQuantity];
            }
            [self updateFields];
        } else if ([key isEqualToString:@"Help"]) {
        } else if ([key isEqualToString:@"."]) {
            NSRange r = [s rangeOfString:@"."];
            if (r.location == NSNotFound) {
                fieldValues[curField - FTAG] = [s stringByAppendingString:key];
                [self updateFields];
                [self showResult:NO];
            }
        } else {
            fieldValues[curField - FTAG] = [s stringByAppendingString:key];
            [self updateFields];
            [self showResult:NO];
        }
    } else {
        NSLog(@"Ooops");
    }
}

- (void)makeButton:(NSString *)text label:(NSString *)label rect:(CGRect)rect tag:(NSInteger)tag  {
    // if a label is missing it's on the keypad, therefore it needs a gradient
    MyButton *b = [[MyButton alloc] initWithFrame:rect];
    [b addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor whiteColor], nil]];
    [b setBackgroundColors:[NSArray arrayWithObjects:fieldColor, curFieldColor, [UIColor grayColor], nil]];
    [b setTitle:text forState:UIControlStateNormal];
    [b setTitle:text forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:fontSizes.button];
    b.tag = tag;
    if (label == nil) {
        if ([text isEqualToString:@"Next"]) {
            [b setBackgroundImage:[UIImage imageNamed:(deviceType == iPad) ? @"ButtonGradient4.png" : @"ButtonGradient2.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:(deviceType == iPad) ? @"ButtonGradient4.png" : @"ButtonGradient2.png"] forState:UIControlStateSelected];
        } else {
            [b setBackgroundImage:[UIImage imageNamed:(deviceType == iPad) ? @"ButtonGradient3.png" : @"ButtonGradient.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:(deviceType == iPad) ? @"ButtonGradient3.png" : @"ButtonGradient.png"] forState:UIControlStateSelected];
        }
    } else {
        [b setBackgroundColor:(tag == curField) ? fieldColor : curFieldColor];
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

- (void)showResult:(BOOL)noQty {
    float qty = [fieldValues[Quantity - FTAG] floatValue];
    float priceA = [fieldValues[PriceA - FTAG] floatValue];
    float nUnitsA = [fieldValues[NumUnitsA  - FTAG] floatValue];
    float unitPriceA = priceA / nUnitsA;
    fieldValues[UnitPriceA - FTAG] = [NSString stringWithFormat:@"%.2f", unitPriceA];
    
    float priceB = [fieldValues[PriceB - FTAG] floatValue];
    float nUnitsB = [fieldValues[NumUnitsB - FTAG] floatValue];
    float unitPriceB = priceB / nUnitsB;
    fieldValues[UnitPriceB - FTAG] = [NSString stringWithFormat:@"%.2f", unitPriceB];
    
    NSString *result;
    if (unitPriceA < unitPriceB || unitPriceA > unitPriceB) {
        //=ABS(A8-C8)*B7
        if (noQty) {
            qty = (unitPriceA < unitPriceB) ? nUnitsA : nUnitsB;
            fieldValues[Quantity - FTAG] = [NSString stringWithFormat:@"%.0f", qty];
        } else {
            qty = [fieldValues[Quantity - FTAG] floatValue];
        }
        float savings = ABS(unitPriceA - unitPriceB) * qty;
        result = [NSString stringWithFormat:@"%@ saves %.2f", (unitPriceA < unitPriceB) ? @"A" : @"B", savings];
    } else {
        result = @"A and B are equal";
    }
    fieldValues[Result - FTAG] = result; 
    [self updateFields];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
