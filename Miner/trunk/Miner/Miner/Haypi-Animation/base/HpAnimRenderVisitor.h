//
//  HpAnimRenderVisitor.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpAnimVisitor.h"

@interface HpAnimRenderVisitor : NSObject<HpAnimVisitor>

-(void)begin:(id)target;
-(void)end;

-(void)visitAnima:(HpAnimation*)ani firstly:(BOOL)first at:(float)time;
-(void)visitLayer:(HpLayer*)ani firstly:(BOOL)first at:(float)time;
-(void)visitNullKey:(HpNullKeyFrame*)nkf with:(HpKeyframe*)frm at:(float)time;
-(void)visitImageKey:(HpImageKeyframe*)ikf with:(HpKeyframe*)frm at:(float)time;
-(void)visitAnimaKey:(HpAnimaKeyframe*)akf with:(HpKeyframe*)frm at:(float)time;

@end
