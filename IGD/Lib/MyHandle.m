//
//  MyHandle.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/6/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "MyHandle.h"

static float distMoved = 0.0;
static CGRect origLoc;

@implementation MyHandle

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
    NSLog(@"%s", __func__);
#endif
    distMoved = 0.0;
    origLoc = self.delegate.view.frame;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    CGPoint p1 = [[touches anyObject] previousLocationInView:self];
    CGPoint p2 = [[touches anyObject] locationInView:self];
    distMoved += p1.y - p2.y;
    if (distMoved > 0) {
        CGRect r = origLoc;
        r.origin.y -= distMoved;
        self.delegate.view.frame = r;
        if (distMoved > r.size.height * 0.1) {
            [self.delegate performSelector:@selector(showSettings)];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.delegate.view.frame = origLoc;
    distMoved = 0.0;
}

/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

@end
