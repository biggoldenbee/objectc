//
//  UpGradeEquipViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"
#import "QQEquipBtnDefault.h"

@class QQProgressView;

@interface UpMainAttriViewController : BaseViewController<QQEquipBtnDefaultDelegate>
{
    NSInteger costMoney;
    NSInteger addExp;
}

@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem01;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem02;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem03;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem04;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem05;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *equipItem06;

@property (weak, nonatomic) IBOutlet UIImageView *equipIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *equipColorImage;

@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon;

@property (weak, nonatomic) IBOutlet UILabel *costMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *attriLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *attriLevelForUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *attriValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *attriValueForUpLabel;
@property (weak, nonatomic) IBOutlet QQProgressView *attriProgressView;

-(void)showMainAttriView:(NSDictionary *)data;

-(void)setOtherEquips:(NSArray*)equipIds;
@end
