//
//  EquipmentViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "QQEquipBtnDefault.h"

@interface EquipViewController : BaseViewController<QQEquipBtnDefaultDelegate>

@property (weak, nonatomic) IBOutlet UILabel *attackLabel;
@property (weak, nonatomic) IBOutlet UILabel *armorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pdefLabel;
@property (weak, nonatomic) IBOutlet UILabel *mdefLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property (weak, nonatomic) IBOutlet UILabel *excavateLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *probeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *miningForceLabel;

@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *weaponView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *headView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *bodyView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *handView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *backView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *footView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *dectectorView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *pickaxeView;

@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon01;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon02;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon03;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon04;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon05;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon06;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon07;
@property (weak, nonatomic) IBOutlet UIAttributeIcon* attriIcon08;

-(void)setEquipViewData;        // 一般用于打开view的时候用
-(void)updateEquipViewData;     // 装备出现变更的时候调用
@end
