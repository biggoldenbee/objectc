//
//  CommonTableViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "UIToolTipImageView.h"

@interface EquipChangeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topViewRectView;
@property (weak, nonatomic) IBOutlet UIView *bottomViewRectView;

@property (weak, nonatomic) IBOutlet UILabel *textLvLabel;
@property (weak, nonatomic) IBOutlet UIImageView *equipStarIcon;
@property (weak, nonatomic) IBOutlet UIImageView *equipIcon;
@property (weak, nonatomic) IBOutlet UILabel *equipNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *equipMainIcon;
@property (weak, nonatomic) IBOutlet UIImageView *equipSub1Icon;
@property (weak, nonatomic) IBOutlet UIImageView *equipSub2Icon;
@property (weak, nonatomic) IBOutlet UIImageView *equipSub3Icon;
@property (weak, nonatomic) IBOutlet UIImageView *equipGodIcon;
@property (weak, nonatomic) IBOutlet UILabel *equipMainValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipSub1ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipSub2ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipSub3ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipGodValueLabel;

@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon1;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon2;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon3;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon4;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon5;

@property (weak, nonatomic) IBOutlet UITableView *changeTableview;

-(void)setEquipChangeViewData:(NSDictionary *)data;   // 用来初始化

-(void)changEquipment:(NSDictionary*)params;        // 当cell中点击wear按钮时，被调用的方法（此时tableview为显示更换装备）

-(void)closeEquipChangeView;
@end
