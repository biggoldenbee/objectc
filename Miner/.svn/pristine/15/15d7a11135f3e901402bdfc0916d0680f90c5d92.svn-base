//
//  PetViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "UIToolTipImageView.h"
#import "QQEquipBtnDefault.h"

@interface PetViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

// pet equipment
@property (weak, nonatomic) IBOutlet UIView *petEquipView;

@property (weak, nonatomic) IBOutlet UILabel *attackLabel;
@property (weak, nonatomic) IBOutlet UILabel *armorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pdefLabel;
@property (weak, nonatomic) IBOutlet UILabel *mdefLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property (weak, nonatomic) IBOutlet UILabel *probeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *excavateLabel;

@property (weak, nonatomic) IBOutlet UILabel *petLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *combatLabel;

@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *weaponView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *headView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *bodyView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *handView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *backView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *footView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *dectectorView;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *pickaxeView;

@property (weak, nonatomic) IBOutlet UIView *progressExpView;

@property (weak, nonatomic) IBOutlet UIImageView *petImage;
@property (weak, nonatomic) IBOutlet UIImageView *petPreImage;
@property (weak, nonatomic) IBOutlet UIImageView *petNextImage;

@property (weak, nonatomic) IBOutlet UIButton *choosePreBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseNextBtn;

@property (weak, nonatomic) IBOutlet UIImageView *activeImage;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;

@property (weak, nonatomic) IBOutlet UIButton *equipmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *skillBtn;

// pet skill
@property (weak, nonatomic) IBOutlet UIView *petSkillView;
@property (weak, nonatomic) IBOutlet UITableView *petSkillTableView;

@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon1;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon2;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon3;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon4;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon5;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon6;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon7;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon8;



-(void)updatePetViewAllControllers;
-(void)updatePetEquipViewControllers;
-(void)updatePetSkillViewAllControllers;
-(void)updatePetActiveBtnControllers;

-(void)didSelectRowInSection:(NSInteger)section atRow:(NSInteger)row;
-(NSNumber*)getCurrentPetId;
@end
