//
//  QQSkillUpgradeBtn.m
//  Miner
//
//  Created by zhihua.qian on 15/1/22.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "QQSkillUpgradeBtn.h"
#import "SkillConfig.h"
#import "GameObject.h"
#import "PackageManager.h"

@interface QQSkillUpgradeBtn ()

@property (assign, nonatomic) QQSKILL_UP_BTN_STATE currentState;
@property (assign, nonatomic) NSNumber* skillId;
@property (assign, nonatomic) NSNumber* petId;

@end


@implementation QQSkillUpgradeBtn

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"QQSkillUpgradeBtnView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initializeSkillUpViewWithId:(NSNumber*)skillId withLv:(NSNumber*)skillLv withPetId:(NSNumber*)petId
{
    self.skillId = skillId;
    self.petId = petId;
    
    SkillBase* skillBase = [[SkillConfig share] getSkillBaseWithTId:skillId withLevel:skillLv];
    _NeedMoney      = [[skillBase getItemNumWithId:[NSNumber numberWithInt:1]] integerValue];
    _SkillPoint     = [[skillBase getItemNumWithId:[NSNumber numberWithInt:8]] integerValue];
    _NeedLv         = [skillBase needHeroLV];
    if ([petId integerValue] == 0)
    {
        _TargetLevel = [[[[GameObject sharedInstance] player] heroLevel] integerValue];
    }
    else
    {
        _TargetLevel = [[[[[GameObject sharedInstance] player] getPetWithIdentifier:petId] petLevel] integerValue];
    }
    _PointCount     = [[[[GameObject sharedInstance] player] heroSkillPoint] integerValue];
    
    BOOL isMax = [[SkillConfig share] checkSkillIsMaxWithId:skillId andLevel:skillLv];
    if (isMax)
    {
        [self setBtnControllerState:Disable_State];
        return;
    }
    
    [self setDataWithMoney:_NeedMoney withPoint:_SkillPoint];
    
    NSNumber* nextLv = [NSNumber numberWithInteger:[skillLv integerValue]+1];
    NSInteger nextNeedLv = [[[SkillConfig share] getSkillBaseWithTId:skillId withLevel:nextLv] needHeroLV];
    if (_TargetLevel > nextNeedLv && _PointCount > _SkillPoint)
    {
        [self setBtnControllerState:Normal_State];
        return;
    }
    
    [self setBtnControllerState:Select_State];
}

-(void)setDataWithMoney:(NSInteger)money withPoint:(NSInteger)point
{
    [[self moneyLabel] setText:[NSString stringWithFormat:@"%lu", money]];
    [[self pointLabel] setText:[NSString stringWithFormat:@"%lu", point]];
}

-(void)setBtnControllerState:(QQSKILL_UP_BTN_STATE)state
{
    self.currentState = state;
    switch (state)
    {
        case Normal_State:
            [self normalState];
            break;
        case Click_State:
            [self clickState];
            break;
        case Select_State:
            [self selectState];
            break;
        case Disable_State:
            [self disableState];
            break;
    }
}

-(void)normalState
{
    [[self upgradeBtn] setEnabled:YES];
    [[self upgradeBtn] setSelected:NO];
    [[self upgradeBtn] setHidden:NO];
    
    [[self pointTextLabel] setHidden:NO];
    [[self pointLabel] setHidden:NO];
    
    [[self moneyIcon] setHidden:NO];
    [[self moneyLabel] setHidden:NO];
    
    [[self textLabel] setHidden:NO];
    [[self textLabel] setTextColor:[UIColor whiteColor]];
    
    [[self maxLvLabel] setHidden:YES];
}

-(void)clickState
{
    [[self upgradeBtn] setEnabled:YES];
    [[self upgradeBtn] setSelected:NO];
    [[self upgradeBtn] setHidden:NO];
    
    [[self pointTextLabel] setHidden:NO];
    [[self pointLabel] setHidden:NO];
    
    [[self moneyIcon] setHidden:NO];
    [[self moneyLabel] setHidden:NO];
    
    [[self textLabel] setHidden:NO];
    [[self textLabel] setTextColor:[UIColor whiteColor]];
    
    [[self maxLvLabel] setHidden:YES];
}

-(void)selectState
{
    [[self upgradeBtn] setEnabled:YES];
    [[self upgradeBtn] setSelected:YES];
    [[self upgradeBtn] setHidden:NO];
    
    [[self pointTextLabel] setHidden:NO];
    [[self pointLabel] setHidden:NO];
    
    [[self moneyIcon] setHidden:NO];
    [[self moneyLabel] setHidden:NO];
    
    [[self textLabel] setHidden:NO];
    [[self textLabel] setTextColor:[UIColor whiteColor]];
    
    [[self maxLvLabel] setHidden:YES];
}

-(void)disableState
{
    [[self upgradeBtn] setEnabled:NO];
    [[self upgradeBtn] setSelected:NO];
    [[self upgradeBtn] setHidden:NO];
    
    [[self pointTextLabel] setHidden:YES];
    [[self pointLabel] setHidden:YES];
    
    [[self moneyIcon] setHidden:YES];
    [[self moneyLabel] setHidden:YES];
    
    [[self textLabel] setHidden:YES];
    
    [[self maxLvLabel] setHidden:NO];
}

- (IBAction)onUpgradeClicked:(id)sender
{
    if ([self currentState] == Normal_State)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[self skillId] forKey:@"SID"];
        if ([[self petId] integerValue] != 0)
        {
            [tempDict setObject:[self petId] forKey:@"PID"];
        }
        [[PackageManager sharedInstance] upgradeSkillRequest:tempDict];
    }
}
@end
