//
//  SettingsView.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/5/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "SettingsView.h"
#import "MyButton.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HIGHLIGHTCOLOR UIColorFromRGB(0xd2fde8)

@interface SettingsView ()

@end

@implementation SettingsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = HIGHLIGHTCOLOR;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    int position = 1;
    float radius = 6;
    float bheight = [UIFont systemFontSize] * 2;
    
    UITextView *h = [[UITextView alloc] initWithFrame:CGRectMake(bheight, height * 0.1 * position, width - 2 * bheight, height * 0.1 * 4.5)];
    h.text = @"Tap the Remove Ads button to purchase this option.\nTap the Restore button to restore this Remove Ads purchase.\nExplain how the slider works and stuff.";
    h.editable = NO;
    [self.view addSubview:h];
    
    position = 6;
    MyButton *r = [[MyButton alloc] initWithFrame:CGRectMake(110, height * 0.1 * position++, 120, bheight)];
    r.bothTitles = @"Restore";
    r.radius = radius;
    [r setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [r addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:r];

    MyButton *ra = [[MyButton alloc] initWithFrame:CGRectMake(110, height * 0.1 * position++, 120, bheight)];
    ra.bothTitles = @"Remove Ads";
    ra.radius = radius;
    [ra setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [ra addTarget:self action:@selector(removeAds:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ra];

    position = 8;
    MyButton *b = [[MyButton alloc] initWithFrame:CGRectMake(110, height * 0.1 * position++, 120, bheight)];
    b.bothTitles = @"Done";
    b.radius = radius;
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [b addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
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
