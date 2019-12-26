//
//  Monstor.h
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// 这个类只在战斗场合用，用来保存单场战斗的怪物数据
//
@interface Monstor : NSObject

@property (nonatomic, assign) NSInteger identifier;     // ID
@property (nonatomic, strong) NSString  *name;          // 名字
@property (nonatomic, assign) NSInteger level;          // 等级
@property (nonatomic, assign) NSInteger icon;           // 头像
@property (nonatomic, assign) NSInteger curHp;          // 当前血量
@property (nonatomic, assign) NSInteger hp;             // 血量
@property (nonatomic, assign) NSInteger ally;           // 哪一方

-(void)caleHP:(NSInteger)damage;
@end
