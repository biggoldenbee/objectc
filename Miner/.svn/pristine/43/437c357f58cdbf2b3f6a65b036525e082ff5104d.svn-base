//
//  BriefViewController.h
//  Miner
//
//  Created by zhihua.qian on 15-1-5.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@interface BriefViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (nonatomic, assign) unsigned int seconds;         // 本次登陆已经战斗时间
@property (nonatomic, assign) unsigned int battleCount;     // 本次登陆已经战斗次数
@property (nonatomic, assign) unsigned int battleWins;      // 本次登陆已经获胜次数
@property (nonatomic, assign) unsigned int battleLost;      // 本次登陆已经失败次数
@property (nonatomic, assign) unsigned int battleMine;      // 本次登陆已经挖到的矿产
@property (nonatomic, assign) unsigned int exp;             // 已经获取的经验值
@property (nonatomic, assign) unsigned int money;           // 已经获取的钱币
@property (nonatomic, assign) unsigned int boxW;            // 已经打开的箱子
@property (nonatomic, assign) unsigned int boxF;            // 已经打开失败的箱子
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) NSArray* equips;
@property (nonatomic, strong) NSArray* boxs;
@property (nonatomic, strong) NSArray* autoSells;

@property (strong, nonatomic) IBOutlet UIButton *getAllButton;

-(void)setDataInfoInViewControllers:(NSDictionary*)data inParentView:(UIView*)inParentView;

-(BOOL)isPresented;

@end
