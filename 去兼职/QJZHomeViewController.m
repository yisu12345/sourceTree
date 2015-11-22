//
//  QJZHomeViewController.m
//  去兼职
//
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZHomeViewController.h"
#import "QJZLoginViewController.h"

@interface QJZHomeViewController ()

@end

@implementation QJZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainUI];
}

-(void)setupMainUI
{
    UIImageView *mainImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    mainImgView.image=[UIImage imageNamed:@"login"];
    mainImgView.userInteractionEnabled=YES;
    [self.view addSubview:mainImgView];
    
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-40, 50, 80, 80)];
    headView.image=[UIImage imageNamed:@"icon"];
    headView.userInteractionEnabled=YES;
    [mainImgView addSubview:headView];
    
    UIButton *busBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(headView.frame)+50, kWidth-150, 40)];
    [busBtn setTitle:@"找兼职入口" forState:UIControlStateNormal];
    [busBtn setBackgroundImage:[UIImage imageNamed:@"Business-Entrance"] forState:UIControlStateNormal];
    [busBtn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    busBtn.tag=1;
    [mainImgView addSubview:busBtn];
    
    UIButton *stuBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(busBtn.frame)+20, kWidth-150, 40)];
    [stuBtn setTitle:@"招兼职入口" forState:UIControlStateNormal];
    [stuBtn setBackgroundImage:[UIImage imageNamed:@"Business-Entrance"] forState:UIControlStateNormal];
    [stuBtn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    stuBtn.tag=2;
    [mainImgView addSubview:stuBtn];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"成都优兼职网络科技有限公司版权所有";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(40);
    
}

-(void)btnClickedAction:(UIButton *)btn
{
    if (btn.tag==1) {
        NSLog(@"bus");
        [self.navigationController pushViewController:[QJZLoginViewController new] animated:YES];
//        [self presentViewController:[QJZLoginViewController new] animated:YES completion:nil];
    }
    if (btn.tag==2) {
        NSLog(@"stu");
        [self.navigationController pushViewController:[QJZLoginViewController new] animated:YES];
//        [self presentViewController:[QJZLoginViewController new] animated:YES completion:nil];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
