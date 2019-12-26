//
//  QQEquipBtnDefault.h
//  Miner
//
//  Created by zhihua.qian on 14-12-23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQEquipBtnDefaultDelegate <NSObject>

@optional
-(void)onClickedOnQQEquipDefaultView:(NSDictionary*)params;

@end

@interface QQEquipBtnDefault : UIView

@property (nonatomic, weak) IBOutlet UIView* view;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundIcon;
@property (weak, nonatomic) IBOutlet UIImageView *equipPartIcon;
@property (weak, nonatomic) IBOutlet UIImageView *markIcon;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *equipColorIcon;

@property (weak, nonatomic) IBOutlet UIImageView *star1Image;
@property (weak, nonatomic) IBOutlet UIImageView *star2Image;
@property (weak, nonatomic) IBOutlet UIImageView *star3Image;
@property (weak, nonatomic) IBOutlet UIImageView *star4Image;
@property (weak, nonatomic) IBOutlet UIImageView *star5Image;

@property (weak, nonatomic) IBOutlet UIImageView *star6Image;
@property (weak, nonatomic) IBOutlet UIImageView *star7Image;
@property (weak, nonatomic) IBOutlet UIImageView *star8Image;
@property (weak, nonatomic) IBOutlet UIImageView *star9Image;


@property (assign, nonatomic) id<QQEquipBtnDefaultDelegate> deleate;

-(void)initViewWithPartType:(int)type withPetId:(NSNumber*)petId;          // 根据部件位置，初始化
-(void)setEquipDataWithEId:(NSNumber*)equipId;  // 根据装备ID，重置视图
-(void)setItemDataWithTId:(NSNumber*)itemTId countNum:(NSInteger)num;    //  副属性升级道具
-(BOOL)checkEnough;    // 数量是否足够
-(void)refreshState:(int)slot;
@end