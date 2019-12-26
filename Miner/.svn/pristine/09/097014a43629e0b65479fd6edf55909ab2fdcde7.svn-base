//
//  QQSkillBtnUsing.h
//  Miner
//
//  Created by zhihua.qian on 15/1/8.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Skill;
@class SkillViewController;

@interface QQSkillBtnUsing : UIView

@property (weak, nonatomic) IBOutlet UIButton *skillBtnUsingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *skillBtnUsingLvImage;
@property (weak, nonatomic) IBOutlet UILabel *skillBtnUsingLvLabel;

-(void)resetAllControllers;
-(void)setDataForAllControllersWithSkill:(Skill*)skill atSlot:(int)slot supViewController:(SkillViewController*)vc;
-(void)openTheLockSlot;

-(NSNumber*)getSkillIdentifier;

-(void)setSelectedState:(BOOL)isSelected;
@end
