//
//  EquipSelectViewController.h
//  Miner
//
//  Created by zhihua.qian on 15-1-4.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@interface EquipSelectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger costMoney;
    NSInteger addExp;
}

@property (strong, nonatomic) IBOutlet UILabel *currentLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *willChangeLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *needCostMoneyLabel;
@property (strong, nonatomic) IBOutlet UITableView *selectTabelView;


-(void)setDataForSelectViewControllers:(NSDictionary*)data;
-(void)scrollToTopRowAtIndexPath;

-(void)addObjectToList:(NSDictionary*)params;       // 当cell被选中时，被调用的方法（此时tableview为显示多选装备）
-(void)substractObjectToList:(NSDictionary*)params; // 当cell被撤销时，被调用的方法（此时tableview为显示多选装备）
@end
