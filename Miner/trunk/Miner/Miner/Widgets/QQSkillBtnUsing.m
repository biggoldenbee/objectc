//
//  QQSkillBtnUsing.m
//  Miner
//
//  Created by zhihua.qian on 15/1/8.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "QQSkillBtnUsing.h"
#import "GameUtility.h"
#import "Skill.h"
#import "SkillViewController.h"

#define DEFAULT_IMAGE_NAME @"skill_bar1_c"

@interface QQSkillBtnUsing ()

@property (assign, nonatomic) int row;
@property (strong, nonatomic) Skill* skill;
@property (weak, nonatomic) SkillViewController* skillVC;

@end

@implementation QQSkillBtnUsing

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)resetAllControllers
{
    self.skill = nil;
    self.skillVC = nil;
    [[self skillBtnUsingBtn] setSelected:NO];
    UIImage* skillIcon = [GameUtility imageNamed:DEFAULT_IMAGE_NAME];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateNormal];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateHighlighted];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateSelected];
    
    [[self skillBtnUsingLvImage] setHidden:YES];
    [[self skillBtnUsingLvLabel] setHidden:YES];
}

-(void)setDataForAllControllersWithSkill:(Skill*)skill atSlot:(int)slot supViewController:(SkillViewController*)vc
{
    self.row = slot;
    self.skillVC = vc;
    self.skill = skill;
    [[self skillBtnUsingBtn] setSelected:NO];
    UIImage* skillIcon = [GameUtility imageNamed:[[self skill] skillIcon]];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateNormal];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateHighlighted];
    [[self skillBtnUsingBtn] setImage:skillIcon forState:UIControlStateSelected];
    NSString* strSkillLv = [NSString stringWithFormat:@"Lv.%@", [[skill skillLv] stringValue]];
    [[self skillBtnUsingLvLabel] setText:strSkillLv];
    
    [[self skillBtnUsingLvImage] setHidden:NO];
    [[self skillBtnUsingLvLabel] setHidden:NO];
}

-(void)openTheLockSlot
{
    [[self skillBtnUsingBtn] setSelected:NO];
    [[self skillBtnUsingBtn] setImage:nil forState:UIControlStateNormal];
    [[self skillBtnUsingBtn] setImage:nil forState:UIControlStateHighlighted];
    [[self skillBtnUsingBtn] setImage:nil forState:UIControlStateSelected];
    
    [[self skillBtnUsingLvImage] setHidden:YES];
    [[self skillBtnUsingLvLabel] setHidden:YES];
}

- (IBAction)onSkillClicked:(id)sender
{
    if ([self skill] == nil)
    {
        return;
    }
    
    if ( [[self skillBtnUsingBtn] isSelected])
    {
        [[self skillBtnUsingBtn] setSelected:NO];
    }
    else
    {
        [[self skillBtnUsingBtn] setSelected:YES];
    }
    [[self skillVC] didSelectRowInSection:0 atRow:[self row]];
}

-(NSNumber*)getSkillIdentifier
{
    return [[self skill] skillTId];
}
-(void)setSelectedState:(BOOL)isSelected
{
    [[self skillBtnUsingBtn] setSelected:isSelected];
}
@end
