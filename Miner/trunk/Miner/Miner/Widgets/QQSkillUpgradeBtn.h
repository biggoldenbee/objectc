//
//  QQSkillUpgradeBtn.h
//  Miner
//
//  Created by zhihua.qian on 15/1/22.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Normal_State,
    Click_State,
    Select_State,
    Disable_State,
}
QQSKILL_UP_BTN_STATE;

@interface QQSkillUpgradeBtn : UIView
{
    NSInteger _NeedMoney;
    NSInteger _SkillPoint;
    NSInteger _NeedLv;
    
    NSInteger _PointCount;
    NSInteger _TargetLevel;
}

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *pointTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyIcon;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLvLabel;

-(void)initializeSkillUpViewWithId:(NSNumber*)skillId withLv:(NSNumber*)skillLv withPetId:(NSNumber*)petId;
-(void)setDataWithMoney:(NSInteger)money withPoint:(NSInteger)point;
-(void)setBtnControllerState:(QQSKILL_UP_BTN_STATE)state;
@end
