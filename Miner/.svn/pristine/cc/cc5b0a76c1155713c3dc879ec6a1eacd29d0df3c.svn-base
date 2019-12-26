//
//  HpAnimation.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HpLayer;
@class HpContentKeyframe;

@interface HpAnimation : NSObject

@property(readonly, nonatomic) NSString* name;
@property(readonly, nonatomic) NSInteger length;
@property(readonly, nonatomic) NSMutableArray* layers;

-(id)initWithName:(NSString*)name length:(NSInteger)len;
-(HpAnimation*)clone;

-(HpLayer*)getLayerByName:(NSString*)name;
-(BOOL)insertLayer:(HpLayer*)layer beforeLayer:(NSString*)target;
-(BOOL)replaceLayer:(NSString*)target with:(HpLayer*)layer;
-(void)replaceContent:(NSString*)content inLayer:(NSString*)layer with:(HpContentKeyframe*)ckf;

@end
