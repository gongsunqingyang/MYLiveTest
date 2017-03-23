//
//  MYHomeTableCell.h
//  MYLiveTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYHomeTableCellLayout.h"

typedef void(^LiveBlock)(MYLive *);

@interface MYHomeTableCell : UITableViewCell
@property (strong, nonatomic) UIImageView *liveIV;//实时截图
@property (strong, nonatomic) MYHomeTableCellLayout *layout;
@property (copy, nonatomic) LiveBlock liveBlock;



@end
