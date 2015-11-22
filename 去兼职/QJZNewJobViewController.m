//
//  QJZNewViewController.m
//  去兼职
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZNewJobViewController.h"
#import "QJZHotJobCell.h"
#import "QJZJobDetailViewController.h"

@interface QJZNewJobViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *hotArray;
    int page;
}
@end

@implementation QJZNewJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BACKGROUNDCOLOR;
    [self navForBackViewTitle:@"最新兼职"];
    
    [self setupMainUI];
    
    [self getHomePageData];
}

#pragma mark - 获取网络数据
- (void)getHomePageData
{
    page=1;
    hotArray=[[NSMutableArray alloc]init];
    
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_job_student_3day";
    para[@"page"]=[NSString stringWithFormat:@"%d",page];
    
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
            [hotArray addObjectsFromArray:dict[@"data"]];
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

- (void)loadMoreJobData
{
    page++;
    
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_job_student_3day";
    para[@"page"]=[NSString stringWithFormat:@"%d",page];
    
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
            [hotArray addObjectsFromArray:dict[@"data"]];
        }else{
            [self showMsgAnimation:@"没有更多数据了" startY:kHeight-100 width:140];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
        [_tableView footerEndRefreshing];
    }];
}

- (void)loadNewJobData
{
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_job_student_3day";
    para[@"page"]=@"1";
    
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
            NSMutableArray *dataArray=[[NSMutableArray alloc]init];
            NSArray *array=dict[@"data"];
            for (int i=0; i<array.count; i++) {
                for(NSDictionary *dicData in hotArray){
                    if (![dicData[@"id"] isEqual:[array[i] objectForKey:@"id"]]) {
                        [dataArray addObject:array[i]];
                    }
                }
            }
            //将最新的数据，添加到数组最前面
            NSRange range=NSMakeRange(0,dataArray.count);
            NSIndexSet *indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
            [hotArray insertObjects:dataArray atIndexes:indexSet];
            
            [self showMsgAnimation:[NSString stringWithFormat:@"获取%d条最新数据",dataArray.count] startY:kHeight-100 width:160];
            
        }else{
            [self showMsgAnimation:@"没有更多数据了" startY:kHeight-100 width:140];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    }];
}

-(void)setupMainUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.bounces=NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [_tableView addHeaderWithTarget:self action:@selector(tableViewHeadAction)];
    [_tableView addFooterWithTarget:self action:@selector(tableViewFootAction)];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 上拉与下拉刷新
-(void)tableViewFootAction
{
    [self loadMoreJobData];
}

-(void)tableViewHeadAction
{
//    [self loadNewJobData];
    [_tableView headerEndRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
