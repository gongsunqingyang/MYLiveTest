//
//  MYHomeTableCellLayout.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYHomeTableCellLayout.h"
#import <YYKit.h>
#import "MYMacros.h"


//*****************简介容器********************
@implementation MYCardLayout
- (void)setLive:(MYLive *)live{
    _live = live;
    
    CGFloat h = 64;
    _avatarFrame = CGRectMake(10, 10, h - 20, h - 20);
    
    CGSize nameLabelSize = [live.creator.nick boundingRectWithSize:CGSizeMake(kScreenWidth * 0.6, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kNameLabelFont} context:nil].size;
    CGFloat nameLabelX = CGRectGetMaxX(_avatarFrame) + 10;
    _nameLabelFrame = (CGRect){{nameLabelX, 10}, nameLabelSize};
    
    CGSize cityLabelSize = [live.city boundingRectWithSize:CGSizeMake(kScreenWidth * 0.6, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kCityLabelFont} context:nil].size;
    CGFloat cityLabelY = CGRectGetMaxY(_avatarFrame) - cityLabelSize.height;
    _cityLabelFrame = (CGRect){{nameLabelX, cityLabelY}, cityLabelSize};
    
    NSMutableAttributedString *onlineText = [[NSMutableAttributedString alloc] init];
    {
    
        NSMutableAttributedString *onlineNumText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(live.online_users)]];
        onlineNumText.font = kOnlineLabelNumFont;
        onlineNumText.lineSpacing = 3;
        onlineNumText.color = [UIColor orangeColor];
        onlineNumText.alignment = NSTextAlignmentRight;
        [onlineText appendAttributedString:onlineNumText];
        
        NSMutableAttributedString *onlineDescText = [[NSMutableAttributedString alloc] initWithString:@"\n在看"];
        onlineDescText.font = kOnlineLabelDescFont;
        onlineDescText.color = [UIColor lightGrayColor];
        onlineDescText.alignment = NSTextAlignmentRight;
        [onlineText appendAttributedString:onlineDescText];
        
        CGSize onlineSize = CGSizeMake(100, h - 20);
        CGFloat onlineX = kScreenWidth - onlineSize.width - 10;
        CGFloat onlineY = (h - onlineSize.height)/2;
        _onlineLabelFrame = (CGRect){{onlineX, onlineY}, onlineSize};
        
        YYTextContainer *onlineContainer = [YYTextContainer containerWithSize:onlineSize insets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _onlineLayout = [YYTextLayout layoutWithContainer:onlineContainer text:onlineText];        
    }
    
    _frame = CGRectMake(0, 0, kScreenWidth, h);
}

@end


//*****************实时截图********************
@implementation MYLiveIVLayout
- (void)setLive:(MYLive *)live{
    _live = live;
    
    CGSize statusSize = CGSizeMake(50, 20);
    if ([live.live_type isEqualToString:@""]) {
        
        YYTextBorder *border = [YYTextBorder borderWithLineStyle:YYTextLineStyleSingle lineWidth:1 strokeColor:[UIColor whiteColor]];
        border.cornerRadius = statusSize.height/2;
        border.insets = UIEdgeInsetsMake(-1, -10, -1, -10);
        border.fillColor = [UIColor colorWithWhite:0 alpha:0.1];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"直播"];
        text.textBorder = border;
        text.font = kStatusLabelFont;
        text.color = [UIColor whiteColor];
        
        YYTextContainer *statusContainer = [YYTextContainer containerWithSize:CGSizeMake(50, 20) insets:UIEdgeInsetsMake(0, 12, 0, 12)];
        _statusLayout = [YYTextLayout layoutWithContainer:statusContainer text:text];
    
        
    }else{
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" "];
        
        YYTextContainer *statusContainer = [YYTextContainer containerWithSize:CGSizeMake(50, 20) insets:UIEdgeInsetsMake(0, 12, 0, 12)];
        _statusLayout = [YYTextLayout layoutWithContainer:statusContainer text:text];
        

    }
    
    CGFloat statusX = kScreenWidth - statusSize.width - 10;
    _statusLabelFrame = (CGRect){{statusX, 10}, statusSize};
    
    _blurFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.8);
    _frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.8);
}

@end


//*****************Cell********************

@implementation MYHomeTableCellLayout
- (void)setLive:(MYLive *)live{
    _live = live;
    
    _cardLayout = [[MYCardLayout alloc] init];
    _cardLayout.live = live;
    
    _liveIVLayout = [[MYLiveIVLayout alloc] init];
    _liveIVLayout.live = live;
    
    CGFloat liveIVY = CGRectGetMaxY(_cardLayout.frame);
    _liveIVLayout.frame = (CGRect){{0, liveIVY}, _liveIVLayout.frame.size};
    
    _h = CGRectGetMaxY(_liveIVLayout.frame);
}

@end
