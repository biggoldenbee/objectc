//
//  SkillTableViewCell.h
//  Miner
//
//  Created by zhihua.qian on 14-11-25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "QQSkillUpgradeBtn.h"

@interface SkillTableViewCell01 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *unSelSkillIconImage;
@property (weak, nonatomic) IBOutlet UILabel *unSelSkillLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSelSkillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSelSkillValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSelSkillDescLabel;
@property (weak, nonatomic) IBOutlet QQSkillUpgradeBtn *unSelSkillUpView;

@property (nonatomic, strong) NSNumber* skillId;
@property (nonatomic, strong) NSNumber* skillLv;
@property (nonatomic, assign) NSInteger sectionInTableView;
@property (nonatomic, assign) NSInteger rowInTableView;

-(void)setDataInfoForAllControllers:(NSNumber*)skillId skillLV:(NSNumber*)skillLv superViewController:(BaseViewController*)vc;
@end
