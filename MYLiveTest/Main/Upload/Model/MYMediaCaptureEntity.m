//
//  MYMediaCaptureEntity.m
//  MYLiveTest
//
//  Created by yanglin on 2017/3/22.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYMediaCaptureEntity.h"

@implementation MYMediaCaptureEntity

+ (instancetype)sharedInstance{
    static MYMediaCaptureEntity *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init] ;
    }) ;
    return instance ;
}



@end
