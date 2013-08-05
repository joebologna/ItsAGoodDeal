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

- (void)setVwith:(UITouch *)t andS:(UISlider *)s andX:(float)x {
    long int v = lroundf((x / t.view.frame.size.width) * (s.maximumValue - s.minimumValue));
    v = MAX(s.minimumValue, v);
    v = MIN(s.maximumValue, v);
    s.value = v;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    UISlider *s = (UISlider *)t.view;
    float x = [t locationInView:t.view].x;
#ifdef DEBUG
    NSLog(@"%s:%@:%@:%.2f", __func__, touches, event, x);
#endif
    [self setVwith:t andS:s andX:x];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    UISlider *s = (UISlider *)t.view;
    float x = [t locationInView:t.view].x;
#ifdef DEBUG
    NSLog(@"%s:%@:%@:%.2f", __func__, touches, event, x);
#endif
    [self setVwith:t andS:s andX:x];
    [self.caller updateQty:self.value];
    [self.caller updateSavings];
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
