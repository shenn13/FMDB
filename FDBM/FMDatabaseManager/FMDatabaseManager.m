//
//  FMDatabaseManager.m
//  FDBM
//
//  Created by GuoMeng on 2018/5/22.
//  Copyright © 2018年 增光. All rights reserved.
//

#import "FMDatabaseManager.h"
#import "FMDatabase.h"

#define CREAT_TABLE_IFNOT_EXISTS             @"create table if not exists %@ (key text primary key, data blob)"
#define DELETE_DATA_WITH_PRIMARYKEY          @"delete from %@ where key = ?"
#define INSERT_TO_TABLE                      @"insert into %@ (key, data) values (?, ?)"
#define READ_DATA_TABLE_WITH_PRIMARYKEY      @"select data from %@ where key = ?"
#define READ_ALL_DATA                        @"select data from %@"
#define UPDATE_DATA_WHTH_PRIMARYKEY          @"update %@ set data = ? where key = ?"
#define CLEAR_ALL_DATA                       @"DELETE FROM %@"

@implementation FMDatabaseManager

+(FMDatabaseManager *)sharedInstance {
    static FMDatabaseManager *YaoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YaoManager = [[FMDatabaseManager alloc] init];
    });
    return YaoManager;
}

- (BOOL)addDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(NSData *)data {
    BOOL ret = false;
    //get the dB path
    NSString *dbPath = [self getDbPath];
    //init a dataBase
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = [NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS,tableName];
        ret = [dataBase executeUpdate:sql];
        if (ret) {
            //make sure the primaryKey is uinque.
            NSString *deleteSql = [NSString stringWithFormat:DELETE_DATA_WITH_PRIMARYKEY,tableName];
            ret = [dataBase executeUpdate:deleteSql,primaryKey];
            if (ret) {
                NSString *storeURL = [NSString stringWithFormat:INSERT_TO_TABLE,tableName];
                ret = [dataBase executeUpdate:storeURL,primaryKey,data];
            }
        }
    }
    [dataBase close];
    return ret;
}

- (BOOL)deleteDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey {
    BOOL ret = false;
    NSString *dbPath = [self getDbPath];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = [NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS,tableName];
        ret = [dataBase executeUpdate:sql,primaryKey];
        if (ret) {
            NSString *deleteSql = [NSString stringWithFormat:DELETE_DATA_WITH_PRIMARYKEY,tableName];
            ret = [dataBase executeUpdate:deleteSql,primaryKey];
        }
    }
    [dataBase close];
    return ret;
}

- (BOOL)updateDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(NSData *)data {
    BOOL ret = false;
    NSString *dbPath = [self getDbPath];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = [NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS,tableName];
        ret = [dataBase executeUpdate:sql,primaryKey];
        if (ret) {
            NSString *updateSql = [NSString stringWithFormat:UPDATE_DATA_WHTH_PRIMARYKEY,tableName];
            ret = [dataBase executeUpdate:updateSql,data,primaryKey];
        }
    }
    [dataBase close];
    return ret;
}

- (BOOL)readDataWithTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(getDataByPrimaryKey)dataBlock {
    BOOL ret = false;
    NSString *dataPath = [self getDbPath];
    FMDatabase *dB = [FMDatabase databaseWithPath:dataPath];
    if ([dB open]) {
        NSString *creatSql = [NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS,tableName];
        ret = [dB executeUpdate:creatSql];
        if (ret) {
            NSString *readSql = [NSString stringWithFormat:READ_DATA_TABLE_WITH_PRIMARYKEY,tableName];
            FMResultSet *resultSet = [dB executeQuery:readSql,primaryKey];
            while ([resultSet next]) {
                NSData *data = [resultSet dataForColumn:@"data"];
                dataBlock(data);
            }
        }
    }
    [dB close];
    return ret;
}

- (BOOL)readAllDataWithTableName:(NSString *)tableName dataArr:(getAllData)allDataBlock {
    BOOL ret = false;
    NSString *dbPath = [self getDbPath];
    NSMutableArray *dataArr = [NSMutableArray array];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = [NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS,tableName];
        ret = [dataBase executeUpdate:sql];
        if (ret) {
            NSString *readSql = [NSString stringWithFormat:READ_ALL_DATA,tableName];
            FMResultSet *result = [dataBase executeQuery:readSql];
            while ([result next]) {
                NSData *data = [result dataForColumn:@"data"];
                [dataArr addObject:data];
            }
            allDataBlock(dataArr);
        }
    }
    [dataBase close];
    return ret;
}

- (BOOL)clearDataBaseWithTableName:(NSString *)tableName{
    BOOL ret = false;
    NSString *dbPath = [self getDbPath];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *clearSql = [NSString stringWithFormat:CLEAR_ALL_DATA,tableName];
        ret = [dataBase executeUpdate:clearSql];
    }
    [dataBase close];
    return ret;
}
#pragma mark - private function
- (NSString *)getDbPath {
    NSString *doc= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [doc stringByAppendingString:@"data.sqlite"];
}

@end
