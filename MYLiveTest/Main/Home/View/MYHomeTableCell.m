//
//  MYHomeTableCell.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYHomeTableCell.h"
#import <Masonry.h>
#import <YYKit.h>
#import <Chameleon.h>


@interface MYHomeTableCell ()
@property (strong, nonatomic) UIView *cardView;//简介容器
@property (strong, nonatomic) UIVisualEffectView *blur;//模糊
@property (strong, nonatomic) UIImageView *avatar;//头像
@property (strong, nonatomic) YYLabel *nameLabel;//昵称
@property (strong, nonatomic) YYLabel *cityLabel;//城市
@property (strong, nonatomic) YYLabel *onlineLabel;//在线人数
@property (strong, nonatomic) YYLabel *statusLabel;//直播状态

@end

@implementation MYHomeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cardView = [[UIView alloc] init];
    [self.contentView addSubview:_cardView];

    _liveIV = [[UIImageView alloc] init];
    _liveIV.contentMode = UIViewContentModeScaleAspectFill;
    _liveIV.clipsToBounds = YES;
    _liveIV.userInteractionEnabled = YES;
    [self.contentView addSubview:_liveIV];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _blur = [[UIVisualEffectView alloc] initWithEffect:effect];
    [_liveIV addSubview:_blur];
    
    UITapGestureRecognizer *tapLiveIV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveIVClick)];
    [_liveIV addGestureRecognizer:tapLiveIV];
    
    _avatar = [[UIImageView alloc] init];
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.clipsToBounds = YES;
    [_cardView addSubview:_avatar];
    
    _nameLabel = [[YYLabel alloc] init];
    _nameLabel.font = kNameLabelFont;
    _nameLabel.textColor = [UIColor lightGrayColor];
    [_cardView addSubview:_nameLabel];
    
    _cityLabel = [[YYLabel alloc] init];
    _cityLabel.font = kCityLabelFont;
    _cityLabel.textColor = [UIColor lightGrayColor];
    [_cardView addSubview:_cityLabel];
    
    _onlineLabel = [[YYLabel alloc] init];
    _onlineLabel.numberOfLines = 0;
    [_cardView addSubview:_onlineLabel];
    
    _statusLabel = [[YYLabel alloc] init];
    [_liveIV addSubview:_statusLabel];
}

- (void)setLayout:(MYHomeTableCellLayout *)layout{
    _layout = layout;
    
    MYLive *live = layout.live;
    [_liveIV setImageWithURL:[NSURL URLWithString:live.creator.portrait] placeholder:nil];
    [_avatar setImageWithURL:[NSURL URLWithString:live.creator.portrait] placeholder:nil];
    _nameLabel.text = live.creator.nick;
    _cityLabel.text = live.city;
    _onlineLabel.textLayout = layout.cardLayout.onlineLayout;
    _statusLabel.textLayout = layout.liveIVLayout.statusLayout;
    
    _cardView.frame = layout.cardLayout.frame;
    _liveIV.frame = layout.liveIVLayout.frame;
    _blur.frame = layout.liveIVLayout.blurFrame;
    _avatar.frame = layout.cardLayout.avatarFrame;
    _avatar.layer.cornerRadius = layout.cardLayout.avatarFrame.size.height/2;
    _avatar.layer.masksToBounds = YES;
    _nameLabel.frame = layout.cardLayout.nameLabelFrame;
    _cityLabel.frame = layout.cardLayout.cityLabelFrame;
    _onlineLabel.frame = layout.cardLayout.onlineLabelFrame;
    _statusLabel.frame = layout.liveIVLayout.statusLabelFrame;

}

//点击实时截图
- (void)liveIVClick{
    if (_liveBlock) {
        _liveBlock(_layout.live);
    }
}

@end
