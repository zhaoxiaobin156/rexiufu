//
//  SingleInstance.m
//  GCD-2
//
//  Created by vera on 15/8/4.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "SingleInstance.h"

@implementation SingleInstance

/**
 单例对象创建
 */
+ (instancetype) sharedInstance
{
    static SingleInstance *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只会调用一次
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
