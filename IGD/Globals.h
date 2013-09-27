//
//  Globals.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/23/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#ifndef ItsAGoodDeal_Globals_h
#define ItsAGoodDeal_Globals_h

#define SLIDER_MIN 20

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define CURFIELDCOLOR UIColorFromRGB(0x86e4ae)
#define FIELDCOLOR UIColorFromRGB(0xaaffcf)
#define BACKGROUNDCOLOR UIColorFromRGB(0x53e99e)
#define HIGHLIGHTCOLOR UIColorFromRGB(0xd2fde8)

//#define DEBUG_VERBOSE


#endif
