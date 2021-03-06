//
//  BattleLogCountingCell.h
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleLogCellBase.h"
#import "BattleLogMessageCell.h"

@class BattleLogCounting;

@interface BattleLogCountingCell : BattleLogCellBase
{
    CGRect _rectMessage;
}
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
-(void)refreshMessage:(BattleLogCounting*)blc;
@end

@interface BattleLogCounting : NSObject
{
    int _time;
    
}
@property (nonatomic, assign) int originalTimer;
-(void)countDown;
-(void)start;
-(bool)validate;
-(int)time;
@end