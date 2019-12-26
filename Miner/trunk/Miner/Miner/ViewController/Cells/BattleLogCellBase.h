//
//  BattleLogCellBase.h
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BattleLogCellBase : UITableViewCell
{
    CGFloat widthDelta;
}
@property (nonatomic, assign) CGFloat cellHeight;

-(CGSize)calcTextSize:(NSAttributedString*)string;
-(CGSize)calcTextSize:(NSAttributedString*)string width:(CGFloat)width;
-(void)setupBackground;
-(void)setNewFrame:(CGRect)frame;
@end
