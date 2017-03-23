//
//  MYLiveView.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYLiveView.h"
#import <YYKit.h>
#import <Masonry.h>
#import <Chameleon.h>
#import "MYMacros.h"
#import "MYLive.h"


//**********************MYHostView*****************************

@interface MYHostView ()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarIV;
@property (strong, nonatomic) YYLabel *statusLabel;
@property (strong, nonatomic) YYLabel *followLabel;
@property (strong, nonatomic) UIButton *followBtn;

@end

@implementation MYHostView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupContraints];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    
    _avatarIV = [[UIImageView alloc] init];
    _avatarIV.contentMode = UIViewContentModeScaleAspectFill;
    _avatarIV.clipsToBounds = YES;
    [self addSubview:_avatarIV];
    
    _statusLabel = [[YYLabel alloc] init];
    _statusLabel.font = kFont(10);
    _statusLabel.textColor = [UIColor whiteColor];
    [self addSubview:_statusLabel];
    
    _followLabel = [[YYLabel alloc] init];
    _followLabel.font = kFont(10);
    _followLabel.textColor = [UIColor whiteColor];
    [self addSubview:_followLabel];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.backgroundColor = [UIColor orangeColor];
    _followBtn.titleLabel.font = kFont(12);
    [_followBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followBtn];
    
}

- (void)setupContraints{
    __weak __typeof(self) ws = self;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws);
    }];
    
    [_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws).offset(1);
        make.bottom.equalTo(ws).offset(-1);
        make.height.equalTo(_avatarIV.mas_width);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarIV.mas_right).offset(10);
        make.top.equalTo(ws).offset(3);
    }];
    
    [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarIV.mas_right).offset(10);
        make.bottom.equalTo(ws);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(ws).offset(-3);
        make.top.equalTo(ws).offset(3);
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _bgView.layer.cornerRadius = _bgView.height/2;
    _avatarIV.layer.cornerRadius = _bgView.height/2;
    _followBtn.layer.cornerRadius = _followBtn.height/2;
}

- (void)setLive:(MYLive *)live{
    _live = live;
    
    [_avatarIV setImageWithURL:[NSURL URLWithString:live.creator.portrait] placeholder:[UIImage imageWithColor:FlatBlue]];
    _statusLabel.text = @"直播";
    _followLabel.text = [NSString stringWithFormat:@"%@",@(live.online_users)];

}

- (void)followBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor lightGrayColor];
    }else{
        btn.backgroundColor = [UIColor orangeColor];
    }
}

@end

//**********************MYLiveView*****************************

@interface MYLiveView ()
@property (strong, nonatomic) MYHostView *hostView;
@property (strong, nonatomic) UIView *audienceView;
@property (strong, nonatomic) YYLabel *creatorIDLabel;
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIButton *textBtn;
@property (strong, nonatomic) UIButton *recordBtn;
@property (strong, nonatomic) UIButton *mailBtn;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation MYLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupContraints];
    }
    return self;
}

- (void)setupViews{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    _hostView = [[MYHostView alloc] init];
    [self addSubview:_hostView];
    
    _audienceView = [[UIView alloc] init];
    _audienceView.backgroundColor = FlatBlue;
    [self addSubview:_audienceView];
    
    _creatorIDLabel = [[YYLabel alloc] init];
    _creatorIDLabel.textColor = [UIColor lightGrayColor];
    _creatorIDLabel.font = kFont(12);
    [self addSubview:_creatorIDLabel];
    
    _textView = [[YYTextView alloc] init];
    _textView.showsVerticalScrollIndicator = NO;
    [self addSubview:_textView];
    
    _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _textBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _textBtn.clipsToBounds = YES;
    _textBtn.tag = MYLiveViewBtnType_Text;
    [_textBtn setImage:kImg(@"delete") forState:UIControlStateNormal];
    [_textBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_textBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textBtn];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _recordBtn.clipsToBounds = YES;
    _recordBtn.tag = MYLiveViewBtnType_Record;
    [_recordBtn setImage:kImg(@"delete") forState:UIControlStateNormal];
    [_recordBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_recordBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordBtn];

    _mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mailBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _mailBtn.clipsToBounds = YES;
    _mailBtn.tag = MYLiveViewBtnType_Mail;
    [_mailBtn setImage:kImg(@"delete") forState:UIControlStateNormal];
    [_mailBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_mailBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mailBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _shareBtn.clipsToBounds = YES;
    _shareBtn.tag = MYLiveViewBtnType_Share;
    [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shareBtn setImage:kImg(@"delete") forState:UIControlStateNormal];
    [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shareBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];
    
}

- (void)setupContraints{
    __weak __typeof(self) ws = self;
    
    [_hostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws).offset(10);
        make.top.equalTo(ws).offset(30);
        make.size.mas_equalTo(CGSizeMake(130, 28));
    }];
    
    [_audienceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hostView.mas_right).offset(10);
        make.right.equalTo(ws).offset(-10);
        make.centerY.equalTo(_hostView);
        make.height.equalTo(_hostView);
    }];
    
    [_creatorIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws).offset(-10);
        make.top.equalTo(_audienceView.mas_bottom).offset(10);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ws).multipliedBy(0.2);
        make.left.equalTo(ws).offset(10);
        make.right.equalTo(ws).offset(-10);
        make.bottom.equalTo(_textBtn.mas_top).offset(-10);
    }];
    
    [_textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@[_recordBtn, _mailBtn, _shareBtn]);
        make.bottom.equalTo(@[_recordBtn, _mailBtn, _shareBtn]);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(ws).offset(10);
        make.bottom.equalTo(ws).offset(-10);
    }];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mailBtn.mas_left).offset(-10);
    }];
    
    [_mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shareBtn.mas_left).offset(-10);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws).offset(-120);
    }];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _textBtn.layer.cornerRadius = _textBtn.height/2;
    _recordBtn.layer.cornerRadius = _recordBtn.height/2;
    _mailBtn.layer.cornerRadius = _mailBtn.height/2;
    _shareBtn.layer.cornerRadius = _shareBtn.height/2;
}

- (void)setLive:(MYLive *)live{
    _live = live;
    
    _hostView.live = live;
    _creatorIDLabel.text = [NSString stringWithFormat:@"主播ID：%@", @(live.online_users)];
    _textView.text = @"XXXX\nXXXXXX\nXXXXXXXXXXXXXXX\nXXXXXXXX\nXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXX\nXXXXXX\nXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXX\nXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXX\nXXXXXX\nXXXXXXXXXXXX\nXXXX\nXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXX\nXXXXX\nXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXX";
}

- (void)didClickBtn:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveView:didClickBtnType:)]) {
        [self.delegate liveView:self didClickBtnType:btn.tag];
    }
}



@end
