//
//  BattleActorView.h
//  Miner
//
//  Created by jim kaden on 14/12/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleData.h"
#import "HpCharaInst.h"
@class UILabelEx;
typedef enum
{
    AT_STANDBY,
    AT_DEAD,
    AT_DEFENDER,
    AT_ATTACK_NORMAL,
    AT_ATTACK_SKILL,
    AT_ATTACK_SKILL_EFFECT,
    AT_HEAL,
    AT_DEFENDER_NORMAL,
    AT_DEFENDER_SKILL,
    AT_PREPARE_SKILL,
    AT_DODGE,
    AT_PARRY,
    AT_CRITICAL,
}
ANIMA_TYPE;

@protocol BattleAnimationDelegate
-(void)play:(NSString*)name;
-(HpCharaInst*)getCharaInst;
@optional
-(void)finalClean;

@end

@protocol SequenceDelegate <NSObject>
-(void)sequenceFinished:(id)seqID;
@end

@class BattleActionAnimation;
@class BattleBuffAnimation;
@class OneTimeUseAnimation;
@class BattleAnimationBuffIcon;

@interface BattleActorView : UIView

@property (strong, nonatomic) BattleActor* actor;
@property (weak, nonatomic) IBOutlet UIView* actorView;
@property (weak, nonatomic) IBOutlet UIImageView *imageHp;
@property (weak, nonatomic) IBOutlet UILabelEx *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHp;
@property (weak, nonatomic) IBOutlet UILabelEx *labelLevel;
@property (weak, nonatomic) IBOutlet UIView *viewUI;

@property (strong)BattleActionAnimation* actionAnimation;

+(BattleActorView*)create:(UIView*)owner;
-(void)setupActor:(BattleActor*)actor;
-(void)reset;
-(void)changeHp:(NSNumber*)hp;
-(void)die:(NSNumber*)hp;
-(CGPoint)skillAnchor;
-(NSString*)animaByType:(ANIMA_TYPE)at;
-(NSString*)animaBySkill:(int)sid withLv:(int)lv type:(ANIMA_TYPE)at;
-(NSString*)animaByAttri:(int)aid;
-(BOOL)animaContinurousByAttri:(int)aid;
-(NSString*)animaByBuff:(int)bid withLv:(int)blv;
-(BOOL)animaContinurousByBuff:(int)bid withLv:(int)blv;
-(BattleBuffAnimation*)addBuff:(int)buffID withLv:(int)lv;
-(void)minusBuff:(int)buffID;
-(void)refreshBuff;
-(void)turnChanged;
-(OneTimeUseAnimation*)animationChangeHpInCritical:(int)hp delegate:(NSObject<SequenceDelegate>*)delegate;
-(OneTimeUseAnimation*)animationChangeHp:(int)hp delegate:(NSObject<SequenceDelegate>*)delegate;
-(OneTimeUseAnimation*)animationSkillBoard:(int)sid withLv:(int)lv delegate:(NSObject<SequenceDelegate>*)delegate;
-(OneTimeUseAnimation*)tempActionAnimation:(BOOL)loop delegate:(NSObject<SequenceDelegate>*)delegate;
-(OneTimeUseAnimation*)animationDodgeParry:(BOOL)isDodge delegate:(NSObject<SequenceDelegate>*)delegate;
@end

@interface BattleAnimationBase : NSObject<BattleAnimationDelegate, HpCharaInstObserver>
{
    UIView* _view;
    BOOL _loop;
    BOOL _calledOnce;
}
@property (weak) NSObject<SequenceDelegate>* delegate;
-(id)init:(UIView*)view;
-(HpCharaInst*)getCharaInst;
-(void)play:(NSString*)name;
-(void)finish;

@end

@interface BattleActionAnimation : BattleAnimationBase
@property (weak) NSObject<SequenceDelegate>* actionDelegate;
-(HpCharaInst*)getCharaInst;
-(void)play:(NSString*)name;
@end

@interface BattleBuffAnimation : BattleAnimationBase
{
    HpCharaInst* _inst;
    UIView* _baseView;

}
@property (strong) HpCharaInst* inst;
@property (strong) BattleAnimationBuffIcon* buffIcon;
@property (strong) NSObject<BattleAnimationDelegate>* attachedInst;
-(id)init:(UIView*)view buff:(int)buff buffLv:(int)lv offset:(CGRect)offset;
-(HpCharaInst*)getCharaInst;
-(void)play:(NSString*)name;
-(void)setFrame:(CGRect)frame;
-(void)clean;
@end


@interface OneTimeUseAnimation : BattleAnimationBase
{
    HpCharaInst* _inst;
}
@property (strong) HpCharaInst* inst;
@property (strong) NSInvocation* invocation;
-(id)init:(UIView*)view loop:(BOOL)loop offset:(CGRect)offset delegate:(NSObject<SequenceDelegate>*)delegate;
-(HpCharaInst*)getCharaInst;
-(void)play:(NSString*)name;
-(void)setFrom:(CGPoint)from to:(CGPoint)to;
@end

@interface TwoPointAnimation : OneTimeUseAnimation
{
    UIView* _baseView;
}
-(id)init:(UIView*)view offset:(CGRect)offset delegate:(NSObject<SequenceDelegate>*)delegate;
-(void)setFrom:(CGPoint)from to:(CGPoint)to;
@end


