//
//  QJZHotViewController.m
//  去兼职
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZHotJobViewController.h"
#import "QJZHotJobCell.h"
#import "QJZJobDetailViewController.h"

@interface QJZHotJobViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *hotArray;
}
@end

@implementation QJZHotJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self navForBackViewTitle:@"热门兼职"];
    
    [self setupMainUI];
    
    [self getHomePageData];
}

#pragma mark - 获取网络数据
- (void)getHomePageData
{
    hotArray=[NSMutableArray array];
    
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_hot_job_student";
    
    NSString *serverURL=[NSString stringWithFormat:@"%@student.php?",kServer_URL];
    
    //序列化
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    
    //发送请求
    [mgr POST:serverURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //JSON数据转字典
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqual:@"200"]) {
            hotArray=dict[@"data"];
        }else{
            [self showMsgAnimation:@"获取数据失败" startY:kHeight-100 width:120];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}

-(void)setupMainUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces=NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hotArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    QJZHotJobCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QJZHotJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreashDataForHotJob:hotArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QJZJobDetailViewController *job=[[QJZJobDetailViewController alloc]init];
    job.jobID=[hotArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:job animated:YES];
//    [self presentViewController:job animated:YES completion:nil];
}

@end
