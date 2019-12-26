//
//  CommonTableViewCell.h
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Equipment;

@interface EquipChangeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *starImage;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;

@property (strong, nonatomic) IBOutlet UILabel *mainAttriLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub1AttriLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub2AttriLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub3AttriLabel;
@property (strong, nonatomic) IBOutlet UILabel *godAttriLabel;

@property (strong, nonatomic) IBOutlet UILabel *mainAttriValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub1AttriValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub2AttriValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sub3AttriValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *godAttriValueLabel;

@property (nonatomic, strong) NSNumber* petId;
@property (nonatomic, strong) Equipment *equip;

-(void)setDataWithObject:(NSArray *)data;
-(void)setNewFrame:(CGRect)frame;
@end
