//
//  DatabaseMananger.h
//  BuyProject
//
//  Created by vera on 16/6/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseMananger : NSObject

+ (instancetype)sharedManager;

/**
 *  根据object，返回对于表名
 *
 *  @param object <#object description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)tableNameWithObject:(id)object;

/**
 *  插入数据
 *
 *  @param object <#object description#>
 */
- (BOOL)insertDataWithObject:(id)object;

/**
 *  条件查询
 *
 *  @param paramters <#paramters description#>
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)qureyDataFromDatabaseWithParamters:(NSDictionary *)paramters tableName:(NSString *)tableName;

/**
 *  查询所有的数据
 *
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)queryAllDataFromDatabaseWithTableName:(NSString *)tableName;

/**
 *  删除操作
 *
 *  @param paramters <#paramters description#>
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)deleteObjectFromDatabaseWithParamters:(NSDictionary *)paramters tableName:(NSString *)tableName;

@end
