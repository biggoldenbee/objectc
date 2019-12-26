//
//  PortConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-12-18.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

@interface PortDef : NSObject

@property (nonatomic, assign) NSInteger portId;
@property (nonatomic, copy)   NSString* sName;
@property (nonatomic, copy)   NSString* fName;
@property (nonatomic, assign) NSInteger serverID;
@property (nonatomic, assign) NSInteger portGroup;
@property (nonatomic, assign) NSInteger portTimezone;

@end

@interface PortConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(PortConfig *)share;

-(PortDef*)getPortDefWithPortId:(NSNumber*)portId;
@end

//*************************************************************************

@interface PortLvNeeds : NSObject

@property (nonatomic, assign) NSInteger needkey;
@property (nonatomic, strong) NSString* needValue;

@end

@interface PortLvDef : NSObject

@property (nonatomic, assign) NSInteger portLv;
@property (nonatomic, assign) NSInteger landLockUpperLimit;
@property (nonatomic, assign) NSInteger mayorNum;
@property (nonatomic, assign) NSInteger deputyNum;
@property (nonatomic, assign) NSInteger assemblyNum;
@property (nonatomic, strong) NSArray* lvNeedsArray;

@end

@interface PortLvConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(PortLvConfig *)share;
-(PortLvDef*)getPortLvDefWithPortId:(NSNumber*)portId;
@end

//*************************************************************************
// 贡献度
@interface ContributionDef : NSObject

@property (nonatomic, assign) NSInteger conLv;
@property (nonatomic, copy)   NSString* conName;
@property (nonatomic, copy)   NSString* conIcon;
@property (nonatomic, assign) NSInteger conValue;

@end

@interface ContributionConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(ContributionConfig *)share;
-(ContributionDef*)getContributionDefWithLevel:(NSNumber*)level;
@end

//*************************************************************************

@interface AppDownContriDef : NSObject

@property (nonatomic, assign) NSInteger appPriceGap;
@property (nonatomic, assign) NSInteger conValue;

@end

@interface AppDownContriConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(ContributionConfig *)share;
-(AppDownContriDef*)getAppDownContriDefWithGap:(NSNumber*)gap;
@end