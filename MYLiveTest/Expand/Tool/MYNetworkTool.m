//
//  MYNetworkTool.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYNetworkTool.h"
#import "MYConstant.h"
#import <MJExtension.h>
#import "MYLive.h"

@implementation MYNetworkManager
static MYNetworkManager *manager;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super manager];
        manager.requestSerializer.timeoutInterval = 30.0;
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript", nil];
    });
    return manager;
}

@end

@implementation MYNetworkTool

/**
 * 获取房间列表
 */
+ (void)getLivesSuccess:(void(^)(NSArray *lives))success failure:(void(^)(NSError *error))failure{

    [[MYNetworkManager sharedManager] GET:kApi parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"error_msg"];
        if ([status respondsToSelector:@selector(isEqualToString:)]) {
            if ([status isEqualToString:@"操作成功"]) {
                NSArray *liveDicts = [responseObject valueForKey:@"lives"];
                NSArray *lives = [MYLive mj_objectArrayWithKeyValuesArray:liveDicts];
                success(lives);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

@end
