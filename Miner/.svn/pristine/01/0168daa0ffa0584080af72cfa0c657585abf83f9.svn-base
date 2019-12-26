//
//  SkillTableViewCell02.m
//  Miner
//
//  Created by zhihua.qian on 15/1/9.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "SkillTableViewCell02.h"
#import "Skill.h"
#import "SkillConfig.h"
#import "GameUtility.h"
#import "StringConfig.h"
#import "GameObject.h"
#import "SkillViewController.h"
#import "PetViewController.h"

@interface SkillTableViewCell02 ()

@property (nonatomic, weak) SkillViewController* skillVC;
@property (nonatomic, weak) PetViewController* petVC;

@end

@implementation SkillTableViewCell02

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataInfoForAllControllers:(NSNumber*)skillId withLv:(NSNumber*)lv superViewController:(BaseViewController*)vc
{
    if ([vc isKindOfClass:[SkillViewController class]])
    {
        self.skillVC = (SkillViewController*)vc;
    }
    else
    {
        self.petVC = (PetViewController*)vc;
    }
    self.skillId = skillId;
    self.skillLv = lv;
    
    SkillBase* skillBase = [[SkillConfig share] getSkillBaseWithTId:[self skillId] withLevel:lv];
    
    UIImage* skillIcon = [GameUtility imageNamed:[skillBase skillIcon]];
    [[self selSkillIconImage] setImage:skillIcon];
    
    NSString* skillLevel = [NSString stringWithFormat:@"Lv.%@", [lv stringValue]];
    [[self selSkillLvLabel] setText:skillLevel];
    
    NSString* skillName = [[StringConfig share] getLocalLanguage:[skillBase skillName]];
    [[self selSkillNameLabel] setText:skillName];
    
    NSString* skillCD = [[NSNumber numberWithInteger:[skillBase skillCD]] stringValue];
    [[self selSkillValueLabel] setText:[NSString stringWithFormat:@"Skill CD:%@",skillCD]];
    
    NSString* skillDesc = [[StringConfig share] getLocalLanguage:[skillBase skillDesc]];
    [[self selSkillDescLabel] setText:skillDesc];
    
    NSNumber* nextLv = [NSNumber numberWithInteger:[lv integerValue]+1];
    SkillBase* nextSkillBase    = [[SkillConfig share] getSkillBaseWithTId:[self skillId] withLevel:nextLv];
    NSString* skillNextDesc     = [[StringConfig share] getLocalLanguage:[nextSkillBase skillDesc]];
    [[self selSkillNextDescLabel] setText:skillNextDesc];
    
    if (self.petVC != nil)
    {
        [[self selSkillUnloadBtn] setHidden:YES];
        [[self selSkillLoadBtn] setHidden:YES];
    }
    else
    {
        [self resetAssembleBtn:skillBase];
    }
    
    [[self selSkillUpView] initializeSkillUpViewWithId:skillId withLv:lv withPetId:([self petVC] == nil ? [NSNumber numberWithInt:0] : [[self petVC] getCurrentPetId])];
}
-(void)resetAssembleBtn:(SkillBase*)base
{
    if ([self sectionInTableView] == 0)
    {
        [[self selSkillUnloadBtn] setHidden:NO];
        [[self selSkillLoadBtn] setHidden:YES];
    }
    else
    {
        [[self selSkillUnloadBtn] setHidden:YES];
        [[self selSkillLoadBtn] setHidden:NO];
        NSNumber* heroLv = [[[GameObject sharedInstance] player] heroLevel];
        NSInteger needLv = [base needHeroLV];
        if ([heroLv integerValue] > needLv)
        {
            [[self selSkillLoadBtn] setEnabled:YES];
        }
        else
        {
            [[self selSkillLoadBtn] setEnabled:NO];
        }
    }
}


- (IBAction)onUnloadClicked:(id)sender
{
    NSLog(@"卸载技能，╮(╯▽╰)╭！");
    [[self skillVC] unloadSkillWithId:[self skillId]];
    
}
- (IBAction)onLoadClicked:(id)sender
{
    NSLog(@"装备技能，\(^o^)/！");
    [[self skillVC] loadSkillWithId:[self skillId]];
}
- (IBAction)onCellClicked:(id)sender
{
    if ([self skillVC])
    {
        [[self skillVC] didSelectRowInSection:[self sectionInTableView] atRow:[self rowInTableView]];
    }
    else
    {
        [[self petVC] didSelectRowInSection:[self sectionInTableView] atRow:[self rowInTableView]];
    }
}
- (IBAction)onSelUpgradeClicked:(id)sender
{
}
@end
