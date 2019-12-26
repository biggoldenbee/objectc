//
//  BattleLogActionCell.h
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattlePlayer.h"
#import "BattleData.h"
#import "BattleLogCellBase.h"

@interface BattleLogActionCell : BattleLogCellBase
{
    BattleAction* _action;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageBanner;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
-(void)setupAction:(BattleAction*)action;
@end
