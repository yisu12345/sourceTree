//
//  QJZSortViewController.m
//  去兼职
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZSortViewController.h"
#import "QJZSortCell.h"
#import "QJZSearchViewController.h"
@interface QJZSortViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *sortArray;
    
    UIButton *selectAreaBtn;
    UIButton *selectSortBtn;
}
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSDictionary *dic;
@end

@implementation QJZSortViewController
-(NSDictionary *)dic
{
    if (!_dic) {
        _dic = [NSDictionary dictionary];
    }
    return _dic;
}
-(NSArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)jobArray
{
    if (!_jobArray) {
        _jobArray = [NSMutableArray array];
    }
    return _jobArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navViewTitle:@"兼职分类"];
    
    [self setupMainUI];
}

-(void)setupMainUI
{
    //nav地址选择
    UIImageView *addrImg=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-30, 32, 20, 20)];
    addrImg.image=[UIImage imageNamed:@"down"];
    addrImg.userInteractionEnabled=YES;
    [self.view addSubview:addrImg];
    
    ToolLabel *addrLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(addrImg.frame)-45, 27, 40, 30)];
    [addrLab setText:@"成都" txtFont:[UIFont systemFontOfSize:18] txtColor:[UIColor whiteColor]];
    addrLab.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:addrLab];
    
    UIButton *addrBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-75, 27, 65, 30)];
    [addrBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    addrBtn.tag=1;
    [self.view addSubview:addrBtn];
    
    //选择类型和选择地区
    NSArray *titleArray=@[@"选择类型",@"选择地区"];
    for (int i=0; i<titleArray.count; i++) {
        if (i==0) {
            selectSortBtn=[[UIButton alloc]initWithFrame:CGRectMake(i*kWidth/2, 65, kWidth/2, 40)];
            [selectSortBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [selectSortBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            selectSortBtn.tag=i+2;
            selectSortBtn.backgroundColor=Color(60, 130, 203);
//            [selectSortBtn setBackgroundImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateNormal];
//            [selectSortBtn setBackgroundImage:[UIImage imageNamed:@"select_s"] forState:UIControlStateSelected];
            [self.view addSubview:selectSortBtn];
        }else{
            selectAreaBtn=[[UIButton alloc]initWithFrame:CGRectMake(i*kWidth/2, 65, kWidth/2, 40)];
            [selectAreaBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [selectAreaBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            selectAreaBtn.tag=i+2;
            selectAreaBtn.backgroundColor=Color(65, 144, 224);
//            [selectAreaBtn setBackgroundImage:[UIImage imageNamed:@"select_s"] forState:UIControlStateNormal];
//            [selectAreaBtn setBackgroundImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateSelected];
            [self.view addSubview:selectAreaBtn];
        }
    }
    
    //tableView初始化
    NSArray *array=@[@"全部",@"派单",@"安保",@"礼仪",@"促销",@"翻译",@"客服",@"演出",@"模特",@"文员",@"设计",@"家教",@"临时工",@"服务员",@"调研",@"送餐",@"销售",@"其它"];
    sortArray=array;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 105, kWidth, kHeight-154)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces=NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

-(void)sortBtnAction:(UIButton *)btn
{
    if (btn.tag==1) {
        
    }
    if (btn.tag==2) {
        if (btn.selected==YES) {
            selectSortBtn.backgroundColor=Color(65, 144, 224);
            selectAreaBtn.backgroundColor=Color(60, 130, 203);
            
            
            
        }else{
            selectSortBtn.backgroundColor=Color(60, 130, 203);
            selectAreaBtn.backgroundColor=Color(65, 144, 224);
            
        }
        NSArray *array=@[@"全部",@"派单",@"安保",@"礼仪",@"促销",@"翻译",@"客服",@"演出",@"模特",@"文员",@"设计",@"家教",@"临时工",@"服务员",@"调研",@"送餐",@"销售",@"其它"];
        sortArray=array;
        [_tableView reloadData];
    }
    if (btn.tag==3) {
        if (btn.selected==YES) {
            selectSortBtn.backgroundColor=Color(60, 130, 203);
            selectAreaBtn.backgroundColor=Color(65, 144, 224);
            
        }else{
            selectSortBtn.backgroundColor=Color(65, 144, 224);
            selectAreaBtn.backgroundColor=Color(60, 130, 203);
            
        }
        NSArray *array=@[@"锦江区",@"武侯区",@"成华区",@"金牛区",@"青羊区",@"高新区",@"新都区",@"温江区",@"青白江区",@"龙泉驿区",@"郫县",@"双流县",@"大邑县",@"蒲江县",@"新津县",@"金堂县",@"崇州市",@"都江堰市",@"邛崃市",@"彭州市"];
        sortArray=array;
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    QJZSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QJZSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreashDataForSort:sortArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([sortArray[0] isEqualToString:@"全部"] ) {
            switch (indexPath.row) {
                case 0:
                [self getAllSourceWithjobClass:@"全部"];
                    break;
                case 1:
                    [self getSourceWithKeyword:@"派单"];
                    break;
                case 2:
                    [self getSourceWithKeyword:@"安保"];
                    break;
                case 3:
                    [self getSourceWithKeyword:@"礼仪"];
                    break;
                case 4:
                    [self getSourceWithKeyword:@"促销"];
                    break;
                case 5:
                    [self getSourceWithKeyword:@"翻译"];
                    break;
                case 6:
                    [self getSourceWithKeyword:@"客服"];
                    break;
                case 7:
                    [self getSourceWithKeyword:@"演出"];
                    break;
                case 8:
                    [self getSourceWithKeyword:@"模特"];
                    break;
                case 9:
                    [self getSourceWithKeyword:@"文员"];
                    break;
                case 10:
                    [self getSourceWithKeyword:@"设计"];
                    break;
                case 11:
                    [self getSourceWithKeyword:@"家教"];
                    break;
                case 12:
                    [self getSourceWithKeyword:@"临时工"];
                    break;
                case 13:
                    [self getSourceWithKeyword:@"服务员"];
                    break;
                case 14:
                    [self getSourceWithKeyword:@"调研"];
                    break;
                case 15:
                    [self getSourceWithKeyword:@"送餐"];
                    break;
                case 16:
                    [self getSourceWithKeyword:@"销售"];
                    break;
                default:
                    [self getSourceWithKeyword:@"其他"];
                    break;
        }
        
        }
    if ([sortArray[0] isEqualToString:@"锦江区"]) {
        switch (indexPath.row) {
            case 0:
                //锦江区
                [self getSourceWithArea:@"1395"];
                break;
            case 1:
                //武侯区
                [self getSourceWithArea:@"1407"];
                break;
            case 2:
                //成华区
                [self getSourceWithArea:@"1406"];
                break;
            case 3:
                //金牛区
                [self getSourceWithArea:@"1405"];
                break;
            case 4:
                //青羊区
                [self getSourceWithArea:@"1404"];
                break;
            case 5:
                //高新区
                [self getSourceWithArea:@"1420"];
                break;
            case 6:
                //新都区
                [self getSourceWithArea:@"1401"];
                break;
            case 7:
                //温江区
                [self getSourceWithArea:@"1403"];
                break;
            case 8:
                //青白江区
                [self getSourceWithArea:@"1402"];
                break;
            case 9:
                //龙泉驿区
                [self getSourceWithArea:@"1400"];
                break;
            case 10:
                //郫县
                [self getSourceWithArea:@"1396"];
                break;
            case 11:
                //双流县
                [self getSourceWithArea:@"1399"];
                break;
            case 12:
                //大邑县
                [self getSourceWithArea:@"1397"];
                break;
            case 13:
                //蒲江县
                [self getSourceWithArea:@"1418"];
                break;
            case 14:
                //新津县
                [self getSourceWithArea:@"1413"];
                break;
            case 15:
                //金堂县
                [self getSourceWithArea:@"1398"];
                break;
            case 16:
                //崇州市
                [self getSourceWithArea:@"1416"];
                break;
            case 17:
                //都江堰市
                [self getSourceWithArea:@"1417"];
                break;
            case 18:
                //邛崃市
                [self getSourceWithArea:@"1415"];
                break;
            default:
                //彭州市
                [self getSourceWithArea:@"1414"];
                break;
        }
    }
    
}

-(void)getSourceWithKeyword:(NSString *)keyword
{
    [self.jobArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=search_job_student&keyword=%@",kServer_URL,keyword];
    NSLog(@"%@",keyword);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.dataArr = [dic objectForKey:@"data"];
        if ([dic[@"code"] isEqualToString:@"200"])
        {
            QJZSearchViewController *sv = [QJZSearchViewController new];
            [self.navigationController pushViewController:sv animated:YES];
            for (NSDictionary *jsonDic in self.dataArr) {
                [self.jobArray addObject:jsonDic];
            }
            
            sv.dataArr = [NSMutableArray arrayWithArray:self.jobArray];
            
            NSLog(@"%lu",(unsigned long)self.jobArray.count);
        }
        else{
            [self showMsgAnimation:@"暂无该兼职" startY:kHeight-100 width:120];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
        NSLog(@"%@",self.dataArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}
-(void)getAllSourceWithjobClass:(NSString*)jobClass
{
    [self.jobArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=select_job_list_jobclass&job_class=%@&cityid=1394&pagesize=1000",kServer_URL,jobClass];
    NSLog(@"%@",jobClass);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.dataArr = [dic objectForKey:@"data"];
        if ([dic[@"code"] isEqualToString:@"200"])
        {
            QJZSearchViewController *sv = [QJZSearchViewController new];
            [self.navigationController pushViewController:sv animated:YES];
            for (NSDictionary *jsonDic in self.dataArr) {
                [self.jobArray addObject:jsonDic];
            }
            
            sv.dataArr = [NSMutableArray arrayWithArray:self.jobArray];
            
            NSLog(@"%lu",(unsigned long)self.jobArray.count);
        }
        else{
            [self showMsgAnimation:@"暂无该兼职" startY:kHeight-100 width:120];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
        NSLog(@"%@",self.dataArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}
-(void)getSourceWithArea:(NSString*)area
{
    [self.jobArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=select_job_list_city&three_cityid=%@",kServer_URL,area];
    NSLog(@"%@",area);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.dataArr = [dic objectForKey:@"data"];
        if ([dic[@"code"] isEqualToString:@"200"])
        {
            QJZSearchViewController *sv = [QJZSearchViewController new];
            [self.navigationController pushViewController:sv animated:YES];
            for (NSDictionary *jsonDic in self.dataArr) {
                [self.jobArray addObject:jsonDic];
            }
            
            sv.dataArr = [NSMutableArray arrayWithArray:self.jobArray];
            
            NSLog(@"%lu",(unsigned long)self.jobArray.count);
        }
        else{
            [self showMsgAnimation:@"该区域暂无兼职" startY:kHeight-100 width:130];
        }
        [_tableView reloadData];
        [view removeFromSuperview];
        NSLog(@"%@",self.dataArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}
@end
