//
//  HpLayer.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HpKeyframe;
@class HpContentKeyframe;

@interface HpLayer : NSObject

@property(readonly) NSString* name;
@property(readonly) NSMutableArray* keys;
@property(readonly) NSMutableArray* indexer;
@property(readonly) NSMutableArray* contentKeys;
@property(readonly) int indexOffset;
@property(readonly) int duration;
@property(readwrite, nonatomic, assign) CGAffineTransform transform;

-(id)initWithName:(NSString*)name;
-(HpLayer*)clone;
-(void)build;

-(HpKeyframe*)getKeyframeAt:(int)idx;
-(HpContentKeyframe*)getContentKeyframeAt:(float)idx;
-(void)replaceContent:(NSString*)name with:(HpContentKeyframe*)content;

@end
