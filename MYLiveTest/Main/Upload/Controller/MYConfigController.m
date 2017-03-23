//
//  MYConfigController.m
//  MYLiveTest
//
//  Created by yanglin on 2017/3/21.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#define SQBITRATE 650000
#define HQBITRATE 600000
#define MQBITRATE 300000
#define LQBITRATE 200000

#import "MYConfigController.h"
#import "LSMediaCapture.h"
#import "MYMediaCaptureEntity.h"
#import "MYUploadController.h"

@interface MYConfigController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (weak, nonatomic) IBOutlet UITextField *frameTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *clarityControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *wideScreenControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *decodeControl;
@property (weak, nonatomic) IBOutlet UISwitch *zoomSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISwitch *watermarkSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *qosSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *frontMirroredSwitch;

@property (assign, nonatomic) LSLiveStreamingParaCtx streamingCtx;
@property (assign, nonatomic) LSVideoParaCtx videoCtx;
@property (assign, nonatomic) LSAudioParaCtx audioCtx;




@end

@implementation MYConfigController

- (void)viewDidLoad {
    [super viewDidLoad];

}



- (IBAction)clickEnterBtn {
    
    if (!_urlTextView.text.length || !_frameTextView.text.length) {
        return;
    }
    
    _videoCtx.fps = [_frameTextView.text intValue];
    
    [self setupBitrate];
    [self setupWideScreen];
    [self setupCode];
    [self setupZoom];
    [self setupFilter];
    [self setupDirection];
    [self setupWatermark];
    [self setupQos];
    [self setupFrontMirrored];
    
    _audioCtx.bitrate       = 64000;
    _audioCtx.codec         = LS_AUDIO_CODEC_AAC;
    _audioCtx.frameSize     = 2048;
    _audioCtx.numOfChannels = 1;
    _audioCtx.samplerate    = 44100;
    
    
    _streamingCtx.sLSVideoParaCtx = _videoCtx;
    _streamingCtx.sLSAudioParaCtx = _audioCtx;
    _streamingCtx.eOutFormatType               = LS_OUT_FMT_RTMP;
    _streamingCtx.eOutStreamType               = LS_HAVE_AV;                        //设置推音视频流／音频流／视频流
    _streamingCtx.uploadLog                    = YES;                               //是否上传sdk日志

    MYMediaCaptureEntity *entity = [MYMediaCaptureEntity sharedInstance];
    entity.streamingCtx = _streamingCtx;
    entity.url = _urlTextView.text;
    
    MYUploadController *vc = [[MYUploadController alloc] initWithEntity:entity];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 设置帧率
- (void)setupBitrate{
    switch (_clarityControl.selectedSegmentIndex) {
        case 0:
            _videoCtx.bitrate = SQBITRATE;
            _videoCtx.videoStreamingQuality = LS_VIDEO_QUALITY_SUPER;
            break;
        case 1:
            _videoCtx.bitrate = HQBITRATE;
            _videoCtx.videoStreamingQuality = LS_VIDEO_QUALITY_HIGH;
            break;
        case 2:
            _videoCtx.bitrate = MQBITRATE;
            _videoCtx.videoStreamingQuality = LS_VIDEO_QUALITY_MEDIUM;
            break;
        case 3:
            _videoCtx.bitrate = LQBITRATE;
            _videoCtx.videoStreamingQuality = LS_VIDEO_QUALITY_LOW;
            break;
        default:
            break;
    }
}

// 设置宽屏
- (void)setupWideScreen{
    switch (_wideScreenControl.selectedSegmentIndex) {
        case 0:
            _videoCtx.videoRenderMode = LS_VIDEO_RENDER_MODE_SCALE_16x9;
            break;
        case 1:
            _videoCtx.videoRenderMode = LS_VIDEO_RENDER_MODE_SCALE_NONE;
            break;
        default:
            break;
    }
}

// 解码方式
- (void)setupCode{
    switch (_clarityControl.selectedSegmentIndex) {
        case 0:
            _streamingCtx.eHaraWareEncType = LS_HRD_NO;
            break;
        case 1:
            _streamingCtx.eHaraWareEncType = LS_HRD_AV;
            break;
        default:
            break;
    }
}

// 变焦
- (void)setupZoom{
    if (_zoomSwitch.isOn) {
        _videoCtx.isCameraZoomPinchGestureOn = YES;
    }else{
        _videoCtx.isCameraZoomPinchGestureOn = NO;
    }
}

// 选择滤镜
- (void)setupFilter{
    
    //开启滤镜
    _videoCtx.isVideoFilterOn = YES;
    
    switch (_filterControl.selectedSegmentIndex) {
        case 0:
            _videoCtx.filterType = LS_GPUIMAGE_SEPIA;
            break;
        case 1:
            _videoCtx.filterType = LS_GPUIMAGE_ZIRAN;
            break;
        case 2:
            _videoCtx.filterType = LS_GPUIMAGE_MEIYAN1;
            break;
        case 3:
            _videoCtx.filterType = LS_GPUIMAGE_MEIYAN2;
            break;
        case 4:
            _videoCtx.filterType = LS_GPUIMAGE_NORMAL;
            break;
        default:
            break;
    }
}

// 采集方向
- (void)setupDirection{
    switch (_directionControl.selectedSegmentIndex) {
        case 0:
            _videoCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_PORTRAIT;
            break;
        case 1:
            _videoCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_UPDOWN;
            break;
        case 2:
            _videoCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_RIGHT;
            break;
        case 3:
            _videoCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_LEFT;
            break;
        default:
            break;
    }
}

// 水印
- (void)setupWatermark{
    if (_watermarkSwitch.isOn) {
        _videoCtx.isVideoWaterMarkEnabled = YES;
    }else{
        _videoCtx.isVideoWaterMarkEnabled = NO;
    }
}

// Qos
- (void)setupQos{
    if (_qosSwitch.isOn) {
        _videoCtx.isQosOn = YES;
    }else{
        _videoCtx.isQosOn = NO;
    }
}

// 镜像前置摄像头
- (void)setupFrontMirrored{
    if (_frontMirroredSwitch.isOn) {
        _videoCtx.isFrontCameraMirrored = YES;
    }else{
        _videoCtx.isFrontCameraMirrored = NO;
    }
}

@end
