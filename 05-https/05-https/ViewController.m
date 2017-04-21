//
//  ViewController.m
//  05-https
//
//  Created by vera on 16/8/19.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"

@interface ViewController ()<NSURLSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //https处理
    //加载无效的证书--当前的证书是自制证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    //不验证域名
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager GET:@"https://kyfw.12306.cn/otn/leftTicket/init" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
#if 0
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://kyfw.12306.cn/otn/leftTicket/init"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:4]);
        }
    }];
    [task resume];
#endif
}

/**
 *  只要url以https://开头的会触发
 *
 *  @param session           <#session description#>
 *  @param challenge         <#challenge description#>
 *  @param completionHandler <#completionHandler description#>
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    //protectionSpace受保护的空间
    //challenge.protectionSpace.serverTrust
    
    

     //NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:<#(nonnull NSString *)#> password:<#(nonnull NSString *)#> persistence:<#(NSURLCredentialPersistence)#>];
    
    //从受保护的空间获取信任
    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    
    //安装证书
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
