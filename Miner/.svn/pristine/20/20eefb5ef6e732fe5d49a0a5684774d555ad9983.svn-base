//
//  AttriConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

//
// 被保存在字典内的value类
// 其实就是表中的每一行数据对象类
//
@interface AttriDef : NSObject

@property (nonatomic, assign) NSInteger attriID;    // 属性ID ：也是字典的key
@property (nonatomic, copy)   NSString* attriName; // 属性名称
@property (nonatomic, copy)   NSString* attriDesc; // 属性描述
@property (nonatomic, copy)   NSString* attriIcon; // 属性icon
@property (nonatomic, assign) NSInteger sub1Val;    // 1星副属性初始值
@property (nonatomic, assign) NSInteger sub1ValLV;  // 1星副属性成长值
@property (nonatomic, assign) NSInteger sub2Val;    // 2星副属性初始值
@property (nonatomic, assign) NSInteger sub2ValLV;  // 2星副属性成长值
@property (nonatomic, assign) NSInteger sub3Val;    // 3星副属性初始值
@property (nonatomic, assign) NSInteger sub3ValLV;  // 3星副属性成长值
@property (nonatomic, assign) NSInteger sub4Val;    // 4星副属性初始值
@property (nonatomic, assign) NSInteger sub4ValLV;  // 4星副属性成长值
@property (nonatomic, assign) NSInteger sub5Val;    // 5星副属性初始值
@property (nonatomic, assign) NSInteger sub5ValLV;  // 5星副属性成长值
@property (nonatomic, assign) NSInteger valueRatio; // 战力评分万分比
@property (nonatomic, assign) BOOL isDebuff;
@property (nonatomic, copy)   NSString* effectAnimation;
@property (nonatomic, assign) BOOL effectContinurous;

@end

//
// 读取attri.dat文件的类
// 并且利用字典来保存文件内的信息
//
@interface AttriConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(AttriConfig *)share;
-(AttriDef*)getAttriDefById:(NSNumber*)identifier;
-(NSString *)getAttriNameWithId:(NSNumber *)identifier;
-(NSString *)getAttriDescWithId:(NSNumber *)identifier;
-(NSString *)getAttriIconWithId:(NSNumber *)identifier;
-(NSNumber *)getAttriValueWithId:(NSNumber *)identifier withLv:(NSNumber *)level withStar:(NSNumber *)star;
@end
