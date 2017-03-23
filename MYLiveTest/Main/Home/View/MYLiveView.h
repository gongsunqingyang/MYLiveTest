//
//  MYLiveView.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYLiveView, MYLive;

//***************************************************

typedef NS_ENUM(NSInteger, MYLiveViewBtnType) {
    MYLiveViewBtnType_Text = 0,
    MYLiveViewBtnType_Record,
    MYLiveViewBtnType_Mail,
    MYLiveViewBtnType_Share,
};

//**********************MYLiveViewDelegate*****************************

@protocol MYLiveViewDelegate <NSObject>

@required
- (void)liveView:(MYLiveView *)liveView didClickBtnType:(MYLiveViewBtnType)type;

@end

//**********************MYHostView*****************************

@interface MYHostView : UIView
@property (strong, nonatomic) MYLive *live;

@end


@interface MYLiveView : UIView
@property (strong, nonatomic) MYLive *live;
@property (weak, nonatomic) id <MYLiveViewDelegate> delegate;


@end
