//
//  UpSubAttriViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@class QQEquipBtnDefault;

@interface CostItem : NSObject
@property (nonatomic, strong) NSNumber* itemIId;
@property (nonatomic, assign) NSInteger itemNum;
@end


@interface UpSubAttriViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel* moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView* equipStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *equipIconImage;

@property (weak, nonatomic) IBOutlet UILabel* subAttriLevelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subAttriLevelArrowImage;
@property (weak, nonatomic) IBOutlet UILabel* subNextAttriLevelLabel;

@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item1View;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item2View;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item3View;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item4View;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item5View;
@property (weak, nonatomic) IBOutlet QQEquipBtnDefault *item6View;

@property (strong, nonatomic) NSNumber* subAttri1Identifier;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri1IconImage;
@property (weak, nonatomic) IBOutlet UILabel* subAttri1ValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri1ArrowImage;
@property (weak, nonatomic) IBOutlet UILabel* subNextAttri1ValueLabel;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon1;

@property (strong, nonatomic) NSNumber  *subAttri2Identifier;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri2IconImage;
@property (weak, nonatomic) IBOutlet UILabel *subAttri2ValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri2ArrowImage;
@property (weak, nonatomic) IBOutlet UILabel* subNextAttri2ValueLabel;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon2;

@property (strong, nonatomic) NSNumber  *subAttri3Identifier;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri3IconImage;
@property (weak, nonatomic) IBOutlet UILabel *subAttri3ValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subAttri3ArrowImage;
@property (weak, nonatomic) IBOutlet UILabel* subNextAttri3ValueLabel;
@property (weak, nonatomic) IBOutlet UIAttributeIcon *attributeIcon3;

@property (strong, nonatomic) IBOutlet UIButton *subAttriBtn;

-(void)setDataInfoInViewControllers:(NSDictionary *)data;

-(void)updateEquipInfo:(NSNumber*)equipId;
@end
