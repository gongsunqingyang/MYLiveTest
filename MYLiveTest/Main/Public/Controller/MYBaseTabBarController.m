//
//  WFBaseTabBarController.m
//  FreeWiFi
//
//  Created by yanglin on 2016/11/23.
//  Copyright © 2016年 com.chuangxin. All rights reserved.
//

#import "MYBaseTabBarController.h"
#import "MYBaseNavController.h"
#import "MYHomeController.h"
#import "MYConfigController.h"
#import "MYDownloadController.h"

@interface MYBaseTabBarController ()
@property (nonatomic, assign) NSInteger previousClickedTag;

@end

@implementation MYBaseTabBarController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self setupBaseNavViewControllreClass:NSStringFromClass([MYHomeController class])
                          selectImageName:@"wifi_btn"
                        unSelectImageName:@"wifi"
                                    title:@"热门"];
    [self setupBaseNavViewControllreClass:NSStringFromClass([MYConfigController class])
                          selectImageName:@"me_btn"
                        unSelectImageName:@"me"
                                    title:@"推流"];
    [self setupBaseNavViewControllreClass:NSStringFromClass([MYDownloadController class])
                          selectImageName:@"me_btn"
                        unSelectImageName:@"me"
                                    title:@"拉流"];
}


/**
 设置TabBar公共属性
 */
- (void)setupAppearance{
//    [[UITabBar appearance] setBarTintColor:KNaviBlueColor];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBarBg"]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
}

/*
 @param  class 类名称
 @param  selectImageName   选中icon
 @param  unselectImageName 反选icon
 @param  title title
 */
- (void)setupBaseNavViewControllreClass:(NSString *)class
                        selectImageName:(NSString *)selectImageName
                      unSelectImageName:(NSString *)unselectImageName
                                  title:(NSString *)title{
    id obj = [[NSClassFromString(class) alloc] init];
    if([obj isKindOfClass:[UIViewController class]]){
        
        UIViewController *controller = (UIViewController *)obj;
        controller.title=title;


        controller.tabBarItem.image = [[UIImage imageNamed:unselectImageName]
                                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.selectedImage=[[UIImage imageNamed:selectImageName]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0);        
        controller.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        MYBaseNavController *nav=[[MYBaseNavController alloc]initWithRootViewController:controller];
        [self addChildViewController:nav];
    }
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //遍历子控件
    NSInteger i = 0;
    for (UIButton *tabbarButton in self.tabBar.subviews) {
        if ([tabbarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //绑定tag 标识
            tabbarButton.tag = i;
            i++;
            
            //监听tabbar的点击.
            [tabbarButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tabbarButtonClick:(UIControl *)tabbarBtn{
    //判断当前按钮是否为上一个按钮
    if (self.previousClickedTag == tabbarBtn.tag) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"KTabbarButtonClickDidRepeatNotification" object:nil];
    }
    self.previousClickedTag = tabbarBtn.tag;
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
