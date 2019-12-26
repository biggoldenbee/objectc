//
//  SkillViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SkillViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *oneSkillView;
@property (weak, nonatomic) IBOutlet UIView *secondSkillView;
@property (weak, nonatomic) IBOutlet UIView *thirdSkillView;
@property (weak, nonatomic) IBOutlet UIView *fourSkillView;
@property (weak, nonatomic) IBOutlet UILabel *skillPointLabel;

@property (strong, nonatomic) IBOutlet UITableView *skillTableView;

-(void)setAllViewControllers;   // 初始数据到界面
-(void)updateSkills;            // 更新界面

-(void)didSelectRowInSection:(NSInteger)section atRow:(NSInteger)row;

-(void)unloadSkillWithId:(NSNumber*)skillId;
-(void)loadSkillWithId:(NSNumber*)skillId;
@end
