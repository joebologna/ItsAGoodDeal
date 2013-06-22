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
#import "Savings.h"

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
    LABEL(212, YO11(206), 106, 10, 9, "More Product")
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
    LABEL(1, YO11(21), 383, 322, 14, "Deal A"),
    LABEL(385, YO11(21), 383, 322, 14, "Deal B"),
    LABEL(10, YO11(312), 384, 30, 10, ""),
    LABEL(384, YO11(312), 384, 30, 10, ""),
    // A
    LABEL(10, YO11(40), 366, 86, 48, "Price A"),
    LABEL(10, YO11(133), 177, 86, 48, "MinQty"), LABEL(199, YO11(133), 177, 86, 48, "Size"),
    LABEL(105, YO11(227), 177, 86, 48, "# to Buy"),
    // B
    LABEL(393, YO11(40), 366, 86, 48, "Price B"),
    LABEL(393, YO11(133), 177, 86, 48, "MinQty"), LABEL(582, YO11(133), 177, 86, 48, "Size"),
    LABEL(488, YO11(227), 177, 86, 48, "# to Buy"),
    // Savings & Messages
    LABEL(1, YO11(344), 766, 75, 30, "Enter Price, Min Qty & Size of Items"),
    LABEL(1, YO11(343), 256, 67, 30, "Cost Field"),
    LABEL(256, YO11(343), 257, 67, 30, "Savings Field"),
    LABEL(512, YO11(343), 255, 67, 30, "More Field"),
    LABEL(1, YO11(400), 256, 20, 12, "Cost"),
    LABEL(256, YO11(400), 257, 20, 12, "Savings"),
    LABEL(512, YO11(400), 255, 20, 12, "More")
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
    LABEL(20, YO23(430), 176, 128, 48, "1"),
    LABEL(204, YO23(430), 176, 128, 48, "2"),
    LABEL(388, YO23(430), 176, 128, 48, "3"),
    LABEL(572, YO23(430), 176, 128, 48, CLR),
    LABEL(20, YO23(565), 176, 128, 48, "4"),
    LABEL(204, YO23(565), 176, 128, 48, "5"),
    LABEL(388, YO23(565), 176, 128, 48, "6"),
    LABEL(572, YO23(565), 176, 128, 36, STORE),
    LABEL(20, YO23(700), 176, 128, 48, "7"),
    LABEL(204, YO23(700), 176, 128, 48, "8"),
    LABEL(388, YO23(700), 176, 128, 48, "9"),
    LABEL(572, YO23(700), 176, 128, 48, DEL),
    LABEL(20, YO23(835), 176, 128, 48, "."),
    LABEL(204, YO23(835), 176, 128, 48, "0"),
    LABEL(388, YO23(835), 360, 128, 48, NEXT)
};

static labelStruct *deviceKeys[] = {
    keypadIPhone35, keypadIPhone40, keypadIPad
};

typedef enum { AisBigger, AisBetter, BisBetter, Same, NotTesting } Test;

#if DEBUG==1
static BOOL debug = YES;
static Test testToRun = AisBigger;
#else
static BOOL debug = NO;
static Test testToRun = NotTesting;
#endif

@interface ViewController () <ADBannerViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *fieldValues;
    UIColor *fieldColor, *curFieldColor, *backgroundColor, *highlightColor;
    DeviceType deviceType;
    NSInteger curFieldIndex;
    BOOL directTap;
    MyStoreObserver *myStoreObserver;
}

@end

@implementation ViewController

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

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
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

- (void)initGUI {
    directTap = NO;
    fieldValues = [NSMutableArray array];
    for (int i = ItemA; i <= MoreLabel; i++) {
        [fieldValues addObject:@""];
    }
    curFieldIndex = 0;
    [self setMessageMode:MessageMode];
    [self updateFields:YES];
    
    switch (testToRun) {
        case AisBigger:
            /*
            fieldValues[T2I(FTAG, PriceA)] = @"999";
            fieldValues[T2I(FTAG, PriceB)] = @"1";
            fieldValues[T2I(FTAG, QtyA)] = @"2";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            fieldValues[T2I(FTAG, SizeB)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"2";
             */
            /*
            fieldValues[T2I(FTAG, PriceA)] = @"1";
            fieldValues[T2I(FTAG, PriceB)] = @"9";
            fieldValues[T2I(FTAG, QtyA)] = @"3";
            fieldValues[T2I(FTAG, QtyB)] = @"9";
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            fieldValues[T2I(FTAG, SizeB)] = @"9";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"9";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"9";
             */
            /*
            fieldValues[T2I(FTAG, PriceA)] = @"3";
            fieldValues[T2I(FTAG, PriceB)] = @"2";
            fieldValues[T2I(FTAG, QtyA)] = @"2";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"7.5";
            fieldValues[T2I(FTAG, SizeB)] = @"8.5";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"3";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"3";
             */

            fieldValues[T2I(FTAG, PriceA)] = @"17";
            fieldValues[T2I(FTAG, PriceB)] = @"11";
            fieldValues[T2I(FTAG, QtyA)] = @"1";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"100";
            fieldValues[T2I(FTAG, SizeB)] = @"50";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"1";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"1";
            
            testToRun = AisBetter;
            break;
        case AisBetter:
            fieldValues[T2I(FTAG, PriceA)] = @"1";
            fieldValues[T2I(FTAG, PriceB)] = @"1";
            fieldValues[T2I(FTAG, QtyA)] = @"2";
            fieldValues[T2I(FTAG, QtyB)] = @"1";
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            fieldValues[T2I(FTAG, SizeB)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"2";
            testToRun = BisBetter;
            break;
        case BisBetter:
            fieldValues[T2I(FTAG, PriceA)] = @"1.99";
            fieldValues[T2I(FTAG, PriceB)] = @"2.99";
            fieldValues[T2I(FTAG, QtyA)] = @"1";
            fieldValues[T2I(FTAG, QtyB)] = @"2";
            fieldValues[T2I(FTAG, SizeA)] = @"8.5";
            fieldValues[T2I(FTAG, SizeB)] = @"7.5";
            fieldValues[T2I(FTAG, Qty2BuyA)] = @"2";
            fieldValues[T2I(FTAG, Qty2BuyB)] = @"2";
            testToRun = Same;
            break;
        case Same:
            fieldValues[T2I(FTAG, PriceA)] = @"2";
            fieldValues[T2I(FTAG, PriceB)] = @"1";
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
        //NSInteger i = T2I(FTAG, tag);
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        //fieldValues[T2I(FTAG, tag)] = [NSString stringWithCString:deviceFields[deviceType][i].label encoding:NSASCIIStringEncoding];
        if (tag == ItemA && [fieldValues[T2I(FTAG, tag)] length] > 6) { // fix this later
            t.backgroundColor = highlightColor;
        } else if (tag == ItemB && [fieldValues[T2I(FTAG, tag)] length] > 6) { // fix this later
            t.backgroundColor = highlightColor;
        }
    }
}

- (void)updateFields:(BOOL)useDefaultValues {
    for (int tag = ItemA; tag <= MoreField; tag++) {
        NSInteger i = T2I(FTAG, tag);
        UITextField *t = (UITextField *)[self.view viewWithTag:tag];
        if (tag ==  ItemA || tag == ItemB || tag == Message) {
            t.borderStyle = UITextBorderStyleLine;
            if ((tag == ItemA || tag == ItemB) && [fieldValues[i] length] > 6) { // fix this later
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
                [self calcResult];
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
            }
        } else {
            fieldValues[T2I(FTAG, tag)] = [s stringByAppendingString:key];
            if (tag == Qty2BuyA) {
                fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
            } else if (tag == Qty2BuyB) {
                fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
            }
        }
        [self updateFields:NO];
    }
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self performSelector:@selector(buttonPushed:) withObject:textField afterDelay:0.125];
    return NO;
}

- (void)fillBlank:(Field)f v:(float *)v d:(float)d {
    if ([fieldValues[T2I(FTAG, f)] length] == 0) {
        *v = d;
        fieldValues[T2I(FTAG, f)] = [NSString stringWithFormat:@"%.2f", *v];
    }
}

- (void)showResult {
    if ([fieldValues[T2I(FTAG, Qty2BuyA)] length] == 0 && [fieldValues[T2I(FTAG, Qty2BuyB)] length] > 0) {
        fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)];
        [self calcResult];
    } else if ([fieldValues[T2I(FTAG, Qty2BuyA)] length] > 0 && [fieldValues[T2I(FTAG, Qty2BuyB)] length] == 0) {
        fieldValues[T2I(FTAG, Qty2BuyB)] = fieldValues[T2I(FTAG, Qty2BuyA)];
        [self calcResult];
    } else if ([fieldValues[T2I(FTAG, PriceA)] length] > 0 &&  [fieldValues[T2I(FTAG, QtyA)] length] > 0) {
        if ([fieldValues[T2I(FTAG, SizeA)] length] == 0) {
            fieldValues[T2I(FTAG, SizeA)] = @"1";
            directTap = YES;
        }
        [self calcResult];
    } else if ([fieldValues[T2I(FTAG, PriceB)] length] > 0 &&  [fieldValues[T2I(FTAG, QtyB)] length] > 0) {
        if ([fieldValues[T2I(FTAG, SizeB)] length] == 0) {
            directTap = YES;
            fieldValues[T2I(FTAG, SizeB)] = @"1";
        }
        [self calcResult];
    } else {
        // no calcs to perform.
    }
    [self updateFields:NO];
}

- (void)setResult:(Savings *)savings {
    [self setMessageMode:ResultsMode];
    SavingsResults *results = [savings getResults];
    fieldValues[T2I(FTAG, CostField)] = results.cost;
    fieldValues[T2I(FTAG, SavingsField)] = (results.savings <= 0) ? @"A=B" : [results objectForKey:kSavings];
    fieldValues[T2I(FTAG, MoreField)] = @"FIX THIS";
}

- (void)calcResult {
    CalcResult r;
    float priceA = [fieldValues[T2I(FTAG, PriceA)] floatValue];
    float minQtyA = [fieldValues[T2I(FTAG, QtyA)] floatValue];
    float unitsPerItemA = [fieldValues[T2I(FTAG, SizeA)] floatValue];
    float qty2PurchaseA = [fieldValues[T2I(FTAG, Qty2BuyA)] floatValue];
    float priceB = [fieldValues[T2I(FTAG, PriceB)] floatValue];
    float minQtyB = [fieldValues[T2I(FTAG, QtyB)] floatValue];
    float unitsPerItemB = [fieldValues[T2I(FTAG, SizeB)] floatValue];
    float qty2PurchaseB = [fieldValues[T2I(FTAG, Qty2BuyB)] floatValue];
    Item *itemA = [Item theItemWithName:@"A" price:priceA qty:minQtyA unitsPerItem:unitsPerItemA];
    Item *itemB = [Item theItemWithName:@"B" price:priceB qty:minQtyB unitsPerItem:unitsPerItemB];
    Savings *savings = [Savings theSavingsWithItemA:itemA itemB:itemB];
    
    r = [savings calcSavings];
    if (r == CalcComplete) {
        fieldValues[T2I(FTAG, BetterDealA)] = [NSString stringWithFormat:@"%.2f/item, %.2f/unit", savings.itemA.pricePerItem, savings.itemA.pricePerUnit];
        fieldValues[T2I(FTAG, BetterDealB)] = [NSString stringWithFormat:@"%.2f/item, %.2f/unit", savings.itemB.pricePerItem, savings.itemB.pricePerUnit];
        if (savings.sizeDiff == 0 && savings.moneySaved == 0 && savings.percentMoreProduct == 0) {
            fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
            fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
            [self clrHighLight];
        } else if (savings.percentMoreProduct > 0) {
            Item *best = savings.getBest;
            if ([best.name isEqual:@"A"]) {
                fieldValues[T2I(FTAG, ItemA)] = @"A is a Better Deal";
                [self highLight:ItemB];
                fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
            } else {
                [self highLight:ItemB];
                fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
                fieldValues[T2I(FTAG, ItemB)] = @"B is a Better Deal";
            }
        } else if ([savings.getBest.name isEqualToString:@"A"]) {
            fieldValues[T2I(FTAG, ItemA)] = @"A is a Better Deal";
            fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
            [self clrHighLight];
            [self highLight:ItemA];
        } else if ([savings.getBest.name isEqualToString:@"B"]) {
            fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
            fieldValues[T2I(FTAG, ItemB)] = @"B is a Better Deal";
            [self clrHighLight];
            [self highLight:ItemB];
        }
        [self setResult:savings];
    } else if (r == NeedQty2Buy) {
        [self clrHighLight];
        fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)] = @"";
        float minQty = MAX(savings.itemA.minQty, savings.itemB.minQty);
        [self setMessageMode:MessageMode];
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithFormat:@"Enter at least %.2f for Qty to Buy", minQty];
    } else if (r == NeedValidQty2Buy) {
        [self clrHighLight];
        fieldValues[T2I(FTAG, Qty2BuyA)] = fieldValues[T2I(FTAG, Qty2BuyB)] = @"";
        [self setMessageMode:MessageMode];
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithFormat:@"Enter a multiple of %.2f for Qty to Buy", savings.itemA.minQty];
    } else {
        [self clrHighLight];
        [self setMessageMode:MessageMode];
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithCString:deviceFields[deviceType][T2I(FTAG, Message)].label encoding:NSASCIIStringEncoding];
    }
}

- (void)oldCalcResult {
    float priceA = [fieldValues[T2I(FTAG, PriceA)] floatValue];
    float minQtyA = [fieldValues[T2I(FTAG, QtyA)] floatValue];
    float unitsPerItemA = [fieldValues[T2I(FTAG, SizeA)] floatValue];
    float eachA = 0.0;
    float pricePerUnitA = 0.0;
    if (minQtyA > 0 && unitsPerItemA > 0) {
        eachA = priceA / minQtyA;
        pricePerUnitA = eachA / unitsPerItemA;
        fieldValues[T2I(FTAG, BetterDealA)] = [NSString stringWithFormat:@"%.2f/purch, %.2f/unit", priceA, pricePerUnitA];
    }

    float priceB = [fieldValues[T2I(FTAG, PriceB)] floatValue];
    float minQtyB = [fieldValues[T2I(FTAG, QtyB)] floatValue];
    float unitsPerItemB = [fieldValues[T2I(FTAG, SizeB)] floatValue];
    float eachB = 0.0;
    float pricePerUnitB = 0.0;
    if (minQtyB > 0 && unitsPerItemB > 0) {
        eachB = priceB / minQtyB;
        pricePerUnitB = eachB / unitsPerItemB;
        fieldValues[T2I(FTAG, BetterDealB)] = [NSString stringWithFormat:@"%.2f/purch, %.2f/unit", priceB, pricePerUnitB];
    }

    fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
    fieldValues[T2I(FTAG, ItemB)] = @"Deal B";

    if (pricePerUnitA > 0 && pricePerUnitB > 0) {
        if (pricePerUnitA < pricePerUnitB) {
            fieldValues[T2I(FTAG, ItemA)] = @"A is a Better Deal";
        } else if (pricePerUnitB < pricePerUnitA) {
            fieldValues[T2I(FTAG, ItemB)] = @"B is a Better Deal";
        }
    }
    
    float qty2PurchaseA = [fieldValues[T2I(FTAG, Qty2BuyA)] floatValue];
    float qty2PurchaseB = [fieldValues[T2I(FTAG, Qty2BuyB)] floatValue];
    
    if (minQtyA > 0 && minQtyB > 0 && unitsPerItemA > 0 && unitsPerItemB > 0) {
        if (qty2PurchaseA > 0 && qty2PurchaseB > 0) {
            NSString *msg;
            float minPurchCostA = eachA * qty2PurchaseA;
            float minPurchCostB = eachB * qty2PurchaseB;
            float unitsPurchA = unitsPerItemA * qty2PurchaseA;
            float unitsPurchB = unitsPerItemB * qty2PurchaseB;
            float percentOfMaxA = unitsPurchA / MAX(unitsPurchA, unitsPurchB);
            float percentOfMaxB = unitsPurchB / MAX(unitsPurchA, unitsPurchB);
            fieldValues[T2I(FTAG, BetterDealA)] = [NSString stringWithFormat:@"%.2f/purch, %.2f/unit, %.1funits", priceA, pricePerUnitA, unitsPurchA];
            fieldValues[T2I(FTAG, BetterDealB)] = [NSString stringWithFormat:@"%.2f/purch, %.2f/unit, %.1funits", priceB, pricePerUnitB, unitsPurchB];
#ifdef DEBUG
            NSLog(@"%s, %d", __func__, [fieldValues[T2I(FTAG, BetterDealA)] length]);
#endif
            if ([fieldValues[T2I(FTAG, BetterDealA)] length] < 34) {
                NSInteger tags[] = {BetterDealA, BetterDealB};
                NSInteger nTags = sizeof(tags)/sizeof(NSInteger);
                for (NSInteger i = 0; i < nTags; i++) {
                    NSInteger tag = tags[i];
                    NSInteger j = T2I(FTAG, tag);
                    UITextField *t = (UITextField *)[self.view viewWithTag:tag];
                    float x = deviceFields[deviceType][j].f * 1.2;
                    t.font = [UIFont systemFontOfSize:x];
                }
            } else {
                NSInteger tags[] = {BetterDealA, BetterDealB};
                NSInteger nTags = sizeof(tags)/sizeof(NSInteger);
                for (NSInteger i = 0; i < nTags; i++) {
                    NSInteger tag = tags[i];
                    NSInteger j = T2I(FTAG, tag);
                    UITextField *t = (UITextField *)[self.view viewWithTag:tag];
                    float x = deviceFields[deviceType][j].f * 1.0;
                    t.font = [UIFont systemFontOfSize:x];
                }
            }
            if (unitsPurchA < unitsPurchB) {
                float realSavings = (minPurchCostB - minPurchCostA) * percentOfMaxA;
                msg = [NSString stringWithFormat:@"Cost %.2f, Save %.2f, %.0f%% More Units", minPurchCostA, realSavings, percentOfMaxA*100];
                fieldValues[T2I(FTAG, ItemA)] = @"A is a Better Deal";
                fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
                [self clrHighLight];
                [self highLight:ItemA];
            } else if (unitsPurchB < unitsPurchA) {
                float realSavings = (minPurchCostA - minPurchCostB) * percentOfMaxB;
                msg = [NSString stringWithFormat:@"Cost %.2f, Save %.2f, %.0f%% More Units", minPurchCostB, realSavings, percentOfMaxB*100];
                fieldValues[T2I(FTAG, ItemB)] = @"B is a Better Deal";
                fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
                [self clrHighLight];
                [self highLight:ItemA];
            } else {
                msg = [NSString stringWithFormat:@"Cost: %.2f, A and B cost the same", minPurchCostA];
                fieldValues[T2I(FTAG, ItemA)] = @"Deal A";
                fieldValues[T2I(FTAG, ItemB)] = @"Deal B";
                [self clrHighLight];
            }
            fieldValues[T2I(FTAG, Message)] = msg;
        } else {
            fieldValues[T2I(FTAG, Message)] = @"Enter # to Buy to Calculate Savings";
            [self clrHighLight];
        }
    } else {
        // prompt for more data
        fieldValues[T2I(FTAG, Message)] = [NSString stringWithCString:deviceFields[deviceType][T2I(FTAG, Message)].label encoding:NSASCIIStringEncoding];
        [self clrHighLight];
    }
}

- (void)removeAds {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@STORE message:@"Do you wish to remove Ads for $0.99" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

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

- (void)setAdButtonState {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    ADBannerView *a = (ADBannerView *)[self.view viewWithTag:Ad];
    MyButton *b = (MyButton *)[self.view viewWithTag:(K_STORE)];
    [a setHidden:myStoreObserver.bought];
    BTITLE(b, myStoreObserver.bought ? @THANKS : @STORE);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processCompleted {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self setAdButtonState];
}

@end
