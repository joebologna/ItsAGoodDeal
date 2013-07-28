//
//  KeypadTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/27/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "KeypadTests.h"
#import "NSObject+Utils.h"

static float ***gridArray;

@implementation KeypadTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCase {
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

#define RECT(d, r, x, y, w, h) \
*((float *)grid + (d * 3 * 4 * r) + 0) = x; \
*((float *)grid + (d * 3 * 4 * r) + 1) = y; \
*((float *)grid + (d * 3 * 4 * r) + 2) = w; \
*((float *)grid + (d * 3 * 4 * r) + 3) = h;

- (void)makeGrid:(float ****)grid devices:(DeviceType [])d rows:(int)rows {
    NSLog(@"iPhone4");
    {
        float xb = 20, yb = 200, xw = 64, yh = 46, xs = 8, ys = 2;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys);
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            RECT(iPhone4, row, x, y, xw, yh);
        }
    }
    NSLog(@"iPhone5");
    {
        float xb = 20, yb = 288, xw = 64, yh = 46, xs = 8, ys = 2;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys);
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            RECT(iPhone5, row, x, y, xw, yh);
        }
    }
    NSLog(@"iPad");
    {
        float xb = 20, yb = 546, xw = 176, yh = 92, xs = 8, ys = 6;
        for (int row = 0; row < 4; row++) {
            float x = xb + (xw + xs) * row;
            float y = yb + (yh + ys) * row;
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            RECT(iPad, row, x, y, xw, yh);
        }
    }
    for (int i = iPhone4; i <= iPad; i++) {
        NSLog(@"%d", i);
        for (int row = 0; row < 4; row++) {
            CGRect *r = (CGRect *)(grid + (i * 3 * 4 * row));
            printf("%.2f, %.2f, %.2f, %.2f\n",
                   r->origin.x,
                   r->origin.y,
                   r->size.width,
                   r->size.height);
        }
    }
}

- (void)testGrid {
    //- (void)makeGrid:(float ****)grid devices:(DeviceType [])d rows:(int)rows {

    int rows = 4;
    DeviceType devices[] = {iPhone4, iPhone5, iPad};
    int n = sizeof(float) * (sizeof(devices) / sizeof(DeviceType)) * rows * (sizeof(CGRect) / sizeof(float));
    gridArray = malloc(n);
    memset(gridArray, sizeof(float), n);
    [self makeGrid:&gridArray devices:devices rows:rows];
}

- (void)dealloc:(id)sender {
    if (*gridArray != 0) {
        free(gridArray);
    }
}

@end
