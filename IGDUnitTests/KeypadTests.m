//
//  KeypadTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/27/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "KeypadTests.h"
#import "NSObject+Grid.h"

static float ***grid = (float ***)0;

@interface KeypadTests() {DeviceType *deviceType;};

@end
@implementation KeypadTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCase {
    return;
    CGRect r[3][4];
    
    NSLog(@"iPhone4");
    {
        float xb = 20, yb = 200, xw = 64, yh = 46, xs = 8, ys = 2;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys);
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            r[iPhone4][row] = CGRectMake(x, y, xw, yh);
        }
    }
    NSLog(@"iPhone5");
    {
        float xb = 20, yb = 288, xw = 64, yh = 46, xs = 8, ys = 2;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys);
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            r[iPhone5][row] = CGRectMake(x, y, xw, yh);
        }
    }
    NSLog(@"iPad");
    {
        float xb = 20, yb = 546, xw = 176, yh = 92, xs = 8, ys = 6;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys) * row;
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            r[iPad][row] = CGRectMake(x, y, xw, yh);
        }
    }
    for (int i = iPhone4; i <= iPad; i++) {
        NSLog(@"%d", i);
        for (int row = 0; row < 4; row++) {
            printf("%.2f, %.2f, %.2f, %.2f\n",
                   r[i][row].origin.x,
                   r[i][row].origin.y,
                   r[i][row].size.width,
                   r[i][row].size.height);
        }
    }
}

- (void)testGrid {
    //- (void)makeGrid:(float ****)grid devices:(DeviceType [])d rows:(int)rows {

    int rows = 4;
    devGrid devices[] = {
        {iPhone4, 20, 200, 64, 46, 8, 2},
        {iPhone5, 20, 288, 64, 46, 8, 2},
        {iPad, 20, 546, 176, 92, 8, 6}
    };
    [self makeGrid:&grid devices:devices ndevices:sizeof(devices)/sizeof(devGrid) rows:rows];
}

- (void)dealloc:(id)sender {
    if (grid != (float ***)0) {
        free(grid);
    }
}

@end
