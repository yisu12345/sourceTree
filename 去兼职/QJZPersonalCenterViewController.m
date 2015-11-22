//
//  QJZPersonalCenterViewController.m
//  去兼职
//
//  Created by Mac on 15/10/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZPersonalCenterViewController.h"
#import "QJZTabBarViewController.h"
#import "QJZHomePageCell.h"
#import "QJZMyselfTableViewCell.h"

#import "zhanghuViewController.h"
#import "shoucangViewController.h"
#import "jianliViewController.h"
#import "banbenViewController.h"
#import "studentfoodViewController.h"
#import "gengduoViewController.h"


@interface QJZPersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    UIImageView *imageview;
    UILabel *lable;
    UITableView *tableview;
    UIButton *button;
    
    NSMutableArray *muTableArr;
    NSArray *mySelf;
    NSArray *imgArr;
}

@end

@implementation QJZPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainUI];
    
    [self navViewTitle:@"个人中心"];
    
    imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 74, 120, 120)];
    imageview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageview];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, kWidth, kHeight - 200)];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    
    muTableArr = [NSMutableArray array];
    mySelf = @[@"个人账户", @"我的收藏",@"完善简历",@"版本检测",@"学生餐",@"更多"];
    imgArr = @[@"hotJob",@"nearJob",@"likeJob",@"newJob",@"User",@"weibo"];
    
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mySelf.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    QJZMyselfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QJZMyselfTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    [cell refreashDataForHomePageIconImgName:imgArr[indexPath.row] title:mySelf[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        [self.navigationController pushViewController:[zhanghuViewController new] animated:YES];
        
        
    }
    if (indexPath.row==1) {
        [self.navigationController pushViewController:[shoucangViewController new] animated:YES];
        //        [self presentViewController:[QJZNearJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==2) {
        [self.navigationController pushViewController:[jianliViewController new] animated:YES];
        //        [self presentViewController:[QJZLikeJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==3) {
        [self.navigationController pushViewController:[banbenViewController new] animated:YES];
        //        [self presentViewController:[QJZNewJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==4) {
        [self.navigationController pushViewController:[studentfoodViewController new] animated:YES];
        //        [self presentViewController:[QJZNewJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==5) {
        [self.navigationController pushViewController:[gengduoViewController new] animated:YES];
        //        [self presentViewController:[QJZNewJobViewController new] animated:YES completion:nil];
    }
    
    
    
    
    
    
}


-(void)setupMainUI
{
    UIImageView *mainImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    mainImgView.image=[UIImage imageNamed:@"person_bg"];
    [self.view addSubview:mainImgView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
