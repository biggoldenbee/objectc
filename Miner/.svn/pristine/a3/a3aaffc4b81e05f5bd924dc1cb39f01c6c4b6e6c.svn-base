//
//  StageSubViewController.h
//  Miner
//
//  Created by zhihua.qian on 15/1/7.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@interface StageInfoViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stageNameLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *stageQuickFightingOutputCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *stageQuickFightingSpendLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageQuickFightingNumLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *stageQuickBossFightingOutputCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *stageQuickBossFightingRaidsTicketsLabel;

-(void)setDataInfoInViewControllers:(NSNumber*)mapId;
-(void)updateStageInfoView;
-(void)closeStageInfoView;
@end
