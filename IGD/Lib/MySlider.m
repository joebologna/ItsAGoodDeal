//
//  Slider.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/3/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "MySlider.h"

@implementation MySlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#ifdef DEBUG
    NSLog(@"%s:%@:%@", __func__, touches, event);
#endif
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    UISlider *s = (UISlider *)t.view;
    float x = [t locationInView:t.view].x;
#ifdef DEBUG
    NSLog(@"%s:%@:%@:%.2f", __func__, touches, event, x);
#endif
    s.value = (x / t.view.frame.size.width) * (s.maximumValue - s.minimumValue);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    UISlider *s = (UISlider *)t.view;
    float x = [t locationInView:t.view].x;
#ifdef DEBUG
    NSLog(@"%s:%@:%@:%.2f", __func__, touches, event, x);
#endif
    long int v = lroundf((x / t.view.frame.size.width) * (s.maximumValue - s.minimumValue));
    s.value = v;
    NSLog(@"v:%.2f", s.value);
    [self.caller newValue:v];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
