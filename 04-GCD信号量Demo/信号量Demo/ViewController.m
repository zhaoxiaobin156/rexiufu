//
//  ViewController.m
//  信号量Demo
//
//  Created by vera on 15/8/4.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"%llu",DISPATCH_TIME_NOW);
//    NSLog(@"%llu",DISPATCH_TIME_FOREVER);
    
//    NSOperationQueue *queue;
//    queue.maxConcurrentOperationCount = 10;

//    实现任务的最大并发量
    
    /**
     信号量：就是一个整数值
     信号量为0，其他任务都会等待
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    
    for (int i = 0; i < 100; i++)
    {
        //任务
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //信号量减1(DISPATCH_TIME_FOREVER无限大)
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            //耗时操作：网络请求，下载，上传，写文件，从数据库读取大量数据，把大量数据写入数据中
            sleep(1);
            NSLog(@"任务：%d",i + 1);
            
            //使信号量+1
            dispatch_semaphore_signal(semaphore);
            
        });
    }
}

- (void)锁对象
{
    //条件锁
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
    
    //任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //加锁
        [lock lockWhenCondition:1];
        
        NSLog(@"-------任务1");
        
        sleep(3);
        
        //解锁
        [lock unlockWithCondition:2];
    });
    
    
    //任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //加锁
        [lock lockWhenCondition:2];
        
        NSLog(@"-------任务2");
        
        //释放锁
        [lock unlock];
    });
    
    /**
     iOS常见锁对象：
     1.互斥锁 NSLock
     2.对象锁 @synchronized(self)
     3.条件锁 NSConditionLock
     4.递归锁 NSRecursiveLock
     */
    
    //
    //    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    //    [lock lock];
    //    [lock unlock];
    //[lock tryLock];
    
#if 0
    //条件锁
    NSConditionLock;
    
    //递归锁
    NSRecursiveLock;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
