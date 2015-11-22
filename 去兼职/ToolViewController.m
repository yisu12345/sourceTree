//
//  ToolViewController.m
//  去兼职
//
//  Created by Mac on 15/10/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ToolViewController.h"
#import "QJZHomePageViewController.h"
#import "QJZApplyViewController.h"
#import "QJZSortViewController.h"

@interface ToolViewController ()
{
    NSArray *titleArray;
    NSArray *imgArray;
}
@end

@implementation ToolViewController

#pragma mark - 导航栏
-(void)navForBackViewTitle:(NSString *)title
{    
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor=Color(65, 144, 224);
    [self.view addSubview:navView];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 27, 30, 30)];
    [backBtn addTarget:self action:@selector(navBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
    [navView addSubview:backBtn];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 27, 120, 30)];
    [titleLab setText:title txtFont:[UIFont systemFontOfSize:18] txtColor:[UIColor whiteColor]];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:titleLab];
}

-(void)navBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navViewTitle:(NSString *)title
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor=Color(65, 144, 224);
    [self.view addSubview:navView];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 27, 120, 30)];
    [titleLab setText:title txtFont:[UIFont systemFontOfSize:18] txtColor:[UIColor whiteColor]];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:titleLab];
}

#pragma mark -网络加载动画
-(UIView *)loadAnimation
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    view.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.2f];
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-80, 40)];
    mainView.backgroundColor=[UIColor whiteColor];
    mainView.center=view.center;
    [view addSubview:mainView];
    
    HYCircleLoadingView *loadView=[[HYCircleLoadingView alloc]initWithFrame:CGRectMake((kWidth-80)/2-50, 7.5, 25, 25)];
    loadView.lineWidth=2.0f;
    loadView.lineColor=Color(14, 104, 250);
    [loadView startAnimation];
    [mainView addSubview:loadView];
    
    ToolLabel *loadLabel=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loadView.frame)+10, 7.5, 55, 25)];
    [loadLabel setText:@"加载中..." txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    [mainView addSubview:loadLabel];
    
    return view;
}

#pragma mark -提示信息展示
-(void)showMsgAnimation:(NSString *)str startY:(CGFloat)startY width:(CGFloat)width
{
    //创建一个UILable
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, startY, width, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor grayColor];
    label.centerX=self.view.centerX;
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=15;
    label.text=str;
    [self.view addSubview:label];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    label.alpha =0.0;
    [UIView commitAnimations];
}

@end
