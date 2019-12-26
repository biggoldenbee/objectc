//
//  BattleLogCellBase.m
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleLogCellBase.h"

@implementation BattleLogCellBase

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGSize)calcTextSize:(NSAttributedString*)string
{
    return [self calcTextSize:string width:320];
}

-(CGSize)calcTextSize:(NSAttributedString*)string width:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGRect rect = [string boundingRectWithSize:constraint
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    return size;
}

-(void)setupBackground
{
    CGRect bkFrame = self.frame;
    bkFrame.origin.y += 3;
    bkFrame.size.height -= 6;
    bkFrame.origin.x += 3;
    bkFrame.size.width = self.frame.size.width - 6;
    
    UIView* bkView = [self.contentView viewWithTag:99];
    if ( bkView == nil )
    {
        bkView = [[UIView alloc] initWithFrame:bkFrame];
        bkView.tag = 99;
        bkView.backgroundColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        [self.contentView addSubview:bkView];
        [self.contentView sendSubviewToBack:bkView];
    }
//    else
//        bkView.frame = bkFrame;

}

-(void)setNewFrame:(CGRect)frame
{
    widthDelta = frame.size.width - self.frame.size.width;
    self.frame = frame;
}

@end
