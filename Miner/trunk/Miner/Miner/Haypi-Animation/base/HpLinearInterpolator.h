//
//  HpLinearInterpolator.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpInterpolator.h"

@interface HpLinearInterp : NSObject <HpInterp>

+(id)interp;
+(void)purge;

-(float)getFactorWithStart:(int)t1 end:(int)t2 at:(float)t;

@end
