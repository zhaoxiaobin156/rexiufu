//
//  ViewController.m
//  06-热修复
//
//  Created by vera on 16/8/19.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //JSPatch 可以让你用 JavaScript 书写原生 iOS APP。只需在项目引入极小的引擎，就可以使用 JavaScript 调用任何 Objective-C 的原生接口，获得脚本语言的优势：为项目动态添加模块，或替换项目原生代码动态修复 bug。

    [self test2];
    
    
}

- (void)test1
{
    NSLog(@"test1方法调用了");
}

- (void)test2
{
    NSArray *arary = [NSArray array];
    
   
    NSLog(@"test2方法调用了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
