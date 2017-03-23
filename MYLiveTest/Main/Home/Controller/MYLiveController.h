//
//  MYLiveController.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYLive;

@interface MYLiveController : UIViewController
@property (strong, nonatomic) MYLive *live;

- (instancetype)initWithLive:(MYLive *)live avatar:(UIImage *)image;

@end
