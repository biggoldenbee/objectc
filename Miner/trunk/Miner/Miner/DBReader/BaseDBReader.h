//
//  LocalDBAdapter.h
//  GameCommonDef
//
//  Created by zhihua.qian on 14-11-06.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <istream>

@interface BaseDBReader : NSObject
{
    // NSMutableDictionary数组
    // 就是用来存数据的数组（废话）
    // 这里的数组保存的是每行的XXXDef类对象
	NSMutableArray* _DB;
}

// 重置
- (void)reset;

// 在Main Bundle中读取文件（根据文件名）
- (BOOL)loadWithFileInMainBundle:(NSString*)fileName;
// 根据文件名（参数1）和路径（参数2）来读取文件
- (BOOL)loadWithFile:(NSString*)fileName InDirectory:(NSString*)directory;
// 根据全路径+文件名来读取文件（以上两个最后都是调用这个方法的）
- (BOOL)loadWithFileFullName:(NSString*)fileFullName;

// 从数据中（内存）中加载（可能是用于网络下载的吧）
- (BOOL)loadFromData:(NSData*)data;
// 解析上面从数据中加载的内容
- (NSString*)parseFile:(char*)rawData;

// 需要重载的方法
- (void)initWithString:(NSString*)buffer;
- (void)loadDBFromLocal;
// ------------


//  以下方法已经废弃了
- (void)addRow:(id)rowData;     // 添加一行数据
- (void)deleteRow:(int)index;   // 根据下标删除一行数据
- (int)numOfRow;                // 返回总行数
- (id)rowAtIndex:(int)index;    // 根据下标返回一条数据

@end
