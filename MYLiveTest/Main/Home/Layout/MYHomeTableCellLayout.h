//
//  MYHomeTableCellLayout.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#define kNameLabelFont kFont(14)
#define kCityLabelFont kFont(12)
#define kOnlineLabelNumFont kFont(15)
#define kOnlineLabelDescFont kFont(12)
#define kStatusLabelFont kFont(12)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYKit.h>
#import "MYLive.h"
#import "MYMacros.h"

//*****************简介容器********************
@interface MYCardLayout : NSObject
@property (assign, nonatomic) CGRect avatarFrame;
@property (assign, nonatomic) CGRect nameLabelFrame;
@property (assign, nonatomic) CGRect cityLabelFrame;
@property (assign, nonatomic) CGRect onlineLabelFrame;
@property (assign, nonatomic) CGRect frame;

@property (copy, nonatomic) YYTextLayout *onlineLayout;

@property (strong, nonatomic) MYLive *live;

@end

//*****************实时截图********************
@interface MYLiveIVLayout : NSObject
@property (assign, nonatomic) CGRect statusLabelFrame;
@property (assign, nonatomic) CGRect blurFrame;

@property (assign, nonatomic) CGRect frame;

@property (strong, nonatomic) YYTextLayout *statusLayout;
@property (strong, nonatomic) MYLive *live;
@end

//*****************Cell********************
@interface MYHomeTableCellLayout : NSObject
@property (strong, nonatomic) MYCardLayout *cardLayout;
@property (strong, nonatomic) MYLiveIVLayout *liveIVLayout;
@property (assign, nonatomic) CGFloat h;

@property (strong, nonatomic) MYLive *live;

@end
