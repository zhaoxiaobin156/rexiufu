//
//  MyAnnation.h
//  03-地图显示
//
//  Created by vera on 16/5/7.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnation : NSObject<MKAnnotation>

/**
 *  初始化方法
 *
 *  @param coordinate <#coordinate description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
