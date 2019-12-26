//
//  HpKeyframe.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HpAnimVisitor.h"

@class HpInterpHolder;

enum HpContentType
{
    HpContentType_Null,
    HpContentType_Image,
    HpContentType_Anima,
    HpContentType_Num
};

@interface HpKeyframe : NSObject

@property(readwrite, nonatomic) int time;
@property(readwrite, nonatomic, assign) BOOL isTimeInherited;
@property(readwrite, nonatomic, assign) uint arrayIndex;
@property(readwrite, nonatomic) CGPoint center;
@property(readwrite, nonatomic) CGPoint trans;
@property(readwrite, nonatomic) CGFloat rot;
@property(readwrite, nonatomic) CGPoint skew;
@property(readwrite, nonatomic) CGPoint scale;
@property(readwrite, nonatomic, retain) UIColor* color;
@property(readwrite, nonatomic, retain) NSString* event;
@property(readwrite, nonatomic, retain) NSString* content;
@property(readwrite, nonatomic) enum HpContentType contentType;
@property(readwrite, nonatomic, retain) HpInterpHolder* interps;

-(CGPoint)getCenterAt:(float)time;
-(CGPoint)getTransAt:(float)time;
-(CGFloat)getRotAt:(float)time;
-(CGPoint)getSkewAt:(float)time;
-(CGPoint)getScaleAt:(float)time;
-(UIColor*)getColorAt:(float)time;

@end


@interface HpContentKeyframe : NSObject

@property(readwrite, nonatomic) int time;
@property(readwrite, nonatomic) BOOL firstVisitFlag;
@property(readwrite, nonatomic, retain) NSString* contentName;

-(void)visitBy:(id <HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time;

// return a `retained` result for reducing `autorelease` items
-(HpContentKeyframe*)clone;

@end

