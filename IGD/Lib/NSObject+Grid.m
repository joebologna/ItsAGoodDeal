//
//  NSObject+Grid.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "NSObject+Grid.h"

extern float ***grid;

@implementation NSObject (Grid)

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
            float xw = d->xw;
            float yh = d->yh;
            float x = d->xb + (xw + d->xs) * row;
            float y = d->yb + (yh + d->ys) * row;
            printf("%.2f, %.2f, %.2f, %.2f\n", x, y, xw, yh);
            RECT(d->d, row, x, y, xw, yh);
        }
    }
    
    for (int i = 0; i < ndevices; i++) {
        NSLog(@"%d", i);
        for (int row = 0; row < nrows; row++) {
            devGrid *d = &devices[i];
            CGRect r = [self getRect:d row:row];
            printf("%.2f, %.2f, %.2f, %.2f\n",
                   r.origin.x,
                   r.origin.y,
                   r.size.width,
                   r.size.height);
        }
    }
}

- (CGRect)getRect:(devGrid *)d row:(int)row {
    return CGRectMake(d->xb + (d->xw + d->xs) * row, d->yb + (d->yh + d->ys) * row, d->xw, d->yh);
}

@end
