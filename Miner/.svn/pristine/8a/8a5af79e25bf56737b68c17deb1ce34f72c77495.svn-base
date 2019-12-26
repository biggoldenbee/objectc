//
//  HpAttachPoint.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HpLayer;

@interface HpAttachPoint : NSObject
{
    NSMutableArray* _object_attached;
}

@property(readwrite, nonatomic, copy) NSString* layerName;
@property(readwrite, nonatomic, retain) HpLayer* layerInst;

-(id)init;
-(void)dealloc;
-(void)attach:(id)obj;
-(void)remove:(id)obj;
-(void)apply;
-(void)clear;

@end
