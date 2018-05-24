//
//  ViewController.m
//  FDBM
//
//  Created by GuoMeng on 2018/5/22.
//  Copyright © 2018年 增光. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabaseManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:@[@111.222,@333.444],@"上海", @[@112.111,@222.222],@"重庆",@[@333.444,@555.666],@"北京",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",@[@111.222,@333.444],@"上海",nil];
    
    NSArray *arr = @[@"123",@"234"];
    
    NSArray *updateArr = @[@"888888",@"9999999",@"9999999",@"9999999",@"9999999",@"9999999",@"9999999"];
    
    NSData *dicData = [NSJSONSerialization dataWithJSONObject:map options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *arrData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *updateArrData = [NSJSONSerialization dataWithJSONObject:updateArr options:NSJSONWritingPrettyPrinted error:nil];
    
    //增加一条
    [[FMDatabaseManager sharedInstance] addDataWithTableName:@"student" primaryKey:@"yao" data:arrData];
    // 再增加一条
    [[FMDatabaseManager sharedInstance] addDataWithTableName:@"student" primaryKey:@"tian" data:dicData];
    
    //读取primary key为'yao'的数据
    __block NSArray *dataArr = [NSArray array];
    [[FMDatabaseManager sharedInstance] readDataWithTableName:@"student" primaryKey:@"yao" data:^(NSData *data) {
        dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dataArr);
    }];
    
    //删除primary key为‘yao’的数据
//    [[FMDatabaseManager sharedInstance] deleteDataWithTableName:@"student" primaryKey:@"yao"];
    
    //更新primary key为‘yao’的数据
    [[FMDatabaseManager sharedInstance] updateDataWithTableName:@"student" primaryKey:@"yao" data:updateArrData];
    
    //读取primary key为'yao'的数据
    __block NSArray *updataArr = [NSArray array];
    [[FMDatabaseManager sharedInstance] readDataWithTableName:@"student" primaryKey:@"yao" data:^(NSData *data) {
        updataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",updataArr);
    }];
    
    //读取primary key为'tian'的数据
    __block NSDictionary *dict = [NSDictionary dictionary];
    [[FMDatabaseManager sharedInstance] readDataWithTableName:@"student" primaryKey:@"tian" data:^(NSData *data) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
    }];
    
    //读取整个表的数据

    [[FMDatabaseManager sharedInstance] readAllDataWithTableName:@"student" dataArr:^(NSArray *dataArr) {
        NSLog(@"%@",dataArr);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
