//
//  MYLive.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYLive;

//**********************主播****************************
@interface MYCreator : NSObject
@property (assign, nonatomic) NSInteger ID;             //主播ID
@property (assign, nonatomic) NSInteger level;          //等级
@property (assign, nonatomic) NSInteger gender;         //性别
@property (copy, nonatomic) NSString *nick;             //昵称
@property (copy, nonatomic) NSString *portrait;         //头像

@end

//**********************直播间****************************
@interface MYLive : NSObject
@property (strong, nonatomic) MYCreator *creator;       //主播
@property (copy, nonatomic) NSString *ID;               //房间ID
@property (copy, nonatomic) NSString *name;             //房间名
@property (copy, nonatomic) NSString *city;             //城市
@property (copy, nonatomic) NSString *share_addr;       //直播地址
@property (copy, nonatomic) NSString *stream_addr;      //流地址
@property (assign, nonatomic) NSInteger version;        //版本（0）
@property (assign, nonatomic) NSInteger slot;           //跟踪（1，5）
@property (copy, nonatomic) NSString *live_type;        //直播类型（“”）
@property (assign, nonatomic) NSInteger optimal;        //最优的（1）
@property (assign, nonatomic) NSInteger online_users;   //在线人数
@property (assign, nonatomic) NSInteger group;          //分组（1）
@property (assign, nonatomic) NSInteger link;           //链接（0）
@property (assign, nonatomic) NSInteger multi;          //许多（0）
@property (assign, nonatomic) NSInteger rotate;         //旋转（0）
@end
