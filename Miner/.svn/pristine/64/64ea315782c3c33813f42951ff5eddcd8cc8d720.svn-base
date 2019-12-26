//
//  SkillTableViewCell.m
//  Miner
//
//  Created by zhihua.qian on 14-11-25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "SkillTableViewCell01.h"
#import "Skill.h"
#import "StringConfig.h"
#import "GameUtility.h"
#import "GameObject.h"
#import "SkillViewController.h"
#import "PetViewController.h"

@interface SkillTableViewCell01 ()

@property (nonatomic, weak) SkillViewController* skillVC;
@property (nonatomic, weak) PetViewController* petVC;

@end

@implementation SkillTableViewCell01

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)setDataInfoForAllControllers:(NSNumber*)skillId skillLV:(NSNumber*)skillLv superViewController:(BaseViewController*)vc
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
    self.skillLv = skillLv;

    SkillBase* skillBase = [[SkillConfig share] getSkillBaseWithTId:[self skillId] withLevel:[self skillLv]];
    
    UIImage* skillIcon = [GameUtility imageNamed:[skillBase skillIcon]];
    [[self unSelSkillIconImage] setImage:skillIcon];
    
    NSString* skillLevel = [NSString stringWithFormat:@"Lv.%@", [skillLv stringValue]];
    [[self unSelSkillLvLabel] setText:skillLevel];
    
    NSString* skillName = [[StringConfig share] getLocalLanguage:[skillBase skillName]];
    [[self unSelSkillNameLabel] setText:skillName];
    
    NSString* skillCD = [[NSNumber numberWithInteger:[skillBase skillCD]] stringValue];
    [[self unSelSkillValueLabel] setText:[NSString stringWithFormat:@"Skill CD:%@",skillCD]];
    
    NSString* skillDesc = [[StringConfig share] getLocalLanguage:[skillBase skillDesc]];
    [[self unSelSkillDescLabel] setText:skillDesc];
    
    [[self unSelSkillUpView] initializeSkillUpViewWithId:[self skillId] withLv:[self skillLv] withPetId:([self petVC] == nil ? [NSNumber numberWithInt:0] : [[self petVC] getCurrentPetId])];
}

- (IBAction)onUnselCellClicked:(id)sender
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
@end
