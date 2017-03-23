//
//  ViewController.m
//  MYIjkPlayerTest
//
//  Created by yanglin on 2017/2/6.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "MYHomeController.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "MYNetworkTool.h"
#import "MYHomeTableCellLayout.h"
#import "MYHomeTableCell.h"
#import "MYLiveController.h"

@interface MYHomeController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *layouts;

@end

@implementation MYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"clean" style:UIBarButtonItemStylePlain target:self action:@selector(clean)];
    self.navigationItem.rightBarButtonItem = rightItem;

    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [_tableView registerClass:[MYHomeTableCell class] forCellReuseIdentifier:@"MYHomeTableCell"];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
    
    __weak __typeof(self) ws = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
}

//加载数据
- (void)loadData{
    [MYNetworkTool getLivesSuccess:^(NSArray *lives) {
        [_tableView.mj_header endRefreshing];
        NSMutableArray *layouts = [NSMutableArray array];
        for (MYLive *live in lives) {
            MYHomeTableCellLayout *layout = [[MYHomeTableCellLayout alloc] init];
            layout.live = live;
            [layouts addObject:layout];
        }
        _layouts = layouts;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)clean{
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
    [_tableView.mj_header beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYHomeTableCell"];
    cell.layout = _layouts[indexPath.row];
    __weak __typeof(cell) weakCell = cell;
    cell.liveBlock = ^(MYLive *live){
        MYLiveController *liveVC = [[MYLiveController alloc] initWithLive:weakCell.layout.live avatar:weakCell.liveIV.image];
        liveVC.live = live;
        liveVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liveVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYHomeTableCellLayout *layout = _layouts[indexPath.row];
    return layout.h;
}

#pragma mark - UITableViewDelegate

@end
