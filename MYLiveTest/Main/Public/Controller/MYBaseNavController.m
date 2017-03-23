//
//  WFBaseNavController.m
//  FreeWiFi
//
//  Created by yanglin on 2016/11/23.
//  Copyright © 2016年 com.chuangxin. All rights reserved.
//

#import "MYBaseNavController.h"

@interface MYBaseNavController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MYBaseNavController

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];//隐藏阴影
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];//渲染颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];//标题文字属性
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
