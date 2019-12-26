//
//  HpNullKeyframe.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpNullKeyframe.h"
#import "HpBaseMacros.h"

@implementation HpNullKeyframe

-(void)visitBy:(id<HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time
{

}

-(HpContentKeyframe*)clone
{
    return retain(self);
}

@end
