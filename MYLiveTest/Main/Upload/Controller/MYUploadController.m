//
//  MYUploadController.m
//  MYLiveTest
//
//  Created by yanglin on 2017/3/20.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYUploadController.h"
#import <Masonry.h>
#import <UIView+YYAdd.h>
#import "LSMediaCapture.h"
#import "MYPublicHeader.h"
#import "MYMediaCaptureEntity.h"


@interface MYUploadController ()
@property (strong, nonatomic) UIView *captureView;                          //视频预览
@property (strong, nonatomic) UIAlertView *detailView;                      //详情视图
@property (strong, nonatomic) UIButton *uploadBtn;                          //推流按钮
@property (strong, nonatomic) UIButton *settingBtn;                         //修改按钮
@property (strong, nonatomic) UIButton *detailBtn;                          //展示详情
@property (strong, nonatomic) UIButton *screenShotBtn;                      //截图按钮
@property (strong, nonatomic) UISwitch *cameraSwitch;                       //切换摄像头开关
@property (strong, nonatomic) UISlider *scaleSlider;                        //缩放滑块
@property (strong, nonatomic) UISlider *contrastSlider;                     //对比度滑块
@property (strong, nonatomic) UISlider *smoothSlider;                       //磨皮滑块


@property (strong, nonatomic) LSMediaCapture *mediaCapture;                 //直播类（用于推流）
@property (assign, nonatomic) BOOL bVideoAuthed;
@property (assign, nonatomic) BOOL bAudioAuthed;
@property (assign, nonatomic) BOOL isLiving;
@property (strong, nonatomic) MYMediaCaptureEntity *entity;                 //直播参数实体

@end


@implementation MYUploadController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopUpload];
}

- (void)dealloc{
    kRemoveAllNotification;
    [self removeObserver:self forKeyPath:@"isLiving" context:nil];
    
    // 释放占有的系统资源
    [_mediaCapture unInitLiveStream];
}

- (instancetype)initWithEntity:(MYMediaCaptureEntity *)entity{
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
    [self addObservers];
    [self config];
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _captureView = [[UIView alloc] init];
    _captureView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_captureView];
    
    _detailView = [[UIAlertView alloc] initWithTitle:@"直播详情" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    
    _uploadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_uploadBtn addTarget:self action:@selector(clickUploadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadBtn setTitle:@"开始推流" forState:UIControlStateNormal];
    [_uploadBtn setTitle:@"停止推流" forState:UIControlStateSelected];
    [self.view addSubview:_uploadBtn];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_settingBtn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    [_settingBtn setTitle:@"修改参数" forState:UIControlStateNormal];
    [self.view addSubview:_settingBtn];
    
    _detailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailBtn.enabled = NO;
    [_detailBtn addTarget:self action:@selector(clickDetailBtn) forControlEvents:UIControlEventTouchUpInside];
    [_detailBtn setTitle:@"展示详情" forState:UIControlStateNormal];
    [self.view addSubview:_detailBtn];
    
    _screenShotBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _screenShotBtn.enabled = NO;
    [_screenShotBtn addTarget:self action:@selector(clickScreenShotBtn) forControlEvents:UIControlEventTouchUpInside];
    [_screenShotBtn setTitle:@"截图" forState:UIControlStateNormal];
    [self.view addSubview:_screenShotBtn];
    
    _cameraSwitch = [[UISwitch alloc] init];
    [_cameraSwitch addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_cameraSwitch];
    
    _scaleSlider = [[UISlider alloc] init];
    _scaleSlider.minimumValue = 1;
    _scaleSlider.maximumValue = 20;
    _scaleSlider.value = 1;
    [_scaleSlider addTarget:self action:@selector(changeScale:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_scaleSlider];
    
    _contrastSlider = [[UISlider alloc] init];
    _contrastSlider.minimumValue = 0;
    _contrastSlider.maximumValue = 4;
    _contrastSlider.value = 0;
    [_contrastSlider addTarget:self action:@selector(changeContrast:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_contrastSlider];
    
    _smoothSlider = [[UISlider alloc] init];
    _smoothSlider.minimumValue = 0;
    _smoothSlider.maximumValue = 1;
    _smoothSlider.value = 0;
    [_smoothSlider addTarget:self action:@selector(changeSmooth:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_smoothSlider];
}

- (void)setupConstraints{
    
    __weak __typeof(self) ws = self;
    
    [_captureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide);
        make.bottom.equalTo(ws.mas_bottomLayoutGuide);
        make.left.right.equalTo(ws.view);
    }];
    
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide);
        make.right.equalTo(ws.view).offset(-10);
        make.right.equalTo(@[_uploadBtn, _settingBtn, _detailBtn, _screenShotBtn]);
    }];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadBtn.mas_bottom);
    }];
    
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_settingBtn.mas_bottom);
    }];
    
    [_screenShotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailBtn.mas_bottom);
    }];
    
    [_cameraSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide).offset(10);
        make.left.equalTo(ws.view).offset(10);
        make.left.equalTo(@[_scaleSlider, _contrastSlider, _smoothSlider]);
    }];
    
    [_scaleSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cameraSwitch.mas_bottom).offset(10);
        make.width.mas_equalTo(200);
        make.width.equalTo(@[_contrastSlider, _contrastSlider, _smoothSlider]);
    }];
    
    [_contrastSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scaleSlider.mas_bottom).offset(10);
    }];
    
    [_smoothSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contrastSlider.mas_bottom).offset(10);
    }];
}

- (void)addObservers{
    kAddNotification(self, @selector(noti_start), LS_LiveStreaming_Started, nil);       //!< 直播推流已经开始
    kAddNotification(self, @selector(noti_finished), LS_LiveStreaming_Finished, nil);   //!< 直播推流已经结束
    kAddNotification(self, @selector(noti_bad), LS_LiveStreaming_Bad, nil);             //!< 直播推流状况不好，建议降低分辨率
    kAddNotification(self, @selector(noti_eof), LS_AudioFile_eof, nil);                 //!< 当前audio文件播放结束
    [self addObserver:self forKeyPath:@"isLiving" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 初始化直播类
- (void)config{
    
    // 请求授权
    NSError* error = nil;
    BOOL success = [self requestMediaCapturerAccess:&error];
    if (!success) {
        NSLog(@"授权失败 %@", error);
        return;
    }
    
    __weak __typeof(self) ws = self;
    
    // 初始化直播类
//    _mediaCapture = [[LSMediaCapture alloc] initLiveStream:kStreamUlr];
    _mediaCapture = [[LSMediaCapture alloc] initLiveStream:_entity.url withLivestreamParaCtx:_entity.streamingCtx];
    
    // 直播统计信息回调
    _mediaCapture.onStatisticInfoGot = ^(LSStatistics* statistics){
        if (statistics != nil) {
            LSStatistics statis;
            memcpy(&statis, statistics, sizeof(LSStatistics));
            
            dispatch_async(dispatch_get_main_queue(),^(void) {
                [ws setupDetailView:statis];
            });
        }
    };
    
    // 缩放回调
    _mediaCapture.maxZoomScale = _scaleSlider.maximumValue;
    _mediaCapture.onZoomScaleValueChanged = ^(CGFloat value){
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.scaleSlider.value = value;
        });
    };
    
    // 设置预览视图
    [self.view layoutIfNeeded];
    [_mediaCapture startVideoPreview:_captureView];
    
    // 添加水印
    UIImage* waterImg = [UIImage imageNamed:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"water.png"]];
    [_mediaCapture addWaterMark:waterImg rect:CGRectMake(0, 0, 64, 40) location:LS_WATERMARK_LOCATION_RIGHTUP];
}


// 点击推流按钮
- (void)clickUploadBtn:(UIButton *)btn{
    _uploadBtn.selected = !btn.selected;
    if (btn.selected) {
        [self beginUpload];
    }else{
        [self stopUpload];
    }
}

// 点击修改按钮
- (void)clickSettingBtn{
    [_mediaCapture setVideoParameters:LS_VIDEO_QUALITY_LOW bitrate:64000 fps:20 cameraOrientation:LS_CAMERA_ORIENTATION_PORTRAIT];
}

// 点击展示详情按钮
- (void)clickDetailBtn{
    [_detailView show];
}

// 点击截图按钮
- (void)clickScreenShotBtn{

    [_mediaCapture snapShotWithCompletionBlock:^(UIImage *latestFrameImage) {
        NSLog(@"截图");
        UIImageWriteToSavedPhotosAlbum(latestFrameImage, self, nil, nil);
    }];
}

// 切换摄像头
- (void)changeCamera:(UISwitch *)sender {
    [_mediaCapture switchCamera];
}

// 缩放
- (void)changeScale:(UISlider *)sender {
    _mediaCapture.zoomScale = sender.value;
}

// 对比度
- (void)changeContrast:(UISlider *)sender {
    [_mediaCapture setContrastFilterIntensity:sender.value];
}

// 磨皮
- (void)changeSmooth:(UISlider *)sender {
    [_mediaCapture setSmoothFilterIntensity:sender.value];
}

// 开始推流
- (void)beginUpload{
    
    __weak __typeof(self) ws = self;
    
    // 错误回调
    _mediaCapture.onLiveStreamError = ^(NSError *error){
        NSLog(@"onLiveStreamError : %@", error);
        [ws stopUpload];
    };
    
    //准备开始推流
    NSError *error;
    [_mediaCapture startLiveStreamWithError:&error];
    
    if (error) {
        NSLog(@"准备推流失败 ：%@", error);
    }
}

// 结束推流
- (void)stopUpload{
    [_mediaCapture stopLiveStream:^(NSError *error) {
        if (error == nil) {
            NSLog(@"直播结束了");
        }else{
            NSLog(@"结束直播发生错误");//需要等待一会儿，譬如sleep（2）后，再次调用 stopLiveStream()
        }
    }];
}

// 设置详情视图数据
- (void)setupDetailView:(LSStatistics)statistics{
    NSString* fps = [[NSString alloc]initWithFormat:@"帧率:%d", statistics.videoSendFrameRate];
    NSString* bitrate = [[NSString alloc]initWithFormat:@"码率:%d", statistics.videoSendBitRate];
    NSString *width = [NSString stringWithFormat:@"宽:%d", statistics.videoSendWidth];
    NSString *height = [NSString stringWithFormat:@"高:%d", statistics.videoSendHeight];
    NSString* videoQuality = nil;
    
    int iWidth = MAX(statistics.videoSetHeight, statistics.videoSetWidth);
    //这个不准确，需要根据pStatistic 的width和height去判断，但是比较累赘，所以，此处省略了
    switch (iWidth / 16 ) {
        case (1280 / 16):
            videoQuality = [[NSString alloc] initWithFormat:@"超高清"];
            break;
        case (960 /16):
            videoQuality = [[NSString alloc] initWithFormat:@"超清"];
            break;
        case (640 / 16):
            videoQuality = [[NSString alloc] initWithFormat:@"高清"];
            break;
        case (480 / 16):
            videoQuality = [[NSString alloc] initWithFormat:@"标清"];
            break;
        case (352 / 16):
            videoQuality = [[NSString alloc] initWithFormat:@"流畅"];
            break;
        default:
            break;
    }
    
    NSString* statInfo = [[NSString alloc] initWithFormat:@"%@\n %@\n %@\n %@\n %@\n", videoQuality, fps, bitrate, width, height];
    _detailView.message = statInfo;
}


// 应用程序需要事先申请音视频使用权限
- (BOOL)requestMediaCapturerAccess:(NSError **)outError{
    self.bVideoAuthed  = NO;
    self.bAudioAuthed  = NO;
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        self.bVideoAuthed = YES;
    }];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        self.bAudioAuthed = YES;
    }];
    
    while (!self.bVideoAuthed || !self.bAudioAuthed) {
        usleep(10000);
    }
    
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        return YES;
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请到【设置】-【隐私】-【相机】修改权限");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            if (*outError != NULL) {
                *outError = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            }
            return NO;
        }
        
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请到【设置】-【隐私】-【麦克风】修改权限");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            if (*outError != NULL) {
                *outError = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            }
            return NO;
        }
    }
    return YES;
}


#pragma mark - 直播通知
- (void)noti_start{
    NSLog(@"直播通知 start");
    self.isLiving = YES;
}

- (void)noti_finished{
    NSLog(@"直播通知 finished");
    self.isLiving = NO;
}

- (void)noti_bad{
    NSLog(@"直播通知 bad");
}

- (void)noti_eof{
    NSLog(@"直播通知 eof");
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isLiving"]) {
        BOOL isLiving = [[change valueForKey:@"new"] boolValue];
        NSLog(@"KVO - isLiving = %@", @(isLiving));
        dispatch_async(dispatch_get_main_queue(), ^{
            _detailBtn.enabled = isLiving;
            _screenShotBtn.enabled = isLiving;
        });
    }
}

@end
