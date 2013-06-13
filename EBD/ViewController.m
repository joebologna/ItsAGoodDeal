//
//  ViewController.m
//  EBD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "ViewController.h"
#import "MyButton.h"
#import "MyStoreObserver.h"

#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FTAG 100
#define BTAG 200
#define LTAG 300
#define KTAG 400
#define T2I(base, tag) (tag - base)
#define I2T(base, index) (base + index)
#define BTITLE(b, t) [b setTitle:t forState:UIControlStateNormal]; [b setTitle:t forState:UIControlStateSelected];

#define STORE "Remove Ads"
#define THANKS "Thank You"
#define CLR "C"
#define NEXT "Next"
#define DEL "Del"
#define K_STORE (KTAG + 7)

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

#if DEBUG==1
static BOOL debug = YES;
#else
static BOOL debug = NO;
#endif

@interface ViewController () <ADBannerViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *fieldValues;
    UIColor *fieldColor, *curFieldColor;
    DeviceType deviceType;
    NSInteger curField;
    BOOL directTap;
    MyStoreObserver *myStoreObserver;
}

@end

@implementation ViewController

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"%s", __func__);
    [banner setHidden:myStoreObserver.bought];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ADBannerView *adView = (ADBannerView *)[self.view viewWithTag:Ad];
    adView.delegate = self;
    
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
    
    myStoreObserver = [MyStoreObserver myStoreObserver];
    myStoreObserver.delegate = self;
    
    NSLog(@"%s, %@", __func__, myStoreObserver);
}

- (void)initGUI {
    directTap = NO;
    fieldValues = [NSMutableArray array];
    for (int i = PriceA; i <= Result; i++) {
        [fieldValues addObject:@""];
    }
    curField = FTAG;
    [self updateFields];
    [self setAdButtonState];
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
#define YO2(y) (y - 32)

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
        LABEL(8, YO(29), 56, 21, 12, "Price A,B"),
        LABEL(8, YO(65), 56, 21, 12, "# of Units"),
        LABEL(8, YO(101), 56, 21, 12, "Quantity"),
        LABEL(8, YO(137), 56, 21, 12, "Unit Cost")
    };

    labelStruct labels5[] = {
        LABEL(8, YO(24), 56, 21, 13, "Price A,B"),
        LABEL(8, YO(79), 56, 21, 13, "# of Units"),
        LABEL(8, YO(135), 56, 21, 13, "Quantity"),
        LABEL(8, YO(189), 56, 21, 13, "Unit Cost")
    };

    labelStruct labelsiP[] = {
        LABEL(8, YO(34), 80, 21, 18, "Price A,B"),
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
        LABEL(20, YO(219), 64, 46, 15, "1"),
        LABEL(92, YO(219), 64, 46, 15, "2"),
        LABEL(164, YO(219), 64, 46, 15, "3"),
        LABEL(236, YO(219), 64, 46, 15, CLR),
        LABEL(20, YO(272), 64, 46, 15, "4"),
        LABEL(92, YO(272), 64, 46, 15, "5"),
        LABEL(164, YO(272), 64, 46, 15, "6"),
        LABEL(236, YO(272), 64, 46, 15, STORE),
        LABEL(20, YO(325), 64, 46, 15, "7"),
        LABEL(92, YO(325), 64, 46, 15, "8"),
        LABEL(164, YO(325), 64, 46, 15, "9"),
        LABEL(236, YO(325), 64, 46, 15, DEL),
        LABEL(20, YO(378), 64, 46, 15, "."),
        LABEL(92, YO(378), 64, 46, 15, "0"),
        LABEL(164, YO(378), 136, 46, 15, NEXT)
    };
    
    labelStruct keypad5[] = {
        LABEL(20, YO(221), 64, 66, 15, "1"),
        LABEL(92, YO(221), 64, 66, 15, "2"),
        LABEL(164, YO(221), 64, 66, 15, "3"),
        LABEL(236, YO(221), 64, 66, 15, CLR),
        LABEL(20, YO(294), 64, 66, 15, "4"),
        LABEL(92, YO(294), 64, 66, 15, "5"),
        LABEL(164, YO(294), 64, 66, 15, "6"),
        LABEL(236, YO(294), 64, 66, 15, STORE),
        LABEL(20, YO(367), 64, 66, 15, "7"),
        LABEL(92, YO(367), 64, 66, 15, "8"),
        LABEL(164, YO(367), 64, 66, 15, "9"),
        LABEL(236, YO(367), 64, 66, 15, DEL),
        LABEL(20, YO(440), 64, 66, 15, "."),
        LABEL(92, YO(440), 64, 66, 15, "0"),
        LABEL(164, YO(440), 136, 66, 15, NEXT)
    };
    
    labelStruct keypadiP[] = {
        LABEL(20, YO2(430), 176, 128, 48, "1"),
        LABEL(204, YO2(430), 176, 128, 48, "2"),
        LABEL(388, YO2(430), 176, 128, 48, "3"),
        LABEL(572, YO2(430), 176, 128, 48, CLR),
        LABEL(20, YO2(565), 176, 128, 48, "4"),
        LABEL(204, YO2(565), 176, 128, 48, "5"),
        LABEL(388, YO2(565), 176, 128, 48, "6"),
        LABEL(572, YO2(565), 176, 128, 36, STORE),
        LABEL(20, YO2(700), 176, 128, 48, "7"),
        LABEL(204, YO2(700), 176, 128, 48, "8"),
        LABEL(388, YO2(700), 176, 128, 48, "9"),
        LABEL(572, YO2(700), 176, 128, 48, DEL),
        LABEL(20, YO2(835), 176, 128, 48, "."),
        LABEL(204, YO2(835), 176, 128, 48, "0"),
        LABEL(388, YO2(835), 360, 128, 48, NEXT)
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
            key = @CLR;
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
            
        case K_STORE:
            key = @STORE;
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
            key = @DEL;
            break;
            
        case KTAG + 12:
            key = @".";
            break;
            
        case KTAG + 13:
            key = @"0";
            break;
            
        case KTAG + 14:
            key = @NEXT;
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
        directTap = YES;
    } else  if ((sender.tag >= UnitPriceA) && (sender.tag <= Result)) {
        [self showResult];
    } else if (sender.tag >= BTAG) {
        if (directTap) {
            directTap = NO;
            fieldValues[T2I(FTAG, curField)] = @"";
        }
        NSString *s = fieldValues[T2I(FTAG, curField)];
        NSString *key = [self getKey:sender];
        if ([key isEqualToString:@DEL]) {
            if (s.length > 0) {
                s = [s substringToIndex:s.length - 1];
                fieldValues[T2I(FTAG, curField)] = s;
            }
        } else if ([key isEqualToString:@CLR]) {
            [self initGUI];
        } else if ([key isEqualToString:@NEXT]) {
            if (curField == PriceA && [fieldValues[T2I(FTAG, NumUnitsA)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsA)] = @"1";
            } else if (curField == PriceB && [fieldValues[T2I(FTAG, NumUnitsB)] length] == 0) {
                fieldValues[T2I(FTAG, NumUnitsB)] = @"1";
            }
            NSInteger i = T2I(FTAG, curField);
            i = ((i + 1) % nInputFields);
            curField = I2T(FTAG, i);

            int nFilled = 0;
            for (int i = 0; i < nInputFields; i++) {
                if ([(NSString *)fieldValues[i] length] > 0) {
                    nFilled++;
                }
            }
            // allow Qty to be empty, calculate it
            if ((nFilled == nInputFields) || ((nFilled == (nInputFields - 1)) && ([fieldValues[T2I(FTAG, Quantity)] length] == 0))) {
                [self showResult];
            }

        } else if ([key isEqualToString:@STORE]) {
            if (!myStoreObserver.bought || debug) {
                if ([SKPaymentQueue canMakePayments]) {
                    [self removeAds];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"Use Settings to enable payments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
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
    b.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    b.titleLabel.textAlignment = NSTextAlignmentCenter;
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
- (void)showResult {
    NSString *qString = fieldValues[T2I(FTAG, Quantity)];
    float qty;
    if (qString.length == 0) {
        qty = 1;
    } else {
        qty = [qString floatValue];
    }
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
        qString = fieldValues[T2I(FTAG, Quantity)];
        if (qString.length != 0) {
            qty = [qString floatValue];
        } else {
            qty = (unitPriceA < unitPriceB) ? nUnitsA : nUnitsB;
        }
        float savings = ABS(unitPriceA - unitPriceB) * qty;
        result = [NSString stringWithFormat:@"%@ saves %.2f", (unitPriceA < unitPriceB) ? @"A" : @"B", savings];
    } else {
        result = @"A and B are equal";
    }
    fieldValues[T2I(FTAG, Result)] = result;
    [self updateFields];
}

- (void)removeAds {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@STORE message:@"Do you wish to remove Ads for $0.99" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![[alertView title] isEqualToString:@"Payments Disabled"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
            NSLog(@"Buy it here");
//            self.bought = YES;
            [self doPayment];
        } else {
            if (debug) {
                myStoreObserver.bought = NO;
                [self setAdButtonState];
            } else {
                NSLog(@"Dont do anything");
            }
        }
//        [self setAdButtonState];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)doPayment {
    if (myStoreObserver.myProducts.count > 0) {
        SKProduct *selectedProduct = myStoreObserver.myProducts[0];
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        NSLog(@"no products found");
    }
}

- (void)setAdButtonState {
    NSLog(@"%s", __func__);
    ADBannerView *a = (ADBannerView *)[self.view viewWithTag:Ad];
    MyButton *b = (MyButton *)[self.view viewWithTag:(K_STORE)];
    [a setHidden:myStoreObserver.bought];
    BTITLE(b, myStoreObserver.bought ? @THANKS : @STORE);
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

- (void)processCompleted {
    NSLog(@"%s", __func__);
    [self setAdButtonState];
}

@end
