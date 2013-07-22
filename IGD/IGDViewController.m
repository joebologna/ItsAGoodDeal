//
//  IGDViewController.m
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "IGDViewController.h"
#import "MyButton.h"
#import "MyStoreObserver.h"
#import "Savings.h"

#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>

#pragma mark -
#pragma mark Convenience Macros

#pragma mark -
#pragma mark Tags and Fields Tables

#pragma mark -
#pragma mark Debug Variables

typedef enum { AisBigger, AisBetter, BisBetter, Same, NotTesting } Test;

#if DEBUG==1
static BOOL debug = YES;
//static Test testToRun = AisBigger;

#ifdef DEBUG_LAYOUT
static int pushed = 0;
#endif

#else
static BOOL debug = NO;
static Test testToRun = NotTesting;
#endif

#pragma mark -
#pragma mark Instance Properties

@interface IGDViewController () <ADBannerViewDelegate, UIAlertViewDelegate> {
    MyStoreObserver *myStoreObserver;
}

@end

#pragma mark -
#pragma mark View Delegate

@implementation IGDViewController

- (void)viewDidLoad {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [super viewDidLoad];

    ADBannerView *adView = (ADBannerView *)[self.view viewWithTag:Ad];
    adView.delegate = self;
    
    //self.view.backgroundColor = UIColorFromRGB(0x53e99e);
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.fields = [[Fields alloc] init];
    [self.fields makeFields:(UIViewController *)self];
    [self.fields populateScreen];
    [self initGUI];
    
    myStoreObserver = [MyStoreObserver myStoreObserver];
    myStoreObserver.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Handle Screen

- (void)initGUI {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self setAdButtonState];
}

#pragma mark -
#pragma mark Handle Input

- (void)buttonPushed:(MyButton *)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#ifdef DEBUG_LAYOUT
    if (pushed == 0) self.fields.message.control.hidden = YES;
    else if(pushed == 1) self.fields.costField.control.hidden = YES;
    else if(pushed == 2) self.fields.costLabel.control.hidden = YES;
    else if(pushed == 3) self.fields.savingsField.control.hidden = YES;
    else if(pushed == 4) self.fields.savingsLabel.control.hidden = YES;
    else if(pushed == 5) self.fields.moreField.control.hidden = YES;
    else if(pushed == 6) self.fields.moreLabel.control.hidden = YES;
    else if(pushed == 7) self.fields.message.control.hidden = NO;
    else if(pushed == 8) self.fields.costField.control.hidden = NO;
    else if(pushed == 9) self.fields.costLabel.control.hidden = NO;
    else if(pushed == 10) self.fields.savingsField.control.hidden = NO;
    else if(pushed == 11) self.fields.savingsLabel.control.hidden = NO;
    else if(pushed == 12) self.fields.moreField.control.hidden = NO;
    else if(pushed == 13) self.fields.moreLabel.control.hidden = NO;
    else { pushed = 0; return; }
    pushed++;
    self.fields.messageMode = (self.fields.messageMode == ShowPrompt) ? ShowResult : ShowPrompt;
#endif
#endif
    if (sender.tag == Next) {
        [self.fields gotoNextField];
    } else if (sender.tag <= Period) {
        NSString *s = self.fields.curField.value;
        if (sender.tag == Period) {
            NSRange r = [s rangeOfString:@"."];
            if (r.location == NSNotFound) {
                self.fields.curField.value = [s stringByAppendingString:sender.titleLabel.text];
            }
#ifdef DEBUG
            else {
                NSLog(@"%s, skipping 2nd '.'", __func__);
            }
#endif
        } else {
            self.fields.curField.value = [s stringByAppendingString:sender.titleLabel.text];
        }
    } else if (sender.tag == Clr) {
        self.fields.curField.value = @"";
    } else if (sender.tag == Del) {
        NSString *s = self.fields.curField.value;
        if (s.length > 0) {
            self.fields.curField.value = [s substringToIndex:s.length - 1];
        }
    } else if (sender.tag == Store) {
        if (!myStoreObserver.bought) {
            if ([SKPaymentQueue canMakePayments]) {
                [self removeAds];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"Use Settings to enable payments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
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
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
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
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    NSString *s = [NSString stringWithFormat:@"Do you wish to remove Ads for %@?", [NSNumberFormatter localizedStringFromNumber:((SKProduct *)[MyStoreObserver myStoreObserver].myProducts[0]).price numberStyle:NSNumberFormatterCurrencyStyle]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@STORE message:s delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark -
#pragma mark Utilities

- (NSString *)fmtPrice:(float)price {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *c = [numberFormatter currencySymbol];
    return [NSString stringWithFormat:@"%@%.2f", c, price];
}
@end
