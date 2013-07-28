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

@interface KeypadTests() {
    DeviceType *deviceType;
    devGrid **g_devices;
    float ***g_grid;
};

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

- (void)testGrid2 {
    
    devGrid devices[] = {
        {iPhone4, 0, 0, 20, 10, 2, 2},
        {iPhone5, 0, 0, 20, 10, 2, 2},
        {iPad, 0, 0, 20, 10, 2, 2}
    };
    int ndevices = sizeof(devices)/sizeof(devGrid);
    g_devices = malloc(ndevices * sizeof(devGrid));
    memccpy(g_devices, devices, ndevices, sizeof(devGrid));
    
    int nrows = 4;
    float *grid[ndevices][nrows];

    for (int device = 0; device < ndevices; device++) {
        for (int row = 0; row < nrows; row++) {
            CGRect r = CGRectMake(0, 0, 0, 0);
            memccpy(&r, &grid[device][row], 1, sizeof(CGRect));
            r.origin.x = devices[device].xb + row * (devices[device].xw + devices[device].xs);
            r.origin.y = devices[device].yb + row * (devices[device].yh + devices[device].ys);
            r.size.width = devices[device].xw;
            r.size.height = devices[device].yh;
            [self printRect:&r];
        }
    }
    g_grid = malloc(ndevices * nrows * sizeof(CGRect));
    memccpy(g_grid, grid, ndevices*nrows, sizeof(float));
    for (int device = 0; device < ndevices; device++) {
        for (int row = 0; row < nrows; row++) {
            [self printRect:(CGRect *)g_grid[device][row]];
        }
    }
}

- (void)printRect:(CGRect *)r {
    NSLog(@"%.2f, %.2f, %.2f, %.2f", r->origin.x, r->origin.y, r->size.width, r->size.height);
}

- (void)dealloc:(id)sender {
    if (grid != (float ***)0) {
        free(grid);
    }
}

@end
