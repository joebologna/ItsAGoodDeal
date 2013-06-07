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

#define FTAG 100
#define BTAG 200
#define LTAG 300
#define KTAG 400
#define T2I(base, tag) (tag - base)
#define I2T(base, index) (base + index)
#define BTITLE(b, t) [b setTitle:t forState:UIControlStateNormal]; [b setTitle:t forState:UIControlStateSelected];

typedef enum {
    PriceA = I2T(FTAG, 0), PriceB = I2T(FTAG, 1),
    NumUnitsA = I2T(FTAG, 2), NumUnitsB = I2T(FTAG, 3),
    Quantity = I2T(FTAG, 4),
    UnitPriceA = I2T(FTAG, 5), UnitPriceB = I2T(FTAG, 6),
    Result = I2T(FTAG, 7),
    Ad = 999
} Field;

#define nInputFields (Quantity - FTAG + 1)

typedef enum {
    iPhone4 = 0, iPhone5 = 1, iPad = 2
} DeviceType;

typedef struct {
    CGRect rect;
    CGFloat f;
    char *label;
} labelStruct;

@interface ViewController () <ADBannerViewDelegate> {
    NSMutableArray *fieldValues;
    UIColor *fieldColor, *curFieldColor;
    DeviceType deviceType;
    NSInteger curField;
}

@end

@implementation ViewController

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"%s", __func__);
    [banner setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((ADBannerView *)[self.view viewWithTag:Ad]).delegate = self;
    
    // iPhone 4 = 480, iPhone 5 = 568, iPad > 568
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height <= 480) {
        deviceType = iPhone4;
    } else if (height > 480 && height <= 568) {
        deviceType = iPhone5;
    } else {
        deviceType = iPad;
    }
    
    fieldColor = UIColorFromRGB(0x86e4ae);
    curFieldColor = UIColorFromRGB(0x86ffcf);

    self.view.backgroundColor = [UIColor colorWithRed:0.326184 green:0.914025 blue:0.620324 alpha:1];
    [self populateScreen];
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
        NSInteger i = T2I(FTAG, tag);
        MyButton *b = (MyButton *)[self.view viewWithTag:tag];
        BTITLE(b, fieldValues[i]);
        [b setBackgroundColor:(tag == curField) ? curFieldColor : fieldColor];
    }
}

#define LABEL(x, y, w, h, f, t) { x, y, w, h, f, t}
#define YO(y) (y - 18)

- (void)populateScreen {
    labelStruct fields4[] = {
        LABEL(70, YO(29), 111, 30, 17, ""), LABEL(189, YO(29), 111, 30, 17, ""),
        LABEL(70, YO(65), 111, 30, 17, ""), LABEL(189, YO(65), 111, 30, 17, ""),
        LABEL(70, YO(101), 230, 30, 17, ""),
        LABEL(70, YO(137), 111, 30, 17, ""), LABEL(189, YO(137), 111, 30, 17, ""),
        LABEL(20, YO(173), 280, 30, 17, "")
    };
    
    labelStruct fields5[] = {
        LABEL(70, YO(24), 111, 47, 18, ""), LABEL(189, YO(24), 111, 47, 18, ""),
        LABEL(70, YO(79), 111, 47, 18, ""), LABEL(189, YO(79), 111, 47, 18, ""),
        LABEL(70, YO(135), 230, 47, 18, ""),
        LABEL(70, YO(189), 111, 47, 18, ""), LABEL(189, YO(189), 111, 47, 18, ""),
        LABEL(20, YO(244), 280, 47, 18, "")
    };
    
    labelStruct fieldsiP[] = {
        LABEL(108, YO(34), 316, 86, 48, ""), LABEL(432, YO(34), 316, 86, 48, ""),
        LABEL(108, YO(128), 316, 86, 48, ""), LABEL(432, YO(128), 316, 86, 48, ""),
        LABEL(108, YO(223), 640, 86, 48, ""),
        LABEL(108, YO(316), 316, 86, 48, ""), LABEL(432, YO(316), 316, 86, 48, ""),
        LABEL(24, YO(409), 724, 86, 48, "")
    };
    
    labelStruct *deviceFields[] = {
        fields4, fields5, fieldsiP
    };
    
    for (int i = 0; i < sizeof(fields4)/sizeof(labelStruct); i++) {
        [self makeButton:deviceFields[deviceType][i] tag:I2T(FTAG, i) isKey:NO];
    }
    
    labelStruct labels4[] = {
        LABEL(8, YO(29), 56, 21, 12, "Price"),
        LABEL(8, YO(65), 56, 21, 12, "# of Units"),
        LABEL(8, YO(101), 56, 21, 12, "Quantity"),
        LABEL(8, YO(137), 56, 21, 12, "Unit Cost")
    };

    labelStruct labels5[] = {
        LABEL(8, YO(24), 56, 21, 13, "Price"),
        LABEL(8, YO(79), 56, 21, 13, "# of Units"),
        LABEL(8, YO(135), 56, 21, 13, "Quantity"),
        LABEL(8, YO(189), 56, 21, 13, "Unit Cost")
    };

    labelStruct labelsiP[] = {
        LABEL(8, YO(34), 80, 21, 18, "Price"),
        LABEL(8, YO(128), 80, 21, 18, "# of Units"),
        LABEL(8, YO(223), 80, 21, 18, "Quantity"),
        LABEL(8, YO(316), 80, 21, 18, "Unit Cost")
    };
    
    labelStruct *deviceLabels[] = {
        labels4, labels5, labelsiP
    };

    for (int i = 0; i < sizeof(labels4)/sizeof(labelStruct); i++) {
        [self makeLabel:deviceLabels[deviceType][i] tag:I2T(LTAG, i)];
    }
    
    labelStruct keypad4[] = {
        LABEL(20, YO(211), 64, 48, 15, "1"),
        LABEL(92, YO(211), 64, 48, 15, "2"),
        LABEL(164, YO(211), 64, 48, 15, "3"),
        LABEL(236, YO(211), 64, 48, 15, "C"),
        LABEL(20, YO(266), 64, 48, 15, "4"),
        LABEL(92, YO(266), 64, 48, 15, "5"),
        LABEL(164, YO(266), 64, 48, 15, "6"),
        LABEL(236, YO(266), 64, 48, 15, "Help"),
        LABEL(20, YO(320), 64, 48, 15, "7"),
        LABEL(92, YO(320), 64, 48, 15, "8"),
        LABEL(164, YO(320), 64, 48, 15, "9"),
        LABEL(236, YO(320), 64, 48, 15, "Del"),
        LABEL(20, YO(375), 64, 48, 15, "."),
        LABEL(92, YO(375), 64, 48, 15, "0"),
        LABEL(164, YO(375), 136, 48, 15, "Next")
    };
    
    labelStruct keypad5[] = {
        LABEL(20, YO(299), 64, 48, 15, "1"),
        LABEL(92, YO(299), 64, 48, 15, "2"),
        LABEL(164, YO(299), 64, 48, 15, "3"),
        LABEL(236, YO(299), 64, 48, 15, "C"),
        LABEL(20, YO(354), 64, 48, 15, "4"),
        LABEL(92, YO(354), 64, 48, 15, "5"),
        LABEL(164, YO(354), 64, 48, 15, "6"),
        LABEL(236, YO(354), 64, 48, 15, "Help"),
        LABEL(20, YO(408), 64, 48, 15, "7"),
        LABEL(92, YO(408), 64, 48, 15, "8"),
        LABEL(164, YO(408), 64, 48, 15, "9"),
        LABEL(236, YO(408), 64, 48, 15, "Del"),
        LABEL(20, YO(463), 64, 48, 15, "."),
        LABEL(92, YO(463), 64, 48, 15, "0"),
        LABEL(164, YO(463), 136, 48, 15, "Next")
    };
    
    labelStruct keypadiP[] = {
        LABEL(24, YO(510), 174, 105, 48, "1"),
        LABEL(206, YO(510), 174, 105, 48, "2"),
        LABEL(388, YO(510), 174, 105, 48, "3"),
        LABEL(570, YO(510), 174, 105, 48, "C"),
        LABEL(24, YO(623), 174, 105, 48, "4"),
        LABEL(206, YO(623), 174, 105, 48, "5"),
        LABEL(388, YO(623), 174, 105, 48, "6"),
        LABEL(570, YO(623), 174, 105, 48, "Help"),
        LABEL(24, YO(734), 174, 105, 48, "7"),
        LABEL(206, YO(734), 174, 105, 48, "8"),
        LABEL(388, YO(734), 174, 105, 48, "9"),
        LABEL(570, YO(734), 174, 105, 48, "Del"),
        LABEL(24, YO(845), 174, 105, 48, "."),
        LABEL(206, YO(845), 174, 105, 48, "0"),
        LABEL(388, YO(845), 356, 105, 48, "Next")
    };
    
    labelStruct *deviceKeys[] = {
        keypad4, keypad5, keypadiP
    };
    
    for (int i = 0; i < sizeof(keypad4)/sizeof(labelStruct); i++) {
        [self makeButton:deviceKeys[deviceType][i] tag:I2T(KTAG, i) isKey:YES];
    }
}

- (NSString *)getKey:(MyButton *)sender {
    NSString *key = @"";
    switch (sender.tag) {
        case KTAG:
            key = @"1";
            break;
            
        case KTAG + 1:
            key = @"2";
            break;
            
        case KTAG + 2:
            key = @"3";
            break;
            
        case KTAG + 3:
            key = @"C";
            break;
            
        case KTAG + 4:
            key = @"4";
            break;
            
        case KTAG + 5:
            key = @"5";
            break;
            
        case KTAG + 6:
            key = @"6";
            break;
            
        case KTAG + 7:
            key = @"Help";
            break;
            
        case KTAG + 8:
            key = @"7";
            break;
            
        case KTAG + 9:
            key = @"8";
            break;
            
        case KTAG + 10:
            key = @"9";
            break;
            
        case KTAG + 11:
            key = @"Del";
            break;
            
        case KTAG + 12:
            key = @".";
            break;
            
        case KTAG + 13:
            key = @"0";
            break;
            
        case KTAG + 14:
            key = @"Next";
            break;
            
        default:
            break;
    }
    return key;
}

- (void)buttonPushed:(MyButton *)sender {
//    NSLog(@"%s, %d", __func__, sender.tag);

    if ((sender.tag >= FTAG) && (sender.tag <= Quantity)) {
        MyButton *b = (MyButton *)[self.view viewWithTag:curField];
        [b setBackgroundColor:curFieldColor];
        b = (MyButton *)[self.view viewWithTag:sender.tag];
        [b setBackgroundColor:fieldColor];
        curField = sender.tag;
        fieldValues[T2I(FTAG, curField)] = @"";
    } else  if ((sender.tag >= UnitPriceA) && (sender.tag <= Result)) {
        [self showResult:NO];
    } else if (sender.tag >= BTAG) {
        NSString *s = fieldValues[T2I(FTAG, curField)];
        NSString *key = [self getKey:sender];
        if ([key isEqualToString:@"Del"]) {
            if (s.length > 0) {
                s = [s substringToIndex:s.length - 1];
                fieldValues[T2I(FTAG, curField)] = s;
            }
        } else if ([key isEqualToString:@"C"]) {
            [self initGUI];
        } else if ([key isEqualToString:@"Del"]) {
            if (curField == NumUnitsA && [fieldValues[T2I(FTAG, NumUnitsA)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsA)] = @"1";
            } else if (curField == NumUnitsB && [fieldValues[T2I(FTAG, NumUnitsB)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsB)] = @"1";
            }
            [self updateFields];
        } else if ([key isEqualToString:@"Next"]) {
            if (curField == PriceA && [fieldValues[T2I(FTAG, NumUnitsA)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsA)] = @"1";
            } else if (curField == PriceB && [fieldValues[T2I(FTAG, NumUnitsB)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsB)] = @"1";
            }
            NSInteger i = T2I(FTAG, curField);
            i = ((i + 1) % nInputFields);
            curField = I2T(FTAG, i);

            BOOL curFieldWasQuantity;
            curFieldWasQuantity = (curField == Quantity);
            int nFilled = 0;
            for (int i = 0; i < nInputFields; i++) {
                if ([(NSString *)fieldValues[i] length] > 0) {
                    nFilled++;
                }
            }
            // allow Qty to be empty, calculate it
            if (nFilled == nInputFields || (nFilled == nInputFields -1 && [fieldValues[T2I(FTAG, Quantity)] length] == 0) || curFieldWasQuantity) {
                [self showResult:curFieldWasQuantity];
            }

        } else if ([key isEqualToString:@"Help"]) {
            ADBannerView *a = (ADBannerView *)[self.view viewWithTag:Ad];
            if (a.isHidden) {
                [a setHidden:NO];
            } else {
                [a setHidden:YES];
            }
        } else if ([key isEqualToString:@"."]) {
            NSRange r = [s rangeOfString:@"."];
            if (r.location == NSNotFound) {
                fieldValues[T2I(FTAG, curField)] = [s stringByAppendingString:key];
            }
        } else {
            fieldValues[T2I(FTAG, curField)] = [s stringByAppendingString:key];
        }
        [self updateFields];
    } else {
        NSLog(@"Ooops");
    }
}

- (void)makeButton:(labelStruct)label tag:(NSInteger)tag isKey:(BOOL)isKey {
    // if a label is missing it's on the keypad, therefore it needs a gradient
    MyButton *b = [[MyButton alloc] initWithFrame:label.rect];
    [b addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor whiteColor], nil]];
    [b setBackgroundColors:[NSArray arrayWithObjects:fieldColor, curFieldColor, [UIColor grayColor], nil]];
    b.titleLabel.font = [UIFont systemFontOfSize:label.f];
    b.tag = tag;
    if (isKey) {
        [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient3.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient.3png"] forState:UIControlStateSelected];
        BTITLE(b, [NSString stringWithCString:label.label encoding:NSASCIIStringEncoding]);
    }
    [b setBackgroundColor:(tag == curField) ? fieldColor : curFieldColor];
    [self.view addSubview:b];
}

- (void)makeLabel:(labelStruct)label tag:(NSInteger)tag  {
    UILabel *l = [[UILabel alloc] initWithFrame:label.rect];
    l.font = [UIFont systemFontOfSize:label.f];
    l.text = [NSString stringWithCString:label.label encoding:NSASCIIStringEncoding];
    l.textAlignment = NSTextAlignmentLeft;
    l.backgroundColor = [UIColor clearColor];
    [self.view addSubview:l];
}

- (void)fillBlank:(Field)f v:(float *)v d:(float)d {
    if ([fieldValues[T2I(FTAG, f)] length] == 0) {
        *v = d;
        fieldValues[T2I(FTAG, f)] = [NSString stringWithFormat:@"%.2f", *v];
    }
}
- (void)showResult:(BOOL)noQty {
    NSLog(@"%s", __func__);
    float qty = [fieldValues[T2I(FTAG, Quantity)] floatValue];
    [self fillBlank:Quantity v:&qty d:1.0];
    float priceA = [fieldValues[T2I(FTAG, PriceA)] floatValue];
    [self fillBlank:PriceA v:&priceA d:1.0];
    float nUnitsA = [fieldValues[T2I(FTAG, NumUnitsA)] floatValue];
    [self fillBlank:NumUnitsA v:&nUnitsA d:1.0];
    float unitPriceA = priceA / nUnitsA;
    fieldValues[T2I(FTAG, UnitPriceA)] = [NSString stringWithFormat:@"%.2f", unitPriceA];
    
    float priceB = [fieldValues[T2I(FTAG, PriceB)] floatValue];
    [self fillBlank:PriceB v:&priceB d:1.0];
    float nUnitsB = [fieldValues[T2I(FTAG, NumUnitsB)] floatValue];
    [self fillBlank:NumUnitsB v:&nUnitsB d:1.0];
    float unitPriceB = priceB / nUnitsB;
    fieldValues[T2I(FTAG, UnitPriceB)] = [NSString stringWithFormat:@"%.2f", unitPriceB];
    
    NSString *result;
    if (unitPriceA < unitPriceB || unitPriceA > unitPriceB) {
        //=ABS(A8-C8)*B7
        if (noQty) {
            qty = (unitPriceA < unitPriceB) ? nUnitsA : nUnitsB;
            fieldValues[T2I(FTAG, Quantity)] = [NSString stringWithFormat:@"%.0f", qty];
        } else {
            qty = [fieldValues[T2I(FTAG, Quantity)] floatValue];
        }
        float savings = ABS(unitPriceA - unitPriceB) * qty;
        result = [NSString stringWithFormat:@"%@ saves %.2f", (unitPriceA < unitPriceB) ? @"A" : @"B", savings];
    } else {
        result = @"A and B are equal";
    }
    fieldValues[T2I(FTAG, Result)] = result;
    [self updateFields];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
