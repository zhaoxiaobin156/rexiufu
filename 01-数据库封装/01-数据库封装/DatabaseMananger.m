//
//  DatabaseMananger.m
//  BuyProject
//
//  Created by vera on 16/6/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "DatabaseMananger.h"
#import "FMDB.h"
#import <objc/runtime.h>

@interface DatabaseMananger ()
{
    /**
     *  数据库对象
     */
    FMDatabase *_database;
}

@end

@implementation DatabaseMananger

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _database = [FMDatabase databaseWithPath:[self databasePath]];
        
        NSLog(@"%@",[self databasePath]);
    }
    return self;
}

+ (instancetype)sharedManager
{
    static DatabaseMananger *manager = nil;
    
    //线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**
 *  数据库路径
 *
 *  @return <#return value description#>
 */
- (NSString *)databasePath
{
    NSString *documentPath =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    return [documentPath stringByAppendingPathComponent:@"data.db"];
}

/**
 *  根据object，返回对于表名
 *
 *  @param object <#object description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)tableNameWithObject:(id)object
{
    return NSStringFromClass([object class]);
}

#pragma mark - 插入数据
/**
 *  插入数据
 *
 *  @param object <#object description#>
 */
- (BOOL)insertDataWithObject:(id)object
{
    
    //1.数据库打开
    if (![_database open])
    {
        return NO;
    }
    
    
    //2.判断表是否存在
    NSString *tableName = NSStringFromClass([object class]);
    
    if (![self existTableInDatabaseWithTableName:tableName])
    {
        
        //如果当前表不存在，就创建表
        BOOL success = [self createTableWithObject:object];
        
        if (!success)
        {
            return NO;
        }
    
    }

    
    //3.插入数据
    //insert into xxx (name, age) values ('x',20)
    NSMutableString *keySql = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
    NSMutableString *valueSql = [NSMutableString stringWithString:@" values ("];
    
    //获取指定类的属性
    NSArray *properties = [self propertiesWithClass:[object class]];
    
    [properties enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == properties.count - 1)
        {
            [keySql appendFormat:@"%@)",key];
            [valueSql appendFormat:@"'%@')",[object valueForKey:key]];
        }
        else
        {
            [keySql appendFormat:@"%@,",key];
            [valueSql appendFormat:@"'%@',",[object valueForKey:key]];
        }
    }];
    
    [keySql appendString:valueSql];
    
    /*
     executeUpdate:除了查询操作之外的操作
     executeQuery:查询操作
     */
    BOOL insertSuccess = [_database executeUpdate:keySql];
    
    if (insertSuccess)
    {
        NSLog(@"插入数据成功");
    }
    else
    {
        NSLog(@"插入数据失败");
    }
    
    //4.数据库关闭
    [_database close];

    return insertSuccess;
}

#pragma mark - 创建指定表
- (BOOL)createTableWithObject:(id)object
{
    Class cls = [object class];
    
    //create table if not exists xxx (id integer primary key autoincrement, name text)
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",NSStringFromClass(cls)];
    
    //获取指定的类属性
    NSArray *properties = [self propertiesWithClass:cls];
    
    [properties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == properties.count - 1)
        {
            [sql appendFormat:@",%@ text)",obj];
        }
        else
        {
            [sql appendFormat:@",%@ text",obj];
        }
        
        
    }];
    
    //执行sql语句
    return [_database executeUpdate:sql];
}

#pragma mark - 判断指定表是否存在
/**
 *  判断表是否存在
 *
 *  @param tablename <#tablename description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)existTableInDatabaseWithTableName:(NSString *)tablename
{
    //select * from sqlite_master where type = 'table' and name = ""
    
    //sqlite_master系统自动创建的，保存其他表的信息
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table' and name = '%@'",tablename];
    
    FMResultSet *results = [_database executeQuery:sql];
    
    
    return results.next;
}

- (NSString *)paramtersWithDictionary:(NSDictionary *)paramters
{
    NSMutableString *string = [NSMutableString string];
    
    //key = value and key2 = value2
    
    NSArray *keys = paramters.allKeys;
    
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx == keys.count - 1)
        {
            [string appendFormat:@"%@='%@'",key, paramters[key]];
        }
        else
        {
            [string appendFormat:@"%@='%@' and ",key, paramters[key]];
        }
    }];
    
    
    return string;
}

#pragma mark - 条件查询
/**
 *  查询
 *
 *  @param paramters <#paramters description#>
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)qureyDataFromDatabaseWithParamters:(NSDictionary *)paramters tableName:(NSString *)tableName;
{
    if (![_database open])
    {
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray array];
    
    NSString *sql = nil;
    
    //查询所有的数据
    if (!paramters)
    {
        sql = [NSString stringWithFormat:@"select * from %@",tableName];
    }
    //条件查询
    else
    {
         sql = [NSString stringWithFormat:@"select * from %@ where %@",tableName,[self paramtersWithDictionary:paramters]];
    }

    
    FMResultSet *results = [_database executeQuery:sql];
    
    
    NSArray *properies = [self propertiesWithClass:NSClassFromString(tableName)];
    
    while (results.next)
    {
        //封装对象
        id object = [[NSClassFromString(tableName) alloc] init];
        
        //给属性赋值
        for (NSString *key in properies)
        {
            [object setValue:[results stringForColumn:key] forKey:key];
        }
        
        [objects addObject:object];
    }
    
    [_database close];
    
    return objects;
}

#pragma mark - 查询所有的数据
/**
 *  查询所有的数据
 *
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)queryAllDataFromDatabaseWithTableName:(NSString *)tableName
{
    return [self qureyDataFromDatabaseWithParamters:nil tableName:tableName];
}

#pragma mark - 删除操作
/**
 *  删除操作
 *
 *  @param paramters <#paramters description#>
 *  @param tableName <#tableName description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)deleteObjectFromDatabaseWithParamters:(NSDictionary *)paramters tableName:(NSString *)tableName
{
    //delete from xx where xx = 'xxx'
    
    if (![_database open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName, [self paramtersWithDictionary:paramters]];
    
    
    BOOL deleteSuccess = [_database executeUpdate:sql];
    
    [_database close];
    
    return deleteSuccess;
}

#pragma mark - 动态获取指定类的属性
- (NSMutableArray *)propertiesWithClass:(Class)cls
{
    NSMutableArray *properyArray = [NSMutableArray array];
    
    unsigned int outCount;
    //动画获取指定类的获取
    objc_property_t *properies = class_copyPropertyList(cls, &outCount);
    
    for (int i = 0; i < outCount; i++)
    {
        //获取属性
        objc_property_t property = properies[i];
        //获取属性名字
        const char *name = property_getName(property);
        //属性的类型
        //property_getAttributes(<#objc_property_t property#>)
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        
        [properyArray addObject:propertyName];
        
    }
    
    return properyArray;
    
}


@end
