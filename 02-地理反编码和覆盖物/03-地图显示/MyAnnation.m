//
//  MyAnnation.m
//  03-地图显示
//
//  Created by vera on 16/5/7.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "MyAnnation.h"

@interface MyAnnation ()
{
    CLLocationCoordinate2D _coordinate;
}

@end

@implementation MyAnnation

/**
 *  初始化方法
 *
 *  @param coordinate <#coordinate description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
{
    if (self = [super init])
    {
        _coordinate = coordinate;
    }
    
    return self;
}

/**
 *  重写协议方法
 *
 *  @return <#return value description#>
 */
- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}



@end
