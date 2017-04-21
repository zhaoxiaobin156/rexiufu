//
//  SingleInstance.h
//  GCD-2
//
//  Created by vera on 15/8/4.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleInstance : NSObject

+ (instancetype) sharedInstance;

@end
