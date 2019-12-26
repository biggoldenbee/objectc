//
//  HpInterpolator.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HpInterp <NSObject>

@required
-(float)getFactorWithStart:(int)t1 end:(int)t2 at:(float)t;

@end

enum HpInterpTarget
{
    HpInterp_Base = 0,
    HpInterp_Center = 0,
    HpInterp_Scale,
    HpInterp_Skew,
    HpInterp_Rot,
    HpInterp_Trans,
    HpInterp_Color,
    HpInterp_Num
};