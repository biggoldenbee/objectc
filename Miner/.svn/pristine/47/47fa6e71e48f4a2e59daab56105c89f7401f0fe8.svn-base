//
//  StageTableViewCell.m
//  Miner
//
//  Created by zhihua.qian on 15-1-6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "StageTableViewCell.h"
#import "MapConfig.h"
#import "StringConfig.h"
#import "GameUtility.h"
#import "HpCharaInst.h"

#define Stage_Active_Image      @"stage_button2"
#define Stage_UnActive_Image    @"stage_enter"

@interface StageTableViewCell ()

@property (nonatomic, strong) MapDef* currentCellMapDef;
@property (strong)HpCharaInst* actionInst;

@end

@implementation StageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.actionInst = [HpCharaInst instWithFile:@"ui.chr"];
    [self.animationView addSubview:self.actionInst.view];
    CGRect frame = [[self animationView] bounds];
    [self.actionInst.view setFrame:CGRectMake(frame.size.width, frame.size.height, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupDataWithDef:(MapDef*)def isCurrentMap:(NSNumber*)curMapId isMaxMap:(NSNumber*)maxMapId
{
    [self setCurrentCellMapDef:def];
    NSInteger mapId = [def mapID];
    if (mapId > [maxMapId integerValue])
    {
        [self setupLockStage];
    }
    else
    {
        if (mapId == [curMapId integerValue])
        {
            [self setupActiveStage];
        }
        else
        {
            [self setupUnActiveStage];
        }
    }
}

-(void)setupActiveStage
{
    UIImage* bgImage = [GameUtility imageNamed:@"stage_pic_02"];
    [[self stageCellBgImage] setImage:bgImage];
    
    [[self stageNameLabel] setHidden:NO];
    [[self stageNameLabel] setText:[[StringConfig share] getLocalLanguage:[[self currentCellMapDef] mapName]]];
    
    [[self stageMobLvLabel] setHidden:NO];
    [[self stageMobLvTextLabel] setHidden:NO];
    NSInteger minLv = [[self currentCellMapDef] minLv];
    NSInteger maxLv = [[self currentCellMapDef] maxLv];
    [[self stageMobLvLabel] setText:[NSString stringWithFormat:@"%ld - %ld", minLv, maxLv]];
    
    [[self stageCellNoRewardImage] setHidden:NO];
    [[self stageCellRewardImage] setHidden:YES];
    [[self stageCellEffectImage] setHidden:YES];
    [[self stageCellRewardBgImage] setHidden:YES];
    
    [[self stageCellActiveImage] setHidden:YES];
    [[self stageEnterLabel] setHidden:YES];
    
    [[self animationView] setHidden:NO];
    [[self actionInst] playAnima:@"ui_map_dig" isLoop:YES];
}

-(void)setupUnActiveStage
{
    UIImage* bgImage = [GameUtility imageNamed:@"stage_pic_01"];
    [[self stageCellBgImage] setImage:bgImage];
    
    [[self stageNameLabel] setText:[[StringConfig share] getLocalLanguage:[[self currentCellMapDef] mapName]]];
    
    NSInteger minLv = [[self currentCellMapDef] minLv];
    NSInteger maxLv = [[self currentCellMapDef] maxLv];
    [[self stageMobLvLabel] setText:[NSString stringWithFormat:@"%ld - %ld", minLv, maxLv]];
    
    [[self stageCellNoRewardImage] setHidden:NO];
    [[self stageCellRewardImage] setHidden:YES];
    [[self stageCellEffectImage] setHidden:YES];
    [[self stageCellRewardBgImage] setHidden:YES];
    
    [[self stageCellActiveImage] setHidden:NO];
    [[self stageCellActiveImage] setImage:[GameUtility imageNamed:Stage_UnActive_Image]];
    [[self stageEnterLabel] setHidden:NO];
    
    [[self animationView] setHidden:YES];
}

-(void)setupLockStage
{
    UIImage* bgImage = [GameUtility imageNamed:@"stage_pic_03"];
    [[self stageCellBgImage] setImage:bgImage];

    [[self stageNameLabel] setHidden:YES];
    
    [[self stageMobLvLabel] setHidden:YES];
    [[self stageMobLvTextLabel] setHidden:YES];
    
    [[self stageCellNoRewardImage] setHidden:NO];
    [[self stageCellRewardImage] setHidden:YES];
    [[self stageCellEffectImage] setHidden:YES];
    [[self stageCellRewardBgImage] setHidden:YES];
    
    [[self stageCellActiveBgImage] setHidden:YES];
    [[self stageCellActiveImage] setHidden:YES];

    [[self stageEnterLabel] setHidden:YES];
}
@end
