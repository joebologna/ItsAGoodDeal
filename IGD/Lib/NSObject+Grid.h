//
//  NSObject+Grid.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Utils.h"

#define RECT(d, r, x, y, w, h) \
*((float *)grid + (d * 3 * 4 * r) + 0) = x; \
*((float *)grid + (d * 3 * 4 * r) + 1) = y; \
*((float *)grid + (d * 3 * 4 * r) + 2) = w; \
*((float *)grid + (d * 3 * 4 * r) + 3) = h;

typedef struct {DeviceType d; float xb;float yb; float xw; float yh; float xs; float ys;} devGrid;

@interface NSObject (Grid)

- (void)makeGrid:(float ****)grid devices:(devGrid [])devices ndevices:(int)ndevices rows:(int)nrows;

@end
