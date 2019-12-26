//
//  HpInterpHolder.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HpInterpolator.h"

@class HpKeyframe;

@interface HpInterpHolder : NSObject

@property(readwrite, retain, nonatomic) id<HpInterp> centerInterp;
@property(readwrite, retain, nonatomic) id<HpInterp> transInterp;
@property(readwrite, retain, nonatomic) id<HpInterp> skewInterp;
@property(readwrite, retain, nonatomic) id<HpInterp> scaleInterp;
@property(readwrite, retain, nonatomic) id<HpInterp> rotInterp;
@property(readwrite, retain, nonatomic) id<HpInterp> colorInterp;
@property(readwrite, assign, nonatomic) HpKeyframe* target;

-(CGPoint)getCenterAt:(float)time between:(HpKeyframe*)sender;
-(CGPoint)getTransAt:(float)time between:(HpKeyframe*)sender;
-(CGPoint)getSkewAt:(float)time between:(HpKeyframe*)sender;
-(CGPoint)getScaleAt:(float)time between:(HpKeyframe*)sender;
-(float)getRotAt:(float)time between:(HpKeyframe*)sender;
-(UIColor*)getColorAt:(float)time between:(HpKeyframe*)sender;

@end
