//
//  HpSplineInterpolator.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HpInterpolator.h"

@interface HpSplineInterp : NSObject <HpInterp>
{
    CGPoint P0;   // 起点
    CGPoint P1;   // 控1
    CGPoint P2;   // 控2
    CGPoint P3;   // 终点
}

@property(nonatomic, readwrite, assign) CGPoint p1;
@property(nonatomic, readwrite, assign) CGPoint p2;

+(id)interp:(NSString*)ctrlpts;
+(void)purge;


-(float)getFactorWithStart:(int)t1 end:(int)t2 at:(float)t;

@end
