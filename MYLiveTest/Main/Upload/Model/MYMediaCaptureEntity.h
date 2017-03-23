//
//  MYMediaCaptureEntity.h
//  MYLiveTest
//
//  Created by yanglin on 2017/3/22.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMediaCapture.h"
//@class LSMediaCapture;

@interface MYMediaCaptureEntity : NSObject
@property (assign, nonatomic) LSLiveStreamingParaCtx streamingCtx;      //直播参数
@property (copy, nonatomic) NSString *url;                              //推流地址


+ (instancetype)sharedInstance;

@end
