//
//  BagExtent.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseDBReader.h"

//
// 作为字典的value对象的类
// 也是bagextent文件中一行的数据
//
@interface BagExtentDef : NSObject

@property (nonatomic, assign) NSInteger time;       // 扩张次数 ：也是字典的key
@property (nonatomic, assign) NSInteger moneyType;  // 需要花费的类型
@property (nonatomic, assign) NSInteger moneyNum;   // 需要花费的费用

@end

//
// 读取bagextent.dat文件的内容
//
@interface BagExtentConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(BagExtentConfig *)share;

-(BagExtentDef *)getBagExtentDefWithTimes:(NSInteger)time;  // 根据次数来获取背包的配置信息
@end
