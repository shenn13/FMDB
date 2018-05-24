//
//  FMDatabaseManager.h
//  FDBM
//
//  Created by GuoMeng on 2018/5/22.
//  Copyright © 2018年 增光. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^getDataByPrimaryKey)(NSData *data);
typedef void(^getAllData)(NSArray *dataArr);  

@interface FMDatabaseManager : NSObject

+ (FMDatabaseManager *)sharedInstance;

//插入某一数据
- (BOOL)addDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(NSData *)data;

//删除某一数据
- (BOOL)deleteDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey;

//更新某一数据
- (BOOL)updateDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(NSData *)data;

//读取某一数据
- (BOOL)readDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(getDataByPrimaryKey)dataBlock;

//读取所有数据
- (BOOL)readAllDataWithTableName:(NSString *)tableName dataArr:(getAllData)allDataBlock;

//清除所有数据
- (BOOL)clearDataBaseWithTableName:(NSString *)tableName;

@end
