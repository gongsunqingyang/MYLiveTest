//
//  MYLiveController.m
//  MYLiveTest
//
//  Created by yanglin on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYLiveController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <YYKit.h>
#import <Masonry.h>
#import <Chameleon.h>
#import "MYLive.h"
#import "MYLiveView.h"
#import "MYMacros.h"

@interface MYLiveController ()<MYLiveViewDelegate, IJKMediaUrlOpenDelegate, IJKMediaNativeInvokeDelegate>
@property (strong, nonatomic) UIImage *bgImg;
@property (strong, nonatomic) UIImageView *bgIV;
@property (strong, nonatomic) IJKFFMoviePlayerController *player;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) MYLiveView *liveView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *backBtn;



@end

@implementation MYLiveController

- (instancetype)initWithLive:(MYLive *)live avatar:(UIImage *)image{
    self = [super init];
    if (self) {
        _live = live;
        _bgImg = image;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self addObservers];
    
    [_player prepareToPlay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    kRemoveAllNotification;

    [self.player shutdown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupContraints];
}

- (void)setupViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //背景
    _bgIV = [[UIImageView alloc] init];
    _bgIV.contentMode = UIViewContentModeScaleAspectFill;
    _bgIV.clipsToBounds = YES;
    _bgIV.image = _bgImg;
    [self.view addSubview:_bgIV];
    
    //播放器
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:_live.stream_addr withOptions:nil];
//    _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:@"rtmp://v8f1d1917.live.126.net/live/5a4b84f051044e358f4264716624d28b" withOptions:nil];
    _player.shouldAutoplay = YES;
    _player.liveOpenDelegate = self;
    _player.nativeInvokeDelegate = self;
    [self.view addSubview:_player.view];
    
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
    _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    //ScrollView容器
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentView];
    
    //直播间视图
    _liveView = [[MYLiveView alloc] init];
    _liveView.live = _live;
    _liveView.delegate = self;
    [_contentView addSubview:_liveView];
    
    //播放or暂停
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setTitle:@"pause" forState:UIControlStateNormal];
    [_playBtn setTitle:@"play" forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    //返回
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitle:@"back" forState:UIControlStateNormal];
    [_backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

- (void)setupContraints{

    __weak __typeof(self) ws = self;
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView).multipliedBy(2);
        make.height.equalTo(_scrollView);
    }];
    
    [_liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_contentView).multipliedBy(0.5);
        make.top.right.bottom.equalTo(_contentView);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backBtn);
        make.right.equalTo(_backBtn.mas_left).offset(-10);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).offset(-15);
        make.right.equalTo(ws.view).offset(-10);
    }];
}

- (void)playBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [_player pause];
    }else{
        [_player play];
    }
}

- (void)addObservers{
    
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerScalingModeDidChangeNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerPlaybackDidFinishNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerPlaybackStateDidChangeNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerLoadStateDidChangeNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMovieNaturalSizeAvailableNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerVideoDecoderOpenNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerFirstVideoFrameRenderedNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerFirstAudioFrameRenderedNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerDidSeekCompleteNotification, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerDidSeekCompleteTargetKey, nil);
//    kAddNotification(self, @selector(notification:), IJKMPMoviePlayerDidSeekCompleteErrorKey, nil);
}

- (void)notification:(NSNotification *)notification{
    NSLog(@"通知 <%@>, playbackState = %@", notification.name, @(_player.playbackState));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [self.player shutdown];
}

#pragma mark - MYLiveViewDelegate

- (void)liveView:(MYLiveView *)liveView didClickBtnType:(MYLiveViewBtnType)type{
    NSLog(@"代理方法 <MYLiveViewDelegate> = %@", @(type));
}

#pragma mark - IJKMediaUrlOpenDelegate

- (void)willOpenUrl:(IJKMediaUrlOpenData *)urlOpenData{
    NSLog(@"代理方法 <IJKMediaUrlOpenDelegate>");
}

#pragma mark - IJKMediaNativeInvokeDelegate

- (int)invoke:(IJKMediaEvent)event attributes:(NSDictionary *)attributes{
    NSLog(@"代理方法 <IJKMediaNativeInvokeDelegate>");
    return event;
}


@end
