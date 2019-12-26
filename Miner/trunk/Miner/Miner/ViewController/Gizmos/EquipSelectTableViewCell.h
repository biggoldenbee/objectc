//
//  EquipSelectTableViewCell.h
//  Miner
//
//  Created by zhihua.qian on 15-1-4.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EquipSelectTableViewCell : UITableViewCell
+(void)resetSelectCount;

@property (strong, nonatomic) IBOutlet UIImageView *equipStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *equipIconImage;
@property (strong, nonatomic) IBOutlet UILabel *equipLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipGainExpLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;

-(void)setDataWithObject:(NSArray *)data;
@end
