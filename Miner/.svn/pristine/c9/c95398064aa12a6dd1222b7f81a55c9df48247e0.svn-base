//
//  HpImageKeyframe.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpKeyframe.h"

@class HpSpriteFrame;

@interface HpImageKeyframe : HpContentKeyframe

@property(nonatomic, retain)HpSpriteFrame* spriteframe;

-(void)visitBy:(id<HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time;
-(HpContentKeyframe*)clone;

@end
