//
//  StageViewController.h
//  Miner
//
//  Created by zhihua.qian on 15-1-6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

typedef enum
{
    Type_None,
    Type_Stage,
    Type_Map,
}
STAGE_TYPE;

@interface StageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *stageBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UITableView *stageTableView;

-(void)updateStageViewAllControllers;
@end
