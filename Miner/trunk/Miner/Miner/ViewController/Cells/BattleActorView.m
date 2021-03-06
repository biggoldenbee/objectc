//
//  BattleActorView.m
//  Miner
//
//  Created by jim kaden on 14/12/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleActorView.h"
#import "AttributeString.h"
#import "HpCharaInst.h"
#import "Hero.h"
#import "GameObject.h"
#import "GameUtility.h"
#import "MobConfig.h"
#import "SkillConfig.h"
#import "AttriConfig.h"
#import "BuffConfig.h"
#import "BattleAnimationHpChange.h"
#import "BattleAnimationSkillBoard.h"
#import "BattleAnimationBuffIcon.h"
#import "BattleAnimationCommonLabel.h"

#define kEventCommonName @"1"

@interface BattleActorView()
{
    CGRect originalHpRect;
    int maxHp;
    int currentHp;
    BOOL isAlly;
    int normalAttackSkillID;
    NSMutableArray* arrayBuffs;
    CGPoint anchorPointOfSkill;
}
@property (strong)HpCharaInst* actionInst;
@property (strong)UIImageView* avatarView;
@property (strong)UIView* uiView;
@end

@implementation BattleActorView

+(BattleActorView*)create:(UIView*)owner
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleActorView" owner:owner options:nil];
    BattleActorView* view = (BattleActorView*)[array objectAtIndex:0];
    [view initActor];
    [owner addSubview:view];
    return view;
}

-(void)initActor
{
    arrayBuffs = [[NSMutableArray alloc]init];
    
    anchorPointOfSkill = CGPointZero;
    originalHpRect = self.imageHp.frame;
    self.actorView.backgroundColor = [UIColor clearColor];
    self.viewUI.backgroundColor = [UIColor clearColor];
    
    self.actionInst = [HpCharaInst instWithFile:@"ui.chr"];
    [self.actorView addSubview:self.actionInst.view];
    [self.actionInst.view setFrame:CGRectMake(43, 95, 0, 0)];
    
    self.actionAnimation = [[BattleActionAnimation alloc]init:self];
    
    self.uiView = self.viewUI;
    [self.viewUI removeFromSuperview];
    self.viewUI.frame = CGRectMake(0,0,0,0);
    
    self.avatarView = [[UIImageView alloc]init];
    self.avatarView.frame = CGRectMake(-40/2, -30/2, 80/2, 80/2);
    
    [self.actionInst attach:self.avatarView toLayer:@"ui_00avatar_2"];
    [self.actionInst attach:self.uiView toLayer:@"ui_xvetiao"];
    self.labelName.stroke = YES;
    self.labelLevel.stroke = YES;
    isAlly = YES;
    [self arrangeViews];
}

-(void)refreshHp
{
    CGRect rect = self.imageHp.frame;
    if ( maxHp <= 0 )
        rect.size.width = 0;
    else
        rect.size.width = originalHpRect.size.width * currentHp / maxHp;
    
    if ( !isAlly )
    {
        rect.origin.x = originalHpRect.origin.x + ( originalHpRect.size.width - rect.size.width );
    }
    
    self.imageHp.frame = rect;
    
    self.labelHp.text = [NSString stringWithFormat:@"%d/%d", currentHp, maxHp];
}

-(void)changeHp:(NSNumber*)hp
{
    currentHp += hp.intValue;
    if ( currentHp > maxHp )
        currentHp = maxHp;
    if ( currentHp < 0 )
        currentHp = 0;
    [self refreshHp];
}

-(void)die:(NSNumber*)hp
{
    currentHp = 0;
    
    [self refreshHp];
    
    for(BattleBuffAnimation* bi in arrayBuffs)
    {
        [bi finish];
        [[bi getCharaInst] stopAnimaAndCleanup];
        [bi clean];
    }
    
    [arrayBuffs removeAllObjects];
    
    [self.actionInst unattach:self.uiView];
}

-(void)reset
{
    self.actor = nil;
    
    for(BattleBuffAnimation* bi in arrayBuffs)
    {
        [bi finish];
        [[bi getCharaInst] stopAnimaAndCleanup];
        [bi clean];
    }
    
    [arrayBuffs removeAllObjects];
    
    [self.actionInst attach:self.uiView toLayer:@"ui_xvetiao"];
}

-(void)turnChanged
{
    for(BattleBuffAnimation* bi in arrayBuffs)
    {
        [bi.buffIcon changeCount:-1];
    }
}

-(void)setupIcon:(NSString*)icon defaultValue:(NSString*)defaultValue
{
    UIImage* image = nil;
    if ( icon != nil )
        image = [GameUtility imageNamed:icon];
    if ( image == nil )
        image = [GameUtility imageNamed:defaultValue];
    
    self.avatarView.image = image;
//    CGSize size = image.size;
//    self.avatarView.frame = CGRectMake(-size.width/4, -size.height/4-22, size.width/2, size.height/2);
//    CGRect f = self.avatarView.frame;
    //self.avatarView.frame = CGRectMake(f.origin.x, f.origin.y, 45, 45);
}

-(void)setupIcon
{
//    [self.actionInst unattach:self.uiView];
//    [self.actionInst attach:self.uiView toLayer:@"ui_xvetiao"];
//    [self.actionInst unattach:self.avatarView];
//    [self.actionInst attach:self.avatarView toLayer:@"ui_00avatar_2"];
//    self.uiView.frame = CGRectMake(0, 0, 0, 0);
    
    switch(self.actor.type)
    {
        case 0:
        {
            int icon = [[GameObject sharedInstance].player.heroIcon intValue] + 1;
            [self setupIcon:[NSString stringWithFormat:@"icon_hero%d", icon ] defaultValue:@"mine_player1.png"];
        }
            break;
        case 1:
        {
            Pet* pet = [[GameObject sharedInstance] getPetWithType:[NSNumber numberWithInt:(int)self.actor.mid ]];
            [self setupIcon:pet.petIcon defaultValue:@"icon_mob202"];
        }
            break;
        case 2:
        {
            MobDef* mb = [[MobConfig share] getMobDefById:self.actor.mid];
            [self setupIcon:mb.mobIcon defaultValue:@"icon_mob601"];
        }
            break;
        case 3:
        {
            MobDef* mb = [[MobConfig share] getMobDefById:self.actor.mid];
            [self setupIcon:mb.mobIcon defaultValue:@"icon_mob2601"];
        }
            break;
        case 4:
        {
            int icon = [[GameObject sharedInstance].player.heroIcon intValue] + 1;
            [self setupIcon:[NSString stringWithFormat:@"icon_hero%d", icon ] defaultValue:@"mine_player1.png"];
        }
        case 5:
        default:
            break;
    }
    [self.actionInst update:0.f];
}


-(void)arrangeViews
{
    if ( isAlly )
    {
        [self.actionInst.view setFrame:CGRectMake(43/2, 95/2, 0, 0)];
        self.labelName.frame = CGRectMake(-51/2, -30/2-2, 102/2, 16/2);
        self.imageHp.frame = CGRectMake(-51/2, -8/2, 102/2, 16/2);
        self.labelHp.frame = self.imageHp.frame;
        originalHpRect = self.imageHp.frame;
        self.labelLevel.frame = CGRectMake(-118/2-2, 13, 30,18/2);
        
        anchorPointOfSkill = CGPointMake(100-50, 21);
    }
    else
    {
        [self.actionInst.view setFrame:CGRectMake(148/2, 95/2, 0, 0)];
        self.labelName.frame = CGRectMake(-51/2+4, -30/2-2, 102/2, 16/2);
        self.imageHp.frame = CGRectMake(-51/2, -8/2, 102/2, 16/2);
        self.labelHp.frame = self.imageHp.frame;
        originalHpRect = self.imageHp.frame;
        self.labelLevel.frame = CGRectMake(32, 13, 30, 18/2);
        anchorPointOfSkill = CGPointMake(2+50, 21);
    }
}

-(CGPoint)skillAnchor
{
    return anchorPointOfSkill;
}
/*
 设置参加者，主要是设置方向，位置，头像，血条等等
 */
-(void)setupActor:(BattleActor*)actor
{
    isAlly = actor.ally == 1;
    
    self.actor = actor;
    
    // 计算默认的普通攻击适用的技能配置项目
    if ( self.actor.type == 0 || self.actor.type == 4 )
        normalAttackSkillID = 10000;
    else if ( self.actor.type == 1 )
    {
        PetDef* pd = [[PetConfig share] getPetDefWithPetId:self.actor.mid];
        if ( pd )
        {
            PetDataDef* pdc = [[PetDataConfig share] getPetDataDefWithDataId:pd.petDataID];
            if ( pdc )
            {
                normalAttackSkillID = (int)pdc.normalAttackSkillID;
            }
        }
    }
    else if ( self.actor.type == 2 || self.actor.type == 3 || self.actor.type == 5 )
    {
        MobDef* md = [[MobConfig share] getMobDefById:self.actor.mid];
        if ( md )
        {
            MobDataDef* mdc = [[MobDataConfig share] getMobDataDefById:md.mobDataID];
            if ( mdc )
            {
                normalAttackSkillID = (int)mdc.normalAttackSkillID;
            }
        }
    }

    self.labelName.attributedText = [AttributeString nameFromActor:actor anima:YES];
    self.labelLevel.attributedText = [AttributeString stringWithString:[NSString stringWithFormat:@"Lv %d", (int)actor.level]
                                                              fontSize:10
                                                              fontBold:NO
                                                       foregroundColor:[UIColor whiteColor]
                                                           strokeColor:[UIColor blackColor]
                                                            strokeSize:1];
    maxHp = (int)actor.hp;
    currentHp = maxHp;
    [self changeHp:[NSNumber numberWithInt:0]];
    
    NSString* name = [self animaByType:AT_STANDBY];
    [self.actionInst playAnima:name isLoop:YES];
    [self arrangeViews];
    [self setupIcon];
}


-(NSString*)animaByType:(ANIMA_TYPE)at
{
    if ( self.actor == nil )
        return nil;

    NSString* suffix = @"_r";
    if (self.actor.ally == 1)
    {
        suffix = @"_l";
    }
    
    NSString* middle = @"";
    switch (at)
    {
        case AT_STANDBY:
            middle = @"ui_standby";
            break;
        case AT_DEAD:
            middle = @"ui_dead";
            break;
        case AT_DEFENDER_NORMAL:
        case AT_DEFENDER_SKILL:
            middle = @"ui_attacked";
            break;
        case AT_ATTACK_SKILL:
            middle = @"ui_attack_b";
            break;
        case AT_ATTACK_NORMAL:
            middle = @"ui_attack_a";
            break;
        default:
            break;
    }
    
    return [middle stringByAppendingString:suffix];
}

-(NSString*)animaBySkill:(int)sid withLv:(int)lv type:(ANIMA_TYPE)at
{
    NSString* suffix = @"_r";
    if (self.actor.ally == 1)
    {
        suffix = @"_l";
    }
    if ( sid == 0 )
    {
        sid = normalAttackSkillID;
        lv = 1;
    }
    SkillBase* sb = [[SkillConfig share] getSkillBaseWithTId:[NSNumber numberWithInt:(int)sid] withLevel:[NSNumber numberWithInt:(int)lv]];
    NSString* middle = nil;
    
    switch (at)
    {
        case AT_ATTACK_NORMAL:
        case AT_ATTACK_SKILL:
            if ( sb == nil )
                return nil;
            middle = sb.attackingAnimation ;
            break;
        case AT_ATTACK_SKILL_EFFECT:
            if ( sb == nil )
                return nil;
            middle = sb.attackingEffectAnimation; // @"effskill_bingqiu_cast"; //
            break;
        case AT_DEFENDER_NORMAL:
            if ( sb == nil )
                return nil;
            middle = sb.defendingAnimation;
            break;
        case AT_DEFENDER_SKILL:
            if ( sb == nil )
                return nil;
            middle = sb.defendingEffectAnimation;
            break;
        case AT_STANDBY:
            middle = @"ui_standby";
            break;
        case AT_DEAD:
            middle = @"ui_dead";
            break;
        case AT_HEAL:
            middle = @"ui_jiaxvejianxve";
            break;
        case AT_PREPARE_SKILL:
            middle = @"ui_jinengshuoming";
            break;
        case AT_DODGE:
        case AT_PARRY:
            middle = @"ui_DODGE-PARRY";
            break;
        case AT_CRITICAL:
            middle = @"ui_baoji";
            break;
        case AT_DEFENDER:
            break;
    }
    if ( middle )
        return [middle stringByAppendingString:suffix];
    return nil;
}

-(NSString*)animaByAttri:(int)aid
{
    AttriDef* ad = [[AttriConfig share] getAttriDefById:[NSNumber numberWithInt:aid]];
    if ( ad == nil )
        return nil;
    NSString* suffix = @"_r";
    if (self.actor.ally == 1)
    {
        suffix = @"_l";
    }

    return [[ad.effectAnimation copy] stringByAppendingString:suffix];
}

-(BOOL)animaContinurousByAttri:(int)aid
{
    AttriDef* ad = [[AttriConfig share] getAttriDefById:[NSNumber numberWithInt:aid]];
    if ( ad == nil )
        return false;
    return ad.effectContinurous;
}

-(NSString*)animaByBuff:(int)bid withLv:(int)blv
{
    BuffBase* bb = [[BuffConfig share] getBuffBaseWithTId:[NSNumber numberWithInt:bid] withLevel:[NSNumber numberWithInt:blv]];
    if ( bb == nil )
        return nil;
    return [self animaByAttri:(int)bb.attriId1];
}

-(BOOL)animaContinurousByBuff:(int)bid withLv:(int)blv
{
    BuffBase* bb = [[BuffConfig share] getBuffBaseWithTId:[NSNumber numberWithInt:bid] withLevel:[NSNumber numberWithInt:blv]];
    if ( bb == nil )
        return NO;
    return [self animaContinurousByAttri:(int)bb.attriId1];
    
}

// 挂上buff
-(BattleBuffAnimation*)addBuff:(int)buffID withLv:(int)lv
{
    // 创建buff动画
    BattleBuffAnimation* ret = nil ;
    for (BattleBuffAnimation* bi in arrayBuffs )
    {
        if ( bi.buffIcon.buffID == buffID )
        {
            [bi.buffIcon resetCount];
            ret = bi;
            break;
        }
    }
    
    if ( ret == nil )
    {
        ret = [[BattleBuffAnimation alloc] init:self.uiView buff:buffID buffLv:lv offset:CGRectZero];
        [arrayBuffs addObject:ret];
    }
    return ret;
}

// 取下buff
-(void)minusBuff:(int)buffID
{
    for (BattleBuffAnimation* bi in arrayBuffs )
    {
        if ( bi.buffIcon.buffID == buffID )
        {
            [bi.buffIcon clearCount];
            break;
        }
    }
}

// 调整显示buff的位置
-(void)refreshBuff
{
    int offset = 38/2;
    CGRect position;
    if ( self.actor && self.actor.ally == 1 )
    {
        position = CGRectMake(-24, 10, 20/2, 20/2);
    }
    else
    {
        offset = -offset;
        position = CGRectMake(14, 10, 20/2, 20/2);
    }
    
    NSMutableArray* toRemove = [[NSMutableArray alloc]init];
    int i = 0;
    for (BattleBuffAnimation* bi in arrayBuffs )
    {
        if ( bi.buffIcon.count > 0 )
        {
            CGRect r = CGRectMake(position.origin.x + offset * i, position.origin.y, position.size.width, position.size.height);
            [bi setFrame:r];
            [bi.buffIcon refresh];
            [[bi getCharaInst] update:0];
            i ++;
            //NSLog(@"Setting %d, %.0f", i, r.origin.x);
            
        }
        else
        {
            [toRemove addObject:bi];
        }
    }
    
    for(BattleBuffAnimation* bi in toRemove)
    {
        [bi finish];
        [[bi getCharaInst] stopAnimaAndCleanup];
        [bi clean];
    }
    
    [arrayBuffs removeObjectsInArray:toRemove];
}

-(OneTimeUseAnimation*)tempActionAnimation:(BOOL)loop delegate:(NSObject<SequenceDelegate>*)delegate
{
    CGRect offset;
    if ( self.actor && self.actor.ally == 1 )
    {
        offset = CGRectMake(43/2, 95/2, 0, 0);
        offset = CGRectMake(-46, 20, 0, 0);
    }
    else
    {
        offset = CGRectMake(138/2, 95/2, 0, 0);
        offset = CGRectMake(46, 20, 0, 0); //34,13
    }

    OneTimeUseAnimation* action = [[OneTimeUseAnimation alloc]init:self.uiView// self.actorView
                                                              loop:loop
                                                            offset:offset
                                                          delegate:delegate];
    return action;
}

-(OneTimeUseAnimation*)animationDodgeParry:(BOOL)isDodge delegate:(NSObject<SequenceDelegate>*)delegate
{
    OneTimeUseAnimation* taa = [self tempActionAnimation:NO delegate:delegate];
    BattleAnimationCommonLabel* label = [BattleAnimationCommonLabel create:self dodge:isDodge];
    [[taa getCharaInst] view];
    [[taa getCharaInst] attach:label toLayer:@"ui_DODGE-PARRY_ty"];
    label.frame = CGRectMake(-label.frame.size.width/2, -label.frame.size.height/2, label.frame.size.width, label.frame.size.height);
    label.transform = CGAffineTransformMakeScale(0, 0);
    return taa;
}

-(OneTimeUseAnimation*)animationChangeHp:(int)hp delegate:(NSObject<SequenceDelegate>*)delegate
{
    OneTimeUseAnimation* taa = [self tempActionAnimation:NO delegate:delegate];
    BattleAnimationHpChange* bahc = [BattleAnimationHpChange create:self hp:hp critical:NO];
    [[taa getCharaInst] view];
    [[taa getCharaInst] attach:bahc toLayer:@"ui_jiaxvejianxve_ty"];
    bahc.frame = CGRectMake(-bahc.frame.size.width/2, -bahc.frame.size.height/2, bahc.frame.size.width, bahc.frame.size.height);
    
    bahc.transform = CGAffineTransformMakeScale(0, 0);
    return taa;
}


-(OneTimeUseAnimation*)animationChangeHpInCritical:(int)hp delegate:(NSObject<SequenceDelegate>*)delegate
{
    OneTimeUseAnimation* taa = [self tempActionAnimation:NO delegate:delegate];
    BattleAnimationHpChange* bahc = [BattleAnimationHpChange create:self hp:hp critical:YES];
    [[taa getCharaInst] view];
    [[taa getCharaInst] attach:bahc toLayer:@"ui_baoji01"];
    bahc.frame = CGRectMake(-bahc.frame.size.width/2, -bahc.frame.size.height/2, bahc.frame.size.width, bahc.frame.size.height);
    bahc.transform = CGAffineTransformMakeScale(0, 0);
    return taa;
}

-(OneTimeUseAnimation*)animationSkillBoard:(int)sid withLv:(int)lv delegate:(NSObject<SequenceDelegate>*)delegate
{
    OneTimeUseAnimation* taa = [self tempActionAnimation:NO delegate:delegate];
    BattleAnimationSkillBoard* basb = [BattleAnimationSkillBoard create:self skill:sid withLv:lv];
    [[taa getCharaInst] view];
    [[taa getCharaInst] attach:basb toLayer:@"ui_jinengshuoming_ty"];
    basb.frame = CGRectMake(-basb.frame.size.width/2, -basb.frame.size.height/2, basb.frame.size.width, basb.frame.size.height);
    basb.transform = CGAffineTransformMakeScale(0, 0);
    return taa;
}


@end


@implementation BattleAnimationBase

-(id)init:(UIView*)view
{
    self = [super init];
    _view = view;
    _loop = NO;
    _calledOnce = NO;
    return self;
}

-(HpCharaInst*)getCharaInst
{
    return nil;
}

-(void)play:(NSString*)name
{
    HpCharaInst* inst = [self getCharaInst];
    inst.delegate = self;
    [inst playAnima:name isLoop:_loop];
}

-(void)finish
{
    //NSLog(@"Callback finish from hp %@, %@", self, self.delegate);
    if ( self.delegate )
        [self.delegate sequenceFinished:self];

}

-(void)finalClean
{
    
}

- (void)charaInst:(HpCharaInst*)inst onCustomEvent:(NSString*)event
{
    //NSLog(@"Event %@, %@, %@", event, self, inst.currAnimaName);
    if ( [event isEqualToString:kEventCommonName])
        [self finish];
}

- (void)charaInst:(HpCharaInst*)inst onAnimationEnd:(NSString *)anima
{
    if ( inst && !_loop )
    {
        [inst stopAnimaAndCleanup];
    }
    [self finalClean];
    //[self finish];
}

@end

@implementation BattleActionAnimation

-(void)play:(NSString *)name
{
    _calledOnce = NO;
    [super play:name];
    [(BattleActorView*)_view setupIcon];
}

-(HpCharaInst*)getCharaInst
{
    return ((BattleActorView*)_view).actionInst;
}

/*
- (void)charaInst:(HpCharaInst*)inst onCustomEvent:(NSString*)event
{
    //self.delegate = self.actionDelegate;
    //_calledOnce = YES;
    [self finish];
}
*/

- (void)charaInst:(HpCharaInst*)inst onAnimationEnd:(NSString *)anima
{
    // do nothing
    //[self finish];
}
@end

@implementation BattleBuffAnimation

-(id)init:(UIView*)view buff:(int)buff buffLv:(int)lv offset:(CGRect)offset
{
    self = [super init:view];
    self.inst = [HpCharaInst instWithFile:@"ui.chr"];
    self.inst.autoDestroy = NO;
    _baseView = [[UIView alloc]initWithFrame:offset];
    [_baseView addSubview:self.inst.view];
    [_view addSubview:_baseView];
    self.inst.view.frame = CGRectMake(0,0,offset.size.width, offset.size.height);
    
    BattleAnimationBuffIcon* bi = [BattleAnimationBuffIcon create:view buff:buff buffLv:lv];
    self.buffIcon = bi;
    return self;
}

-(void)play:(NSString *)name
{
    HpCharaInst* inst = [self getCharaInst];
    inst.delegate = self;
    [self.buffIcon refresh];
    [inst playAnima:name isLoop:NO];
    [self.inst unattach:self.buffIcon];
    [self.inst attach:self.buffIcon toLayer:@"ui_buff_ty"];
    CGRect rect = self.buffIcon.frame;
    self.buffIcon.frame = CGRectMake(0,0,rect.size.width, rect.size.height);
}

-(void)setFrame:(CGRect)frame
{
    _baseView.frame = frame;
}

-(void)clean
{
    [_baseView removeFromSuperview];
    
    if ( self.attachedInst )
    {
        HpCharaInst* inst = [self.attachedInst getCharaInst];
        inst.view.frame = CGRectZero;
        [inst stopAnimaAndCleanup];
        self.attachedInst = nil;
    }
}

-(HpCharaInst*)getCharaInst
{
    return self.inst;
}

- (void)charaInst:(HpCharaInst*)inst onAnimationEnd:(NSString *)anima
{
    // do nothing
}


@end

@implementation OneTimeUseAnimation

-(id)init:(UIView*)view loop:(BOOL)loop offset:(CGRect)offset delegate:(NSObject<SequenceDelegate>*)dele
{
    self = [super init:view];
    self.inst = [HpCharaInst instWithFile:@"ui.chr"];
    self.inst.autoDestroy = YES;
    self.delegate = dele;
    self.invocation = nil;
    [_view addSubview:self.inst.view];
    [self.inst.view setFrame:offset];
    _loop = loop;
    return self;
}

-(HpCharaInst*)getCharaInst
{
    return self.inst;
}

-(void)play:(NSString *)name
{
    if ( self.invocation )
    {
        [self.invocation invoke];
    }
    
    [super play:name];

    self.inst.autoDestroy = YES;
}

-(void)setFrom:(CGPoint)from to:(CGPoint)to
{
    float len = sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y));
    float scale = len / 228;
    float angle = atan2(to.y - from.y , to.x - from.x) ;
    if ( to.x < from.x )
        angle -= M_PI;
    CGAffineTransform trans = CGAffineTransformMakeScale(scale, 1.0f);
    trans = CGAffineTransformConcat(trans, CGAffineTransformMakeRotation(angle));
    
    //_inst.view.center = from;
    _inst.view.frame = CGRectMake(from.x,from.y, 0, 0);
    //_inst.view.backgroundColor = [UIColor lightGrayColor];
    _inst.view.transform = trans;
    
}

-(void)center
{
    HpCharaInst* inst = [self getCharaInst];
    CGRect frame = _view.frame;
    CGRect animationFrame = inst.view.frame;
    CGPoint pt = CGPointMake((frame.size.width - animationFrame.size.width)/2, (frame.size.height - animationFrame.size.height)/2);
    
    inst.view.frame = CGRectMake(pt.x, pt.y, animationFrame.size.width, animationFrame.size.height);
}
@end

@implementation TwoPointAnimation
-(id)init:(UIView*)view offset:(CGRect)offset delegate:(NSObject<SequenceDelegate>*)delegate
{
    // 修改的时候发现这个方法为实现  就补了个空  不知道啥意思
    // 估计要修改
    self = [super init];
    return self;
}

-(id)init:(UIView*)view loop:(BOOL)loop offset:(CGRect)offset delegate:(NSObject<SequenceDelegate>*)dele
{
    UIView* baseView = [[UIView alloc]init];
    self = [super init:baseView loop:NO offset:offset delegate:dele];
    [view addSubview:baseView];
    [baseView setFrame:offset];
    _baseView = baseView;
    return self;
}

-(void)setFrom:(CGPoint)from to:(CGPoint)to
{
    if ( _baseView == nil )
        return;

    float len = sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y));
    float scale = len / 228;
    float angle = atan2(to.y - from.y , to.x - from.x) ;
    
    CGAffineTransform trans = CGAffineTransformMakeScale(scale, 1.0f);
    
    trans = CGAffineTransformConcat(trans, CGAffineTransformMakeRotation(angle));
    _baseView.center = from;
    _baseView.frame = CGRectMake(from.x, from.y, _baseView.frame.size.width, _baseView.frame.size.height);
    _inst.view.center = CGPointZero;
    _inst.view.bounds = CGRectMake(0, 0, _inst.view.frame.size.width, _inst.view.frame.size.height);
    _baseView.transform = CGAffineTransformMakeRotation(angle);
    
}

-(void)finalClean
{
    if ( _inst )
    {
        [_inst stopAnimaAndCleanup];
        _inst.delegate = nil;
        self.inst = nil;
    }
    [_baseView removeFromSuperview];
    _baseView = nil;
}

@end