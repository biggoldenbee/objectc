//
//  StageTableViewCell.h
//  Miner
//
//  Created by zhihua.qian on 15-1-6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapDef;

@interface StageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stageCellBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellNoRewardImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellRewardImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellEffectImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellActiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellActiveBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *stageCellRewardBgImage;

@property (weak, nonatomic) IBOutlet UILabel *stageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageMobLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageEnterLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageMobLvTextLabel;
@property (weak, nonatomic) IBOutlet UIView *animationView;

-(void)setupDataWithDef:(MapDef*)def isCurrentMap:(NSNumber*)curMapId isMaxMap:(NSNumber*)maxMapId;

@end
