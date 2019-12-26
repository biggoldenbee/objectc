//
//  HpCharactorCache.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/5.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HpSpriteFrame;
@class HpAnimation;
@class HpCharactor;

@protocol HpAnimVisitor;
@protocol HpAnimParser;

@interface HpCharactorCache : NSObject

@property(nonatomic, readonly)NSString* fileName;

- (id)addCharatorFile:(NSString*)fileName;
- (void)removeCharatorFile:(NSString*)fileName;

- (void)addPlistFile:(NSString*)plist;
- (void)removePlistFile:(NSString*)plist;

- (void)removeAllCache;

- (HpCharactor*)charactorByFile:(NSString*)file;
- (HpAnimation*)animtionByName:(NSString*)name;
- (HpSpriteFrame*)spriteFrameByName:(NSString*)name;

- (UIImage*)imageBySpriteFrame:(HpSpriteFrame*)spriteframe;

- (id<HpAnimVisitor>)builder;
- (id<HpAnimVisitor>)render;
- (id<HpAnimParser>)xmlParse;
- (id<HpAnimParser>)chrParse;

@end
