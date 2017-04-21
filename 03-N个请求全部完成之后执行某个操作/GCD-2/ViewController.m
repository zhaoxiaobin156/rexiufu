//
//  ViewController.m
//  GCD-2
//
//  Created by vera on 15/8/3.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "ViewController.h"
#import "Operation.h"

@interface ViewController ()
{
    //串行队列
    dispatch_queue_t mainQueue;
    
    //并行队列
    dispatch_queue_t globalQueue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //串行队列
    mainQueue = dispatch_get_main_queue();
    
    //并行队列
    globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
#if 0
    //并行队列
    dispatch_queue_create("queueName", DISPATCH_QUEUE_CONCURRENT)
    
    //串行队列
    dispatch_queue_create("queueName", DISPATCH_QUEUE_SERIAL);
#endif
    
    /*
     队列：先进先出
     栈：先进后出
     */
   
#if 1
    Operation *o = [[Operation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     
    queue.maxConcurrentOperationCount = 1;
     
    [queue addOperation:o];
#endif
    
//    [self 有一个需求_需要将N个请求全部完成之后执行某个操作_该如何处理];
    
//    [self test1];
}

- (void)有一个需求_需要将N个请求全部完成之后执行某个操作_该如何处理
{
    //调度组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        
        NSLog(@"任务1开始");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"任务1结束");
        
    });
    
    dispatch_group_async(group, globalQueue, ^{
        
        NSLog(@"任务2开始");
        [NSThread sleepForTimeInterval:10];
        NSLog(@"任务2结束");
        
    });
    
    //必须放到最后，当前面执行的任务都执行完才会执行下面的任务
    dispatch_group_notify(group, globalQueue, ^{
        
        NSLog(@"上面的所有任务都完成");
        
    });
}

//只会打印11111
- (void)死锁
{
    NSLog(@"11111");
    
    //dispatch_sync 同步调度：就是把任务添加到指定队列里面，然后必须等待任务完成才能继续
    //dispatch_async 异步调度：就是把任务添加到指定队列里面，没必须等待任务完成才能继续
    
    //串行队列
    //并行队列
    //同步调度
    //异步调度
    
    //死锁
    dispatch_sync(mainQueue, ^{
        NSLog(@"22222");
    });
    
    NSLog(@"33333");
}

//只调用一次，一般用在单例创建对象
- (void)test7
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSLog(@"只调用一次");
        
    });
}

//连续调用某个任务多少次
- (void)test6
{
    //连续调用多少次(同时调用)
    dispatch_apply(10, globalQueue, ^(size_t time) {
        
        NSLog(@"连续调用%zu次",time);
        
    });
}

//延迟调用
- (void)test5
{
    //延迟delayInSeconds秒调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"延迟3秒调用");
        
    });
}

//A、B并发执行，然后执行C，最后D、E并发执行
- (void)test4
{
    /**
     1.分割任务必须是自定义的队列
     2. dispatch_queue_create(队列的标签, 串行/并行)
        (1)DISPATCH_QUEUE_CONCURRENT //并行
        (2)DISPATCH_QUEUE_SERIAL //串行
     */
    
//    dispatch_sync;系统没有创建线程
//    dispatch_async;系统创建线程

    
    /**
     创建一个自定义的并行队列
     */
    dispatch_queue_t customQueue = dispatch_queue_create("com.GCD.customQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(mainQueue, ^{
        
        NSLog(@"################ %@",[NSThread currentThread]);
        
    });
    
    //任务A
    dispatch_async(customQueue, ^{
        
        [self doSomeOperation:@"A"];
        
        NSLog(@"######### %@",[NSThread currentThread]);
        
    });
    
    //任务B
    dispatch_async(customQueue, ^{
        
        [self doSomeOperation:@"B"];
        
    });

    //任务C
    //分割：把前面的任务和后面的任务分开
    dispatch_barrier_async(customQueue, ^{
        
        [self doSomeOperation:@"C"];
        
    });
    
    //任务D
    dispatch_async(customQueue, ^{
        
        [self doSomeOperation:@"D"];
        
    });
    
    //任务E
    dispatch_async(customQueue, ^{
        
        [self doSomeOperation:@"E"];
        
    });
}

//A、B并发执行，最后执行C
- (void)test3
{
    //调度组
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_group_async(group, globalQueue, ^{
        
        NSLog(@"任务1开始");
        //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d3.s.hjfile.cn/2012/201202_3/43904b09-24e1-4fdb-8b46-d3dba3323278.mp3"]];
        NSLog(@"任务1完成");
        
    });
    
    dispatch_group_async(group, globalQueue, ^{
        
        NSLog(@"任务2开始");
        sleep(1);
        NSLog(@"任务2完成");
        
    });
    
    //必须放到最后
    dispatch_group_notify(group, globalQueue, ^{
        
        NSLog(@"任务3");
        
        //1.开始请求数据
        sleep(2);
        NSLog(@"请求数据完成");
        
        //2.回到主线程
        dispatch_async(mainQueue, ^{
            
            NSLog(@"回到主线程");
            
            //刷新UI
        });
        
        //前面的任务都完成了
        
       NSLog(@"---- %d",[NSThread isMainThread]);
        
    });
}

//任务A、B、C并发执行，无顺序
- (void)test2
{
    dispatch_async(globalQueue, ^{
        
        //任务1
        [self doSomeOperation:@"A"];
        
    });
    
    dispatch_async(globalQueue, ^{
        
        //任务2
        [self doSomeOperation:@"B"];
        
    });
    
    dispatch_async(globalQueue, ^{
        
        //任务3
        [self doSomeOperation:@"C"];
        
    });
}

//任务A、B、C串行执行
- (void)test1
{
    /**
     同步调度和异步调度
     串行队列和并行队列
     */
    
    dispatch_async(mainQueue, ^{
        
        NSLog(@"---- %@",[NSThread currentThread]);
        
        //任务1
        [self doSomeOperation:@"A"];
        
    });
    
    NSLog(@"11111");
    
    dispatch_async(mainQueue, ^{
        
        //任务2
        [self doSomeOperation:@"B"];
        
    });
    
    NSLog(@"22222");
    
    dispatch_async(mainQueue, ^{
        
        //任务3
        [self doSomeOperation:@"C"];
        
    });
    
    NSLog(@"33333");
}

- (void)doSomeOperation:(NSString *)name
{
    sleep(1);
    NSLog(@"----- %@",name);
    
    //NSData *data = [NSData dataWithContentsOfURL:<#(NSURL *)#>];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
