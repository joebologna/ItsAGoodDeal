//
//  ViewController.m
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "ViewController.h"
#import "MyButton.h"
#import "MyStoreObserver.h"
#import "NewSavings.h"

#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>

#pragma mark -
#pragma mark Convenience Macros

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark -
#pragma mark Tags and Field Macros

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

#pragma mark -
#pragma mark Tags and Fields Tables

typedef enum {
    MessageMode,
    ResultsMode
} MessageModes;

typedef enum {
    ItemA = I2T(FTAG, 0), ItemB = I2T(FTAG, 1),
    BetterDealA = I2T(FTAG, 2), BetterDealB = I2T(FTAG, 3),
    PriceA = I2T(FTAG, 4),
    QtyA = I2T(FTAG, 5), SizeA = I2T(FTAG, 6),
    Qty2BuyA = I2T(FTAG, 7),
    PriceB = I2T(FTAG, 8),
    QtyB = I2T(FTAG, 9), SizeB = I2T(FTAG, 10),
    Qty2BuyB = I2T(FTAG, 11),
    Message = I2T(FTAG, 12),
    CostField = I2T(FTAG, 13), SavingsField = I2T(FTAG, 14), MoreField = I2T(FTAG, 15),
    CostLabel = I2T(FTAG, 16), SavingsLabel = I2T(FTAG, 17), MoreLabel = I2T(FTAG, 18),
    Ad = 999
} Field;

static NSInteger InputFields[] = {
    PriceA, QtyA, SizeA,
    PriceB, QtyB, SizeB,
    Qty2BuyA, Qty2BuyB
};

#define nInputFields (sizeof(InputFields)/sizeof(int))

typedef enum {
    iPhone4 = 0, iPhone5 = 1, iPad = 2
} DeviceType;

typedef struct {
    CGRect rect;
    CGFloat f;
    char *label;
} labelStruct;

#define LABEL(x, y, w, h, f, t) { x, y, w, h, f, t}
#define YO11(y) (y - 20)
#define YO12(y) (y - 20)
#define YO13(y) (y - 25)
#define YO21(y) (y - 20)
#define YO22(y) (y - 20)
#define YO23(y) (y - 30)

static labelStruct fieldsIPhone35[] = {
    LABEL(1, YO11(21), 159, 156, 14, "Deal A"),
    LABEL(161, YO11(21), 158, 156, 14, "Deal B"),
    LABEL(10, YO11(146), 136, 30, 8, ""),
    LABEL(174, YO11(146), 136, 30, 8, ""),
    // A
    LABEL(10, YO11(40), 136, 30, 17, "Price A"),
    LABEL(10, YO11(78), 64, 30, 17, "MinQty"), LABEL(82, YO11(78), 64, 30, 17, "Size"),
    LABEL(38, YO11(116), 80, 30, 17, "# to Buy"),
    // B
    LABEL(174, YO11(40), 136, 30, 17, "Price B"),
    LABEL(174, YO11(78), 64, 30, 17, "MinQty"), LABEL(246, YO11(78), 64, 30, 17, "Size"),
    LABEL(202, YO11(116), 80, 30, 17, "# to Buy"),
    // Savings & Messages
    LABEL(1, YO11(178), 318, 40, 17, "Enter Price, Min Qty & Size of Items"),
    LABEL(1, YO11(178), 106, 30, 15, "Cost Field"),
    LABEL(106, YO11(178), 107, 30, 15, "Savings Field"),
    LABEL(212, YO11(178), 106, 30, 15, "More Field"),
    LABEL(1, YO11(206), 106, 10, 9, "Cost"),
    LABEL(106, YO11(206), 107, 10, 9, "Savings"),
    LABEL(212, YO11(206), 106, 10, 9, "Product")
};

static labelStruct fieldsIPhone40[] = {
    LABEL(1, YO11(21), 159, 156, 14, "Deal A"),
    LABEL(161, YO11(21), 158, 156, 14, "Deal B"),
    LABEL(10, YO11(146), 136, 30, 8, ""),
    LABEL(174, YO11(146), 136, 30, 8, ""),
    // A
    LABEL(10, YO11(40), 136, 30, 17, "Price A"),
    LABEL(10, YO11(78), 64, 30, 17, "MinQty"), LABEL(82, YO11(78), 64, 30, 17, "Size"),
    LABEL(38, YO11(116), 80, 30, 17, "# to Buy"),
    // B
    LABEL(174, YO11(40), 136, 30, 17, "Price B"),
    LABEL(174, YO11(78), 64, 30, 17, "MinQty"), LABEL(246, YO11(78), 64, 30, 17, "Size"),
    LABEL(202, YO11(116), 80, 30, 17, "# to Buy"),
    // Savings & Messages
    LABEL(1, YO11(178), 318, 40, 17, "Enter Price, Min Qty & Size of Items"),
    LABEL(1, YO11(178), 106, 30, 17, "Cost Field"),
    LABEL(106, YO11(178), 107, 30, 17, "Savings Field"),
    LABEL(212, YO11(178), 106, 30, 17, "More Field"),
    LABEL(1, YO11(206), 106, 10, 9, "Cost"),
    LABEL(106, YO11(206), 107, 10, 9, "Savings"),
    LABEL(212, YO11(206), 106, 10, 9, "More")
};

static labelStruct fieldsIPad[] = {
    LABEL(1, YO11(21), 394, 352, 30, "Deal A"),
    LABEL(385, YO11(21), 383, 352, 30, "Deal B"),
    LABEL(10, YO11(344), 384, 30, 18, ""),
    LABEL(384, YO11(344), 384, 30, 18, ""),
    // A
    LABEL(10, YO11(70), 366, 86, 48, "Price A"),
    LABEL(10, YO11(164), 177, 86, 48, "MinQty"), LABEL(199, YO11(164), 177, 86, 48, "Size"),
    LABEL(105, YO11(258), 177, 86, 48, "# to Buy"),
    // B
    LABEL(393, YO11(70), 366, 86, 48, "Price B"),
    LABEL(393, YO11(164), 177, 86, 48, "MinQty"), LABEL(582, YO11(164), 177, 86, 48, "Size"),
    LABEL(488, YO11(258), 177, 86, 48, "# to Buy"),
    // Savings & Messages
    LABEL(1, YO11(423), 766, 75, 50, "Enter Price, Min Qty & Size of Items"),
    LABEL(1, YO11(423), 256, 67, 40, "Cost Field"),
    LABEL(256, YO11(423), 257, 67, 40, "Savings Field"),
    LABEL(512, YO11(423), 255, 67, 40, "More Field"),
    LABEL(1, YO11(480), 256, 28, 25, "Cost"),
    LABEL(256, YO11(480), 257, 28, 25, "Savings"),
    LABEL(512, YO11(480), 255, 28, 25, "More")
};

static labelStruct *deviceFields[] = {
    fieldsIPhone35, fieldsIPhone40, fieldsIPad
};

static labelStruct keypadIPhone35[] = {
    LABEL(20, YO21(219), 64, 46, 15, "1"),
    LABEL(92, YO21(219), 64, 46, 15, "2"),
    LABEL(164, YO21(219), 64, 46, 15, "3"),
    LABEL(236, YO21(219), 64, 46, 15, CLR),
    LABEL(20, YO21(272), 64, 46, 15, "4"),
    LABEL(92, YO21(272), 64, 46, 15, "5"),
    LABEL(164, YO21(272), 64, 46, 15, "6"),
    LABEL(236, YO21(272), 64, 46, 15, STORE),
    LABEL(20, YO21(325), 64, 46, 15, "7"),
    LABEL(92, YO21(325), 64, 46, 15, "8"),
    LABEL(164, YO21(325), 64, 46, 15, "9"),
    LABEL(236, YO21(325), 64, 46, 15, DEL),
    LABEL(20, YO21(378), 64, 46, 15, "."),
    LABEL(92, YO21(378), 64, 46, 15, "0"),
    LABEL(164, YO21(378), 136, 46, 15, NEXT)
};

static labelStruct keypadIPhone40[] = {
    LABEL(20, YO21(221), 64, 66, 15, "1"),
    LABEL(92, YO21(221), 64, 66, 15, "2"),
    LABEL(164, YO21(221), 64, 66, 15, "3"),
    LABEL(236, YO21(221), 64, 66, 15, CLR),
    LABEL(20, YO21(295), 64, 66, 15, "4"),
    LABEL(92, YO21(295), 64, 66, 15, "5"),
    LABEL(164, YO21(295), 64, 66, 15, "6"),
    LABEL(236, YO21(295), 64, 66, 15, STORE),
    LABEL(20, YO21(369), 64, 66, 15, "7"),
    LABEL(92, YO21(369), 64, 66, 15, "8"),
    LABEL(164, YO21(369), 64, 66, 15, "9"),
    LABEL(236, YO21(369), 64, 66, 15, DEL),
    LABEL(20, YO21(442), 64, 66, 15, "."),
    LABEL(92, YO21(442), 64, 66, 15, "0"),
    LABEL(164, YO21(442), 136, 66, 15, NEXT)
};

static labelStruct keypadIPad[] = {
    LABEL(20, YO23(576), 176, 92, 48, "1"),
    LABEL(204, YO23(576), 176, 92, 48, "2"),
    LABEL(388, YO23(576), 176, 92, 48, "3"),
    LABEL(572, YO23(576), 176, 92, 48, CLR),
    LABEL(20, YO23(674), 176, 92, 48, "4"),
    LABEL(204, YO23(674), 176, 92, 48, "5"),
    LABEL(388, YO23(674), 176, 92, 48, "6"),
    LABEL(572, YO23(674), 176, 92, 36, STORE),
    LABEL(20, YO23(772), 176, 92, 48, "7"),
    LABEL(204, YO23(772), 176, 92, 48, "8"),
    LABEL(388, YO23(772), 176, 92, 48, "9"),
    LABEL(572, YO23(772), 176, 92, 48, DEL),
    LABEL(20, YO23(870), 176, 92, 48, "."),
    LABEL(204, YO23(870), 176, 92, 48, "0"),
    LABEL(388, YO23(870), 360, 92, 48, NEXT)
};

static labelStruct *deviceKeys[] = {
    keypadIPhone35, keypadIPhone40, keypadIPad
};

#pragma mark -
#pragma mark Debug Variables

typedef enum { AisBigger, AisBetter, BisBetter, Same, NotTesting } Test;

#if DEBUG==1
static BOOL debug = YES;
static Test testToRun = AisBigger;
#else
static BOOL debug = NO;
static Test testToRun = NotTesting;
#endif

#pragma mark -
#pragma mark Instance Properties

@interface ViewController () <ADBannerViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *fieldValues;
    UIColor *fieldColor, *curFieldColor, *backgroundColor, *highlightColor;
    DeviceType deviceType;
    NSInteger curFieldIndex;
    BOOL directTap;
    MyStoreObserver *myStoreObserver;
}

@end

#pragma mark -
#pragma mark View Delegate

@implementation ViewController

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
    
    curFieldColor = UIColorFromRGB(0x86e4ae);
    fieldColor = UIColorFromRGB(0xaaffcf);
    backgroundColor = UIColorFromRGB(0x53e99e);
    highlightColor = UIColorFromRGB(0xd2fde8);

    self.view.backgroundColor = backgroundColor;
    
    [self populateScreen];
    [self initGUI];
    
    myStoreObserver = [MyStoreObserver myStoreObserver];
    myStoreObserver.delegate = self;
    
#ifdef DEBUG
    NSLog(@"%s, %@", __func__, myStoreObserver);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Handle Screen

- (void)initGUI {
    directTap = NO;
    fieldValues = [NSMutableArray array];
    for (int i = ItemA; i <= MoreLabel; i++) {
        if (i == PriceA || i == PriceB) {
            [fieldValues addObject:[self fmtPrice:0.0]];
        } else {
            [fieldValues addObject:@""];
        }
    }
    curFieldIndex = 0;
    [self setMessageMode:MessageMode];
    [self updateFields:YES];
    
    switch (testToRun) {
        case AisBigger:
            fieldValues[T2I(FTAG, PriceA)] = [self fmtPrice:17.0];
            fieldValues[T2I(FTAG, PriceB)] = [self fmtPrice:11.0];
            fieldValues[T2I(FTAG, QtyA)] = @"1";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"100";
            fieldValues[T2I(FTAG, SizeB)] = @"50";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"1";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"1";
            testToRun = AisBetter;
            break;
            
        case AisBetter:
            fieldValues[T2I(FTAG, PriceA)] = [self fmtPrice:3.0];
            fieldValues[T2I(FTAG, PriceB)] = [self fmtPrice:2.0];
            fieldValues[T2I(FTAG, QtyA)] = @"2.00";
            fieldValues[T2I(FTAG, QtyB)] = @"1.00";
            fieldValues[T2I(FTAG, SizeA)] = @"1.56";
            fieldValues[T2I(FTAG, SizeB)] = @"1.98";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"4";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"4";
            testToRun = BisBetter;
            break;
        
        case BisBetter:
            fieldValues[T2I(FTAG, PriceA)] = [self fmtPrice:1.99];
            fieldValues[T2I(FTAG, PriceB)] = [self fmtPrice:2.99];
            fieldValues[T2I(FTAG, QtyA)] = @"1";
            fieldValues[T2I(FTAG, QtyB)] = @"2";
            fieldValues[T2I(FTAG, SizeA)] = @"8.5";
            fieldValues[T2I(FTAG, SizeB)] = @"7.5";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"2";
            testToRun = Same;
            break;
        
        case Same:
            fieldValues[T2I(FTAG, PriceA)] = [self fmtPrice:2];
            fieldValues[T2I(FTAG, PriceB)] = [self fmtPrice:1];
            fieldValues[T2I(FTAG, QtyA)] = @"2";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            fieldValues[T2I(FTAG, SizeB)] = @"1";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"2";
            testToRun = NotTesting;
            break;
        
        case NotTesting:
            break;
        default:
            break;
    }
    [self clrHighLight];
    [self showResult];
    [self setAdButtonState];
}

- (void)highLight:(Field)tag {
    UITextField *t = (UITextField *)[self.view viewWithTag:tag];
    if (tag == ItemA || tag == ItemB) {
        // do nothing
    } else {
        t.borderStyle = (tag == InputFields[curFieldIndex]) ? UITextBorderStyleLine : UITextBorderStyleNone;
    }
    t.backgroundColor = highlightColor;
}

- (void)clrHighLight {
    NSInteger tags[] = {ItemA, ItemB, Message};
    NSInteger nTags = sizeof(tags)/sizeof(NSInteger);
    for (NSInteger i = 0; i < nTags; i++) {
        NSInteger tag = tags[i];
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        if (tag == ItemA) {
            t.backgroundColor = backgroundColor;
        } else if (tag == ItemB) {
            t.backgroundColor = backgroundColor;
        }
    }
}

- (void)updateFields:(BOOL)useDefaultValues {
    for (int tag = ItemA; tag <= MoreField; tag++) {
        NSInteger i = T2I(FTAG, tag);
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        if (tag ==  ItemA || tag == ItemB) {
            if ([t.backgroundColor isEqual:[UIColor clearColor]]) {
                t.borderStyle = UITextBorderStyleNone;
            } else {
                t.borderStyle = UITextBorderStyleLine;
            }
        } else if (tag == Message) {
            t.borderStyle = UITextBorderStyleLine;
            if (tag == ItemA || tag == ItemB) {
                t.backgroundColor = highlightColor;
                t.borderStyle = UITextBorderStyleLine;
            } else {
                t.backgroundColor = [UIColor clearColor];
                t.borderStyle = UITextBorderStyleNone;
            }
            NSString *msg = useDefaultValues ? [NSString stringWithCString:deviceFields[deviceType][i].label encoding:NSASCIIStringEncoding] : fieldValues[i];
            t.text = (msg.length == 0) ? [NSString stringWithCString:deviceFields[deviceType][i].label encoding:NSASCIIStringEncoding] : msg;
        } else if (tag == BetterDealA || tag == BetterDealB) {
            t.backgroundColor = [UIColor clearColor];
            t.borderStyle = UITextBorderStyleNone;
            t.text = fieldValues[i];
        } else {
            if (tag >= CostField && tag <= MoreLabel) {
                t.backgroundColor = [UIColor clearColor];
            } else {
                t.backgroundColor = (tag == InputFields[curFieldIndex]) ? curFieldColor : fieldColor;
            }
            t.borderStyle = (tag == InputFields[curFieldIndex]) ? UITextBorderStyleLine : UITextBorderStyleNone;
            t.text = fieldValues[i];
        }
    }
}

- (void)setMessageMode:(MessageModes)mode {
    Field fields[] = { Message, CostField, SavingsField, MoreField };
    NSInteger nTags = sizeof(fields)/sizeof(NSInteger);
    for (NSInteger i = 0; i < nTags; i++) {
        NSInteger tag = fields[i];
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        if (tag == Message) {
            t.hidden = (mode != MessageMode);
        } else {
            t.hidden = (mode == MessageMode);
            t.placeholder = @"";
        }
    }
    Field labels[] = { CostLabel, SavingsLabel, MoreLabel };
    nTags = sizeof(labels)/sizeof(NSInteger);
    for (NSInteger i = 0; i < nTags; i++) {
        NSInteger tag = labels[i];
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        t.hidden = (mode == MessageMode);
        t.placeholder = @"";
        NSInteger i = T2I(FTAG, tag);
        t.text = [NSString stringWithCString:deviceFields[deviceType][i].label encoding:NSASCIIStringEncoding];
    }
}

- (void)populateScreen {
    
    for (int i = 0; i < sizeof(fieldsIPhone35)/sizeof(labelStruct); i++) {
        [self makeField:deviceFields[deviceType][i] tag:I2T(FTAG, i)];
    }

    for (int i = 0; i < sizeof(keypadIPhone35)/sizeof(labelStruct); i++) {
        [self makeButton:deviceKeys[deviceType][i] tag:I2T(KTAG, i) isKey:YES];
    }
    
    [self setMessageMode:MessageMode];
}

#pragma mark -
#pragma mark Handle Input

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
#ifdef DEBUG
	NSLog(@"%s, %d", __func__, sender.tag);
#endif

    typedef enum {
        InputKey, ResultKey, NumberKey, ClearKey, StoreKey, DelKey, NextKey, UnknownKey
    } KeyType;
    KeyType keyType;
    
    keyType = UnknownKey;
    
    if (sender.tag >= FTAG && sender.tag <= Message) {
        switch (sender.tag) {
            case PriceA:
            case PriceB:
            case QtyA:
            case QtyB:
            case SizeA:
            case SizeB:
            case Qty2BuyA:
            case Qty2BuyB:
                keyType = InputKey;
                break;
            case BetterDealA:
            case BetterDealB:
            case Message:
                keyType = ResultKey;
                break;
            default:
                keyType = UnknownKey;
                break;
        }
    } else {
        switch (sender.tag) {
            case KTAG + 0:
            case KTAG + 1:
            case KTAG + 2:
            case KTAG + 4:
            case KTAG + 5:
            case KTAG + 6:
            case KTAG + 8:
            case KTAG + 9:
            case KTAG + 10:
            case KTAG + 12:
            case KTAG + 13:
                keyType = NumberKey;
                break;
            case KTAG + 3:
                keyType = ClearKey;
                break;
            case K_STORE:
                keyType = StoreKey;
                break;
            case KTAG + 11:
                keyType = DelKey;
                break;
            case KTAG + 14:
                keyType = NextKey;
                break;
            default:
                keyType = UnknownKey;
                break;
        }
    }
    
    NSInteger tag = InputFields[curFieldIndex];
    if (keyType == UnknownKey) {
#ifdef DEBUG
        NSLog(@"Ooops");
#endif
    } else if (keyType == InputKey) {
        MyButton *b = (MyButton *)[self.view viewWithTag:tag];
        [b setBackgroundColor:fieldColor];
        b = (MyButton *)[self.view viewWithTag:sender.tag];
        [b setBackgroundColor:curFieldColor];
        curFieldIndex = [self findIndex:sender.tag];
        tag = InputFields[curFieldIndex];
        directTap = YES;
        [self showResult];
    } else  if (keyType == ResultKey) {
        [self showResult];
    } else {
        if (directTap) {
            if (keyType != NextKey) {
                fieldValues[T2I(FTAG, tag)] = @"";
            } else {
#ifdef DEBUG
                NSLog(@"%s, this shouldnt happen", __func__);
#endif
            }
            directTap = NO;
        }
        NSString *s = fieldValues[T2I(FTAG, tag)];
        NSString *key = [self getKey:sender];
        if (keyType == DelKey) {
            if (s.length > 0) {
                s = [s substringToIndex:s.length - 1];
                fieldValues[T2I(FTAG, tag)] = s;
                if (tag == Qty2BuyA) {
                    fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
                } else if (tag == Qty2BuyB) {
                    fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
                }
                [self showResult];
            } else {
                [self showResult];
            }
        } else if (keyType == ClearKey) {
            [self initGUI];
        } else if (keyType == NextKey) {
            curFieldIndex = (curFieldIndex + 1) % nInputFields;
            tag = InputFields[curFieldIndex];
            [self showResult];
        } else if ([key isEqualToString:@STORE]) {
            if (!myStoreObserver.bought || debug) {
                if (debug) {
                    testToRun = AisBetter;
                    [self initGUI];
                    [self showResult];
                }
                if ([SKPaymentQueue canMakePayments]) {
                    [self removeAds];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"Use Settings to enable payments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        } else if ([key isEqualToString:@"."]) {
            NSRange r = [s rangeOfString:@"."];
            if (r.location == NSNotFound) {
                fieldValues[T2I(FTAG, tag)] = [s stringByAppendingString:key];
                if (tag == Qty2BuyA) {
                    fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
                } else if (tag == Qty2BuyB) {
                    fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
                }
                [self showResult];
            }
        } else {
            if ((tag == PriceA || tag == PriceB) && s.length == 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                s = [numberFormatter currencySymbol];
                fieldValues[T2I(FTAG, tag)] = [s stringByAppendingString:key];
            } else {
                fieldValues[T2I(FTAG, tag)] = [s stringByAppendingString:key];
            }
            if (tag == Qty2BuyA) {
                fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
            } else if (tag == Qty2BuyB) {
                fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
            }
            [self showResult];
        }
        [self updateFields:NO];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self performSelector:@selector(buttonPushed:) withObject:textField afterDelay:0.125];
    return NO;
}

- (void)showResult {
    if ([fieldValues[T2I(FTAG, Qty2BuyA)] length] == 0 && [fieldValues[T2I(FTAG, Qty2BuyB)] length] > 0) {
        fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
    } else if ([fieldValues[T2I(FTAG, Qty2BuyA)] length] > 0 && [fieldValues[T2I(FTAG, Qty2BuyB)] length] == 0) {
        fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
    } else if ([fieldValues[T2I(FTAG, PriceA)] length] > 0 &&  [fieldValues[T2I(FTAG, QtyA)] length] > 0) {
        if ([fieldValues[T2I(FTAG, SizeA)] length] == 0) {
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            directTap = YES;
        }
    } else if ([fieldValues[T2I(FTAG, PriceB)] length] > 0 &&  [fieldValues[T2I(FTAG, QtyB)] length] > 0) {
        if ([fieldValues[T2I(FTAG, SizeB)] length] == 0) {
            directTap = YES;
            fieldValues[T2I(FTAG, SizeB)] = @"1";
        }
    } else {
        // no calcs to perform.
        [self updateFields:NO];
        return;
    }
    [self calcResult];
    [self updateFields:NO];
}

- (void)setResult:(NewSavings *)savings {
    [self setMessageMode:ResultsMode];
    fieldValues[T2I(FTAG, CostField)] = [self fmtPrice:savings.totalCost];
    if (savings.savings == 0.0) {
        fieldValues[T2I(FTAG, SavingsField)] = @"Same Price";
    } else {
        fieldValues[T2I(FTAG, SavingsField)] = [self fmtPrice:savings.savings];
    }
    float percentDiff = [savings.cheaperItem isEqual:savings.itemA] ? savings.percentMoreProductA : savings.percentMoreProductB;
    if (percentDiff < 0.0) {
        fieldValues[T2I(FTAG, MoreField)] = [NSString stringWithFormat:@"%.0f%%", percentDiff * -100.0];
        fieldValues[T2I(FTAG, MoreLabel)] = @"Less Product";
    } else if (percentDiff > 0.0) {
        fieldValues[T2I(FTAG, MoreField)] = [NSString stringWithFormat:@"%.0f%%", percentDiff * 100.0];
        fieldValues[T2I(FTAG, MoreLabel)] = @"More Product";
    } else {
        fieldValues[T2I(FTAG, MoreField)] = @"Same Amt";
        fieldValues[T2I(FTAG, MoreLabel)] = @"of Product";
    }
    if (savings.itemA.pricePerUnit < savings.itemB.pricePerUnit) {
        [self highLight:ItemA];
    } else if(savings.itemA.pricePerUnit < savings.itemB.pricePerUnit) {
        [self highLight:ItemB];
    } else {
        // same price, use betterPricePerUnit
        if ([savings.betterPricePerUnit isEqual:savings.itemA]) {
            [self highLight:ItemA];
        } else {
            [self highLight:ItemB];
        }
    }
}

- (void)calcResult {
    NSString *a = fieldValues[T2I(FTAG, PriceA)];
    if (a.length > 0) a = [a substringFromIndex:1];
    NSString *b = fieldValues[T2I(FTAG, PriceB)];
    if (b.length > 0) b = [b substringFromIndex:1];
    float priceA = [a floatValue];
    float minQtyA = [fieldValues[T2I(FTAG, QtyA)] floatValue];
    float unitsPerItemA = [fieldValues[T2I(FTAG, SizeA)] floatValue];
    float priceB = [b floatValue];
    float minQtyB = [fieldValues[T2I(FTAG, QtyB)] floatValue];
    float unitsPerItemB = [fieldValues[T2I(FTAG, SizeB)] floatValue];
    Item *itemA = [Item theItemWithName:@"A" price:priceA minQty:minQtyA unitsPerItem:unitsPerItemA];
    Item *itemB = [Item theItemWithName:@"B" price:priceB minQty:minQtyB unitsPerItem:unitsPerItemB];
    NewSavings *savings = [NewSavings theNewSavingsWithItemA:itemA withItemB:itemB];
    NSString *q2buyA = fieldValues[T2I(FTAG, Qty2BuyA)];
    NSString *q2buyB = fieldValues[T2I(FTAG, Qty2BuyB)];
    if (q2buyA.length > 0 && [q2buyA isEqualToString:q2buyB]) {
        // this causes the final calculation to run
        savings.qty2Purchase = [q2buyA floatValue];
#ifdef DEBUG
        @try {
            NSLog(@"%@", savings.calcStateString);
        } @catch (NSException *e) {
            // ignore it.
        }
#endif
    } else {
#ifdef DEBUG
        NSLog(@"%s, this shouldnt happen", __func__);
#endif
    }
    
    if (savings.calcState == CalcComplete || savings.calcState == NeedQty2Purchase) {
        fieldValues[T2I(FTAG, BetterDealA)] = [NSString stringWithFormat:@"%.2f/item, %.2f/unit", savings.itemA.pricePerItem, savings.itemA.pricePerUnit];
        fieldValues[T2I(FTAG, BetterDealB)] = [NSString stringWithFormat:@"%.2f/item, %.2f/unit", savings.itemB.pricePerItem, savings.itemB.pricePerUnit];
    }
    
    [self clrHighLight];
    // highlight based on unit cost, deal based on price, this is setting unit cost
    if (savings.calcState == CalcComplete) {
        // same price, same unit cost
        if (savings.savings == 0.0) {
            fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
            fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
        } else if ([savings.cheaperItem.name isEqualToString:@"A"]) {
            fieldValues[T2I(FTAG, ItemA)] = [NSString stringWithFormat:@"A is %.0f%% Cheaper", savings.percentSavings*100];
            fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
        } else if ([savings.cheaperItem.name isEqualToString:@"B"]) {
            fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
            fieldValues[T2I(FTAG, ItemB)] = [NSString stringWithFormat:@"B is %.0f%% Cheaper", savings.percentSavings*100];
        } else {
#ifdef DEBUG
            NSLog(@"%s, This should not happen", __func__);
#endif
            fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
            fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
        }
        [self setResult:savings];
    } else if (savings.calcState == NeedQty2Purchase) {
        [self setMessageMode:MessageMode];
        fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)] = @"";
#ifdef REQUIRE_MULTIPLE
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithFormat:@"Enter a Multiple of %.0f for # to Buy", savings.normalizedMinQty];
#else
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithFormat:@"Enter # to Buy"];
#endif
    } else {
        [self setMessageMode:MessageMode];
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithCString:deviceFields[deviceType][T2I(FTAG, Message)].label encoding:NSASCIIStringEncoding];
    }
}

#pragma mark -
#pragma mark DataStore

- (void)fillBlank:(Field)f v:(float *)v d:(float)d {
    if ([fieldValues[T2I(FTAG, f)] length] == 0) {
        *v = d;
        fieldValues[T2I(FTAG, f)] = [NSString stringWithFormat:@"%.2f", *v];
    }
}

#pragma mark -
#pragma mark Ads

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![[alertView title] isEqualToString:@"Payments Disabled"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
#ifdef DEBUG
            NSLog(@"Buy it here");
#endif
            //            self.bought = YES;
            [self doPayment];
        } else {
            if (debug) {
                myStoreObserver.bought = NO;
                [self setAdButtonState];
            } else {
#ifdef DEBUG
                NSLog(@"Dont do anything");
#endif
            }
        }
        //        [self setAdButtonState];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)setAdButtonState {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    ADBannerView *a = (ADBannerView *)[self.view viewWithTag:Ad];
    MyButton *b = (MyButton *)[self.view viewWithTag:(K_STORE)];
    [a setHidden:myStoreObserver.bought];
    BTITLE(b, myStoreObserver.bought ? @THANKS : @STORE);
}

#pragma mark -
#pragma mark Banner Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [banner setHidden:myStoreObserver.bought];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [banner setHidden:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
}

#pragma mark -
#pragma mark Store

- (void)doPayment {
    if (myStoreObserver.myProducts.count > 0) {
        SKProduct *selectedProduct = myStoreObserver.myProducts[0];
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
#ifdef DEBUG
        NSLog(@"no products found");
#endif
    }
}

- (void)processCompleted {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self setAdButtonState];
}

- (void)removeAds {
    NSString *s = [NSString stringWithFormat:@"Do you wish to remove Ads for %@?", [NSNumberFormatter localizedStringFromNumber:((SKProduct *)[MyStoreObserver myStoreObserver].myProducts[0]).price numberStyle:NSNumberFormatterCurrencyStyle]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@STORE message:s delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark -
#pragma mark Utilities

- (NSInteger)findIndex:(NSInteger)tag {
    for(NSInteger i = 0; i < nInputFields; i++) {
        if (InputFields[i] == tag) {
            return i;
        }
    }
#ifdef DEBUG
    NSLog(@"Punt");
#endif
    return 0; // punt
}

- (void)makeButton:(labelStruct)label tag:(NSInteger)tag isKey:(BOOL)isKey {
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
        [b setBackgroundImage:[UIImage imageNamed:@"ButtonGradient3.png"] forState:UIControlStateSelected];
        BTITLE(b, [NSString stringWithCString:label.label encoding:NSASCIIStringEncoding]);
    }
    [b setBackgroundColor:(tag == InputFields[curFieldIndex]) ? fieldColor : curFieldColor];
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

- (void)makeField:(labelStruct)label tag:(NSInteger)tag {
    UITextField *t = [[UITextField alloc] initWithFrame:label.rect];
    t.font = [UIFont systemFontOfSize:label.f];
    t.textAlignment = NSTextAlignmentCenter;
    t.tag = tag;
    if (tag >= CostLabel && tag <= MoreLabel) {
        t.backgroundColor = [UIColor clearColor];
    } else {
        t.backgroundColor = (tag == InputFields[curFieldIndex]) ? fieldColor : curFieldColor;
    }
    t.borderStyle = (tag == InputFields[curFieldIndex]) ? UITextBorderStyleLine : UITextBorderStyleNone;
    t.delegate = self;
    if (tag == ItemA || tag == ItemB || tag == BetterDealA || tag == BetterDealB || tag == Message) {
        t.placeholder = @"";
        t.text = [NSString stringWithCString:label.label encoding:NSASCIIStringEncoding];
        t.contentVerticalAlignment = (tag == ItemA || tag == ItemB) ? UIControlContentVerticalAlignmentTop :UIControlContentVerticalAlignmentCenter;
        t.backgroundColor = [UIColor clearColor];
        t.borderStyle = UITextBorderStyleNone;
        if (tag == ItemA || tag == ItemB) {
            t.borderStyle = UITextBorderStyleLine;
        } else if (tag == BetterDealA || tag == BetterDealB) {
        } else {
            // this does not appear to work
            t.minimumFontSize = 6;
            t.adjustsFontSizeToFitWidth = YES;
        }
    } else {
        t.text = @"";
        t.placeholder = [NSString stringWithCString:label.label encoding:NSASCIIStringEncoding];
        t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    [self.view addSubview:t];
}

- (NSString *)fmtPrice:(float)price {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *c = [numberFormatter currencySymbol];
    return [NSString stringWithFormat:@"%@%.2f", c, price];
}
@end
