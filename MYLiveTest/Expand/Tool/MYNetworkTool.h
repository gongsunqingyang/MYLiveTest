//
//  MYNetworkTool.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface MYNetworkManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

@end

@interface MYNetworkTool : NSObject
+ (void)getLivesSuccess:(void(^)(NSArray *lives))success failure:(void(^)(NSError *error))failure;

@end
