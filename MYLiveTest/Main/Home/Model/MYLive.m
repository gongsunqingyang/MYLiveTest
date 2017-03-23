//
//  MYLive.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//


#import "MYLive.h"

//**********************主播****************************
@implementation MYCreator
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

//**********************直播间****************************
@implementation MYLive
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end
