//
//  HpCharaInst.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCNode;
@class HpAnimaStatus;
@class HpCharaInst;
@class HpCharactorCache;


#define HPANIMATION_SOUND_EVENT         @"hp_charainst_sound_event"
#define HP_SOUND_EVENT_KEY              @"sound"

#if !__has_feature(objc_arc)
#   define weak assign
#endif


@protocol HpCharaInstObserver <NSObject>

- (void)charaInst:(HpCharaInst*)inst onCustomEvent:(NSString*)event;
- (void)charaInst:(HpCharaInst*)inst onAnimationEnd:(NSString *)anima;

@end

@interface HpCharaInst : NSObject

@property(nonatomic, readonly)CCNode* node;
@property(nonatomic, readonly)UIView* view;

@property(nonatomic, readonly)NSString* instFileName;
@property(nonatomic, readonly)NSString* currAnimaName;
@property(nonatomic, readonly)id currAnimation;
@property(nonatomic, getter=isPlaying, readonly)BOOL playing;
@property(nonatomic, readonly)CGFloat currFrameTime;
@property(nonatomic, readonly)NSInteger currLoopCount;
@property(nonatomic, readonly)NSTimeInterval totalTime;
@property(nonatomic, readonly)NSTimeInterval deltaTime;
@property(nonatomic, readonly)HpAnimaStatus* status;
@property(nonatomic, readonly)BOOL firstAnimationFrame;
@property(nonatomic, readonly)HpCharactorCache* cache;

@property(nonatomic, assign)CGPoint position;
@property(nonatomic, assign)CGFloat scale;
@property(nonatomic, assign)CGFloat FPS;
@property(nonatomic, getter=isLoop, assign)BOOL loop;
@property(nonatomic, getter=isAutoDestroy, assign)BOOL autoDestroy;
@property(nonatomic, weak)id<HpCharaInstObserver> delegate;


/* If play the same anima and isLoop is YES, it will don't rebegin;
 */
- (void)playAnima:(NSString*)name isLoop:(BOOL)isLoop;

/* Play once, and it will call `stopAnimaAndCleanup` if isDestroy is YES, otherwise not.
 */
- (void)playAnima:(NSString*)name isDestroy:(BOOL)isDestroy;

/* Play an anima controled by isLoop && isDestroy args
 */
- (void)playAnima:(NSString*)name isLoop:(BOOL)isLoop isDestroy:(BOOL)isDestroy;

/* Play an anima once and destroy
 */
- (void)playEffect:(NSString*)name;

/* Play an anima, and stop at a frame time
 */
- (void)playAnima:(NSString *)name at:(NSTimeInterval)frametime;

/* Stop the anima at current frame time
 */
- (void)stopAnima;

/* It will remove the inst.view from it's superview
 */
- (void)stopAnimaAndCleanup;


- (void)update:(CGFloat)dt;

@end

@interface HpCharaInst (HpCharaInstCreation)

+ (instancetype)inst;
- (instancetype)init;

+ (instancetype)instWithFile:(NSString*)instfile;
- (instancetype)initWithFile:(NSString*)instfile;

+ (instancetype)instWithFile:(NSString*)instfile withScale:(CGFloat)scale;
- (instancetype)initWithFile:(NSString*)instfile withScale:(CGFloat)scale;

/* Load a inst file, and count its name in a static common cache;
 * If reload a cached file, it will be passed, even if cached by an other inst.
 * The file will be truely unload when there isn't an any inst refrence it.
 * If it unloaded, the plist(s) and png(s) will be released too.
 */
- (void)loadInstFile:(NSString*)instfile;
- (void)loadInstFile:(NSString*)instfile withScale:(CGFloat)scale;

/* Reduce the name counter, it will be truely unload if reaching zero.
 */
- (void)unloadInstFile:(NSString*)instfile;
- (void)clearAllInstFile;

/* Preload inst file, to reduce load times if someone load & unload frequently
 */
+ (void)preloadInstFile:(NSString*)instfile;
+ (void)unloadInstFile:(NSString*)instfile;
+ (void)clearAllInstFile;

@end


@interface HpCharaInst (HpCharaInstExtensionMethods)

/* Attach a UIView. Apply the layer whole transform to the view.
 * inst.view will add it if hasn't a superview, otherwise not; If added, it will be released together with the inst;
 * In addition, it will update to the new layer when changed anima;
 */
- (void)attach:(UIView*)child toLayer:(NSString*)layer;
- (void)unattach:(UIView*)child;

//
- (void)onAnimationEnd:(BOOL)destroy;
- (void)onCustomEvent:(NSString*)event;

- (NSDictionary*)animas;

+ (void)setDefaultFPS:(CGFloat)fps;
+ (CGFloat)defaultFPS;

@end
