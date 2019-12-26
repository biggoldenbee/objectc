//
//  HpTask.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/16.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HpCharaInst;
@protocol HpCharaInstObserver;

#if !__has_feature(objc_arc)
#   define weak assign
#endif

@interface HpAttach : NSObject

@property(nonatomic, strong)UIView* view;
@property(nonatomic, strong)NSString* layer;

@end

@class HpTask;

@protocol HpTaskDelegate <NSObject>

- (void)onCharaTaskFinished:(HpTask*)task;

@end

@interface HpTask : NSObject

@property(nonatomic, weak)id<HpTaskDelegate> taskDelegate;

+ (instancetype)task;

- (void)start;
- (void)finish;

@end

@interface HpCharaTask : HpTask

@property(nonatomic, strong)HpCharaInst* target;
@property(nonatomic, strong)NSString* instFile;
@property(nonatomic, strong)UIView* superview;
@property(nonatomic, strong)NSString* animaName;
@property(nonatomic, assign)CGPoint position;
@property(nonatomic, assign)CGFloat scale;
@property(nonatomic, assign)CGFloat FPS;
@property(nonatomic, getter=isLoop, assign)BOOL loop;
@property(nonatomic, getter=isAutoDestroy, assign)BOOL autoDestroy;
@property(nonatomic, weak)id<HpCharaInstObserver> delegate;
@property(nonatomic, strong)NSMutableArray* attachs;

+ (instancetype)task;

@end


@interface HpSelectorTask : HpTask

@property(nonatomic, strong)NSInvocation* invocation;

+ (instancetype)taskWith:(id)target selector:(SEL)selector;
+ (instancetype)taskWith:(id)target selector:(SEL)selector args:(id)args;
+ (instancetype)taskWith:(id)target selector:(SEL)selector arg1:(id)arg1 arg2:(id)arg2;
+ (instancetype)taskWithInvocation:(NSInvocation*)invocation;

- (instancetype)initWith:(id)target selector:(SEL)selector;
- (instancetype)initWith:(id)target selector:(SEL)selector args:(id)args;
- (instancetype)initWith:(id)target selector:(SEL)selector arg1:(id)arg1 arg2:(id)arg2;
- (instancetype)initWithInvocation:(NSInvocation*)invocation;

@end


@interface HpSequenceTask : HpTask

@property(nonatomic, strong)NSMutableArray* tasks;

+ (instancetype)taskWithArray:(NSArray*)array;
- (instancetype)initWithArray:(NSArray*)array;

@end


@interface HpRepeatTask : HpTask

@property(nonatomic, strong)HpTask* task;
@property(nonatomic, assign)int times;

+ (instancetype)taskWithTask:(HpTask*)task times:(int)times;
- (instancetype)initWithTask:(HpTask*)task times:(int)times;

@end

@interface HpRepeatForeverTask : HpTask


@property(nonatomic, strong)HpTask* task;

+ (instancetype)taskWithTask:(HpTask*)task;
- (instancetype)initWithTask:(HpTask*)task;

@end


@interface HpSpawnTask : HpTask

@property(nonatomic, strong)NSMutableArray* tasks;

+ (instancetype)taskWithArray:(NSArray*)array;
- (instancetype)initWithArray:(NSArray*)array;

@end



