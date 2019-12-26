//
//  CacheBag.h
//  Miner
//
//  Created by zhihua.qian on 15/1/14.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Be_Wait,        // 等待
    Be_Reduction,   // 还原
    Be_Destroy,     // 摧毁
}
CACHE_OPERATION_TYPE;

@interface CacheBag : NSObject

-(void)OprationCostMoney:(NSInteger)num stateType:(CACHE_OPERATION_TYPE)type;
-(void)OprationOneEquip:(NSNumber*)equipId stateType:(CACHE_OPERATION_TYPE)type;
-(void)OprationEquips:(NSArray*)equipsArray stateType:(CACHE_OPERATION_TYPE)type;
-(void)OprationItems:(NSArray*)itemsArray stateType:(CACHE_OPERATION_TYPE)type;
@end
