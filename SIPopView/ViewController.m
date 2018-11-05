//
//  ViewController.m
//  SIPopView
//
//  Created by Silence on 2018/10/29.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "SIPopView.h"
#import "CustomAlertView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataAndTableView];
}

- (void)initDataAndTableView {
    _dataList = @[@"无动画",@"缩放动画",@"从顶部掉落晃动动画",@"从底部掉落晃动动画",@"从左侧掉落晃动动画",@"从左侧掉落晃动动画"];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0f;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification{
    _tableView.frame = self.view.bounds;
    [_tableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AnimationPopViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [self showPopAnimationWithAnimationStyle:row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 50)];
    label.text = @"一个快速便捷、无侵入、可扩展的动画弹框库，两句代码即可实现想要的动画弹框。";
    label.textColor = [UIColor darkTextColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style {
    CustomAlertView *customView = [CustomAlertView xib];
    
    SIPopAnimationStyle popStyle = (SIPopAnimationStyle)style;
    SIDismissAnimationStyle dismissStyle = (SIDismissAnimationStyle)style;
    
    SIPopView *popView = [[SIPopView alloc]initWithCustomView:customView popStyle:popStyle dismissStyle:dismissStyle];
    
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    [popView pop];
}

@end
