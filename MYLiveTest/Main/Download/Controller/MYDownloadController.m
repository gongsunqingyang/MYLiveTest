//
//  MYDownloadController.m
//  MYLiveTest
//
//  Created by yanglin on 2017/3/21.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYDownloadController.h"
#import "MYLiveController.h"
#import "MYLive.h"

#import <SVProgressHUD.h>

@interface MYDownloadController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;

@end

@implementation MYDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];

}

// 进入直播
- (IBAction)clickEnter {
    MYLive *live = [[MYLive alloc] init];
    
    if (_urlTextView.text.length) {
        live.stream_addr = _urlTextView.text;
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    
    MYLiveController *vc = [[MYLiveController alloc] init];
    vc.live = live;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
