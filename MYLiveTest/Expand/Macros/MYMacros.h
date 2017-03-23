//
//  MYMacros.h
//
//
//  Created by yanglin on 2017/1/19.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#ifndef MYMacros_h
#define MYMacros_h

// 3.自定义Log & 调试状态宏
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define KDebug YES
#else
#define NSLog(...)
#define KDebug NO
#endif

// 系统控件默认高度
#define kStatusBarHeight        (20.f)
#define kNavBarHeight           (64.f)
#define kTabBarHeight           (49.f)
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

// 视图尺寸
#define kMainWidth          ([[UIScreen mainScreen] bounds].size.width)
#define kMainHeight         ([[UIScreen mainScreen] bounds].size.height)
#define MinX(v)             CGRectGetMinX((v).frame)
#define MinY(v)             CGRectGetMinY((v).frame)
#define MaxX(v)             CGRectGetMaxX((v).frame)
#define MaxY(v)             CGRectGetMaxY((v).frame)

// 设置颜色
#define kColor_a(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kColor(r,g,b)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define kColorRandom        [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1.0]

// 设置字体大小
#define kFont(size)         [UIFont systemFontOfSize:size]
#define kFontBold(size)     [UIFont boldSystemFontOfSize:size]

// 设备类型
#define kModel              [[UIDevice currentDevice] model]
#define kDevice_name        [[UIDevice currentDevice] name]
#define kiPhoneSimulator    [kDevice_name isEqualToString:@"iPhone Simulator"]
#define kiPhone             [kModel isEqualToString:@"iPhone"]
#define kiPad               [kModel isEqualToString:@"iPad"]

// 设备高度
#define kIphone4sAndEarlier (kMainHeight <568?YES:NO)
#define kIphone5SAndAfter   (kMainHeight>=568?YES:NO)

// 系统版本
#define KSystemVersion      [[UIDevice currentDevice] systemVersion].floatValue
#define kAppName            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define kBundleID           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define kUDID               [[[UIDevice currentDevice] identifierForVendor] UUIDString]

// 用户本地文件
#define kStandardUserDefaults   [NSUserDefaults standardUserDefaults]
#define kOutStandDate(key)      [[NSUserDefaults standardUserDefaults]objectForKey:key]
#define kSaveStandDate(obj,key) [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key];\
                                [[NSUserDefaults standardUserDefaults] synchronize]

// 通知
#define kPostNotification(name,obj,userinfo)    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:userinfo]
#define kPostFastNotification(NAME,obj)         [[NSNotificationCenter defaultCenter] postNotificationName:NAME object:obj]
#define kAddNotification(Observer,SEL,Name,obj) [[NSNotificationCenter defaultCenter]addObserver:Observer selector:SEL name:Name object:obj]
#define kRemoveAllNotification                  [[NSNotificationCenter defaultCenter]removeObserver:self]
#define kRemoveNotification(Observer,NAME,obj)  [[NSNotificationCenter defaultCenter]removeObserver:Observer name:NAME object:obj];

// 图片
#define kImg(name)              [UIImage imageNamed:name]
#define kPngImg(NAME)           [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define kJpgImg(NAME)           [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]

#endif
