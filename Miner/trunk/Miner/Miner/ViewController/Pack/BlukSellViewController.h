//
//  BlukSellViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@class Bag;

@interface BlukSellViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *whiteEquipLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenEquipLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueEquipLabel;
@property (strong, nonatomic) IBOutlet UILabel *purpleEquipLabel;
@property (strong, nonatomic) IBOutlet UILabel *orangeEqupLabel;

@property (strong, nonatomic) NSMutableArray* whiteEquips;
@property (strong, nonatomic) NSMutableArray* greenEquips;
@property (strong, nonatomic) NSMutableArray* blueEquips;
@property (strong, nonatomic) NSMutableArray* purpleEquips;
@property (strong, nonatomic) NSMutableArray* orangeEquips;

@property (nonatomic, weak) Bag* bag;

-(void)updateBlukViewData;
@end
