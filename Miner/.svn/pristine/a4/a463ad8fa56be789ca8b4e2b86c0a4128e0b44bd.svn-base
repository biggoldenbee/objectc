//
//  HpAnimaKeyframe.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpKeyframe.h"

@class HpAnimation;

@interface HpAnimaKeyframe : HpContentKeyframe

@property(nonatomic, retain)HpAnimation* anima;

-(void)visitBy:(id<HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)frm;
-(HpContentKeyframe*)clone;

@end
