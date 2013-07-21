//
//  MyButton.m
//  testColorButton
//
//  Created by Joe Bologna on 9/19/12.
//  Copyright (c) 2012 Joe Bologna. All rights reserved.
//

#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>

#define NORMAL_BACKGROUND  [backgroundColors objectAtIndex:0]
#define SELECTED_BACKGROUND [backgroundColors objectAtIndex:1]
#define HELD_BACKGROUND [backgroundColors objectAtIndex:2]

#define NORMAL_TITLE  [titles objectAtIndex:0]
#define SELECTED_TITLE [titles objectAtIndex:1]

#define NORMAL_TITLECOLOR  [titleColors objectAtIndex:0]
#define SELECTED_TITLECOLOR [titleColors objectAtIndex:1]

@interface MyButton() {
    CAGradientLayer *gradientLayer;
    UIColor *prevColor;
}

@end

@implementation MyButton

@synthesize backgroundColors = _backgroundColors;
- (void)setBackgroundColors:(NSArray *)newBackgroundColors {
    backgroundColors = newBackgroundColors;
    self.backgroundColor = self.selected ? SELECTED_BACKGROUND : NORMAL_BACKGROUND;
}

@synthesize titles = _titles;
- (void)setTitles:(NSArray *)newTitles {
    titles = newTitles;
    [self setTitle:NORMAL_TITLE forState:UIControlStateNormal];
    [self setTitle:SELECTED_TITLE forState:UIControlStateSelected];
}

@synthesize titleColors = _titleColors;
- (void)setTitleColors:(NSArray *)newTitleColors {
    titleColors = newTitleColors;
    [self setTitleColor:NORMAL_TITLECOLOR forState:UIControlStateNormal];
    [self setTitleColor:SELECTED_TITLECOLOR forState:UIControlStateSelected];
}

@synthesize bothTitles = _bothTitles;
- (void)setBothTitles:(NSString *)b {
    self.titles = [NSArray arrayWithObjects:b, b, nil];
    _bothTitles = b;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    backgroundColors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor redColor],  [UIColor grayColor], nil];
    
    gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:self.bounds];
    [gradientLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
 
    [self.layer insertSublayer:gradientLayer atIndex:0];

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.backgroundColor = NORMAL_BACKGROUND;
    self.selected = NO;
    
    self.titles = [NSArray arrayWithObjects:@"normal", @"selected", nil];
    self.titleColors = [NSArray arrayWithObjects:[UIColor blueColor], [UIColor whiteColor], nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    prevColor = self.backgroundColor;
    self.backgroundColor = HELD_BACKGROUND;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = prevColor;
    [super touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0.5] CGColor], (id)[[UIColor colorWithWhite:0.85 alpha:0.5] CGColor], nil]];
}

- (void)toggle {
    self.selected = !self.selected;
    if (self.selected) {
        self.backgroundColor = SELECTED_BACKGROUND;
    } else {
        self.backgroundColor = NORMAL_BACKGROUND;
    }
}
@end
