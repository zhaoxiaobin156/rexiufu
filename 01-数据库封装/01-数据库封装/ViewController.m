//
//  ViewController.m
//  01-数据库封装
//
//  Created by vera on 16/8/19.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"
#import "DatabaseMananger.h"
#import "XXX.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#if  0
    Test *test = [[Test alloc] init];
    test.name = @"小明";
    test.address = @"深圳市";
#endif
    
    XXX *xxx = [[XXX alloc] init];
    xxx.x1 = @"x1";
    xxx.x2 = @"x2";
    xxx.x3 = @"x3";
    xxx.x4 = @"x4";
    
    //oc的动态语言-runtime
    //[[DatabaseMananger sharedManager] insertDataWithObject:xxx];
    
    
    NSArray *objects = [[DatabaseMananger sharedManager] qureyDataFromDatabaseWithParamters:@{@"name":@"小明"} tableName:NSStringFromClass([Test class])];
    
    for (Test *test in objects)
    {
        NSLog(@"%@",test.name);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
