//
//  BriefTitleTableViewCell.m
//  Miner
//
//  Created by biggoldenbee on 15/1/7.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BriefTitleTableViewCell.h"

#import "GameUtility.h"

@interface BriefTitleTableViewCell()
@property (strong, nonatomic) UIImageView *baseLine;
@end


@implementation BriefTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.baseLine = [[UIImageView alloc] initWithFrame:CGRectMake(10,142,300,1)];
//    self.baseLine.image = [GameUtility imageNamed:@"base_line2.png"];
//    [self.contentView addSubview:self.baseLine] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithObject:(NSArray *)data; {
    //测试数据，具体实现还没做完。
    [[self yourTimes] setText:[data objectAtIndex:0]] ;
    [[self yourLayer] setText:[data objectAtIndex:1]] ;
    [[self yourMoney] setText:[data objectAtIndex:2]] ;
    [[self yourExperiences] setText:[data objectAtIndex:3]] ;
//    self.baseLine.frame = CGRectMake(10,self.frame.size.height-1,[UIScreen mainScreen].bounds.size.width-20,1);
}


@end
