//
//  QJZSearchViewController.m
//  去兼职
//
//  Created by HT on 15/11/17.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "QJZSearchViewController.h"
#import "QJZHotJobCell.h"
#import "QJZHomePageViewController.h"
#import "QJZJobDetailViewController.h"
#import "ToolViewController.h"
@interface QJZSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)QJZHomePageViewController *HP;
@end

@implementation QJZSearchViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    }
    return _tableView;
}
//-(QJZHomePageViewController *)HP
//{
//    if (!_HP) {
//        _HP = [QJZHomePageViewController new];
//    }
//    return _HP;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self navForBackViewTitle:@"搜索结果"];
}
#pragma mark --tableView的代理与设置
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    QJZHotJobCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QJZHotJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreashDataForHotJob:self.dataArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QJZJobDetailViewController *job=[[QJZJobDetailViewController alloc]init];
    job.jobID=[self.dataArr[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:job animated:YES];
}

@end
