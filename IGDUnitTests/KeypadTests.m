//
//  KeypadTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/27/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "KeypadTests.h"
#import "NSObject+Utils.h"

static float ***grid = (float ***)0;

typedef struct {DeviceType d; float xb;float yb; float xw; float yh; float xs; float ys;} devGrid;

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

#define RECT(d, r, x, y, w, h) \
*((float *)grid + (d * 3 * 4 * r) + 0) = x; \
*((float *)grid + (d * 3 * 4 * r) + 1) = y; \
*((float *)grid + (d * 3 * 4 * r) + 2) = w; \
*((float *)grid + (d * 3 * 4 * r) + 3) = h;

- (void)makeGrid:(float ****)grid devices:(devGrid [])devices ndevices:(int)ndevices rows:(int)nrows {
    int n = sizeof(float) * ndevices * nrows * (sizeof(CGRect) / sizeof(float));
    if (grid == (float ****)0) {
        grid = malloc(n);
        memset(grid, sizeof(float), n);
    }
    
    for (int i = 0; i < ndevices; i++) {
        devGrid *d = &devices[i];
        NSLog(@"%d", d->d);
        for (int row = 0; row < nrows; row++) {
            float x = d->xb + (d->xw + d->xs) * row;
            float y = d->yb + (d->yh + d->ys);
            float xw = d->xw;
            float yh = d->yh;
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            RECT(d->d, row, x, y, xw, yh);
        }
    }

    for (int i = iPhone4; i <= iPad; i++) {
        NSLog(@"%d", i);
        for (int row = 0; row < nrows; row++) {
            CGRect *r = (CGRect *)(grid + (i * ndevices * nrows * row));
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
