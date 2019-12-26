//
//  RandatdConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

#define RANDATE_EVENT_NUM 5

@interface RandateBase : NSObject

@property (nonatomic, assign) NSInteger ranProp;        // 事件参数
@property (nonatomic, assign) NSInteger ranPropRatio;   // 事件几率

@end

@interface RandateDef : NSObject

@property (nonatomic, assign) NSInteger ranID;              // 事件ID
@property (nonatomic, assign) NSInteger ranType;            // 事件类型
@property (nonatomic, strong) NSDictionary  *eventDatas;    // 事件数据

@end

@interface RandateConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(RandateConfig *)share;
@end
