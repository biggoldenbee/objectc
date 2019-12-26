//
//  SkillTableViewCell02.h
//  Miner
//
//  Created by zhihua.qian on 15/1/9.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "QQSkillUpgradeBtn.h"

@interface SkillTableViewCell02 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selSkillIconImage;
@property (weak, nonatomic) IBOutlet UILabel *selSkillLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *selSkillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *selSkillValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *selSkillDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *selSkillNextDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *selSkillUnloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *selSkillLoadBtn;
@property (weak, nonatomic) IBOutlet QQSkillUpgradeBtn *selSkillUpView;

@property (nonatomic, strong) NSNumber* skillId;
@property (nonatomic, strong) NSNumber* skillLv;
@property (nonatomic, assign) NSInteger sectionInTableView;
@property (nonatomic, assign) NSInteger rowInTableView;

-(void)setDataInfoForAllControllers:(NSNumber*)skillId withLv:(NSNumber*)lv superViewController:(BaseViewController*)vc;
@end
