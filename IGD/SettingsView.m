//
//  SettingsView.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/5/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Globals.h"
#import "Field.h"
#import "SettingsView.h"
#import "MyButton.h"
#import "MyStoreObserver.h"
#import "NSObject+Utils.h"
#import <QuartzCore/QuartzCore.h>


@interface SettingsView () {
    MyStoreObserver *myStoreObserver;
    MyButton *ra;
    MyButton *r;
    MyButton *b;
    UITextView *msg;
}

@end

@implementation SettingsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myStoreObserver = [MyStoreObserver myStoreObserver];
    }
    return self;
}

#define SLOT(n) ((height / slots * n) - (fontSize))

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = HIGHLIGHTCOLOR;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    float radius = 6;
    float fontSize = [UIFont systemFontSize];
    float bheight = fontSize * 2;
    float toffset = 0;
    float ioffset = bheight * 1;
    if (self.getDeviceType == iPhone5) {
        fontSize *= 1.10;
        bheight = fontSize * 2;
    }
    float bwidth = width - 2 * bheight;
    float tfontSize = fontSize * 0.8;
    float slots = 10;
    float theight = SLOT(6);
    float lheight = bheight * 0.75;
    if (self.getDeviceType == iPhone5) {
        lheight = bheight * 0.8;
    } else if (self.getDeviceType == iPad) {
    }
    if (self.getDeviceType == iPad) {
        radius *= 4;
        fontSize *= 4;
        bheight = fontSize * 1.4;
        bwidth = width - 2 * bheight;
        lheight = bheight * 2;
        tfontSize = fontSize * 0.8 / 2;
        toffset = fontSize;
        theight -= toffset;
        ioffset = bheight * 0.5;
    }
    
    int position = 0;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(bheight, SLOT(position++) + ioffset, width - 2 * bheight, lheight)];
    l.text = @"Using It's a Good Deal";
    l.font = [UIFont systemFontOfSize:fontSize];
    l.backgroundColor = HIGHLIGHTCOLOR;
    [self.view addSubview:l];

    UIWebView *h = [[UIWebView alloc] initWithFrame:CGRectMake(bheight, toffset + SLOT(position++), width - 2 * bheight, theight)];
    h.tag = HelpView;
    NSString *page = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"index.html"];
    [h loadData:[NSData dataWithContentsOfFile:page] MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[[NSBundle mainBundle] bundleURL]];
    [h.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
    [h.layer setBorderWidth:2.0];
    [self.view addSubview:h];
    
    position = 7;
    ra = [[MyButton alloc] initWithFrame:CGRectMake(bheight, SLOT(position++), bwidth, bheight)];
    ra.bothTitles = @"Remove Ads";
    ra.font = [UIFont systemFontOfSize:fontSize];
    ra.radius = radius;
    [ra setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [ra addTarget:self action:@selector(removeAds:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ra];
    
    r = [[MyButton alloc] initWithFrame:CGRectMake(bheight, SLOT(position++), bwidth, bheight)];
    r.bothTitles = @"Restore";
    r.font = [UIFont systemFontOfSize:fontSize];
    r.radius = radius;
    [r setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [r addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:r];

    b = [[MyButton alloc] initWithFrame:CGRectMake(bheight, SLOT(position++), bwidth, bheight)];
    b.bothTitles = @"Done";
    b.font = [UIFont systemFontOfSize:fontSize];
    b.radius = radius;
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [b addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    msg = [[UITextView alloc] initWithFrame:CGRectMake(ra.frame.origin.x, ra.frame.origin.y, ra.frame.size.width, ra.frame.size.height * 2 + fontSize/2)];
    msg.backgroundColor = [UIColor whiteColor];
    msg.hidden = YES;
//    msg.font = r.titleLabel.font;
    msg.font = [UIFont systemFontOfSize:fontSize * (self.isPhone ? 0.8 : 0.6)];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.delegate = self;
    [self.view addSubview:msg];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (myStoreObserver.myProducts.count > 0) {
        if (myStoreObserver.bought) {
            ra.bothTitles = @"Ad Free!";
            ra.enabled = r.enabled = NO;
            r.bothTitles = @"Restore";
        } else {
            ra.bothTitles = @"Remove Ads";
            ra.enabled = r.enabled = YES;
            r.bothTitles = @"Restore";
        }
        r.hidden = ra.hidden = NO;
        msg.hidden = YES;
    } else {
        ra.enabled = r.enabled = NO;
        r.bothTitles = @"Buy Later";
        ra.bothTitles = @"App Store not Available";
        r.hidden = ra.hidden = YES;
        msg.text = @"\nThe App Store is not available, please try later.";
        msg.hidden = NO;
    }
}

- (void)restore:(id)sender {
    [self.delegate restorePurchase];
    [self.delegate dismissSettingsView:self];
}

- (void)removeAds:(id)sender {
    [self.delegate removeAds];
    [self.delegate dismissSettingsView:self];
}

- (void)help:(id)sender {
    [self.delegate dismissSettingsView:self];
}

- (void)goBack:(id)sender {
    [self.delegate dismissSettingsView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
