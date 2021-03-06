//
//  HallViewController.h
//  testMiner
//
//  Created by zhihua.qian on 14-11-27.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "BaseViewController.h"

@class QQProgressView;

@interface HallViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *viplvLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIView *tiCoinView;
@property (weak, nonatomic) IBOutlet UIView *diamondView;

@property (weak, nonatomic) IBOutlet UIButton *portBtn;
@property (weak, nonatomic) IBOutlet UIButton *mineBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton *packBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@property (weak, nonatomic) IBOutlet QQProgressView *viplevelProgress;
@property (weak, nonatomic) IBOutlet UIView *contentView;

-(void)showHallView;
-(void)updateHallView;
@end
