//
//  DropConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

#define DROP_ITEM_NUM 20

@interface DropBase : NSObject

@property (nonatomic, assign) NSInteger itemId;    // 物品id
@property (nonatomic, assign) NSInteger idNum;     // 物品id个数

@end

@interface DropDef : NSObject

@property (nonatomic, assign)   NSInteger       dropId;     // 掉落id
@property (nonatomic, copy)     NSString*       dropIcon;   // 预览图片
@property (nonatomic, copy)     NSString*       dropName;   // drop名称
@property (nonatomic, strong)   NSDictionary*   dropDatas;  // 掉落物品集合

@end

//
// 读取drop.dat文件
//
@interface DropConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(DropConfig *)share;
-(DropDef*)getDropDefWithId:(NSInteger)identifier;
@end

// ----------------------------------------------------------------------------

@interface TcBase : NSObject

@property (nonatomic, assign) NSInteger dropID;    // 掉落id
@property (nonatomic, assign) NSInteger IdRatio;   // 掉落概率

@end

@interface TcDef : NSObject

@property (nonatomic, assign) NSInteger tcId;       // 掉落集合id
@property (nonatomic, assign) NSInteger run;        // 检测次数
@property (nonatomic, assign) NSInteger noDrop;     // 不掉落概率
@property (nonatomic, strong) NSDictionary  *tcDatas;   //

@end

//
// 读取tc.dat文件
//
@interface TcConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(TcConfig *)share;

-(TcDef*)getTcDefWithId:(NSInteger)identifier;
@end
