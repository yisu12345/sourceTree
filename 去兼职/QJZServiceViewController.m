//
//  QJZServiceViewController.m
//  去兼职
//
//  Created by Mac on 15/10/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZServiceViewController.h"

@interface QJZServiceViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIView *_loadView;
}
@end

@implementation QJZServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navForBackViewTitle:@"服务条款"];
    //1.创建一个UIWebView
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, iOS7?64:44, kWidth, kHeight-(iOS7?64:44))];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    
    // 2.用webView加载登录页面
    NSURL *url=[NSURL URLWithString:kService_url];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loadView=[self loadAnimation];
    [self.view addSubview:_loadView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadView removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_loadView removeFromSuperview];
}

//加载动画
-(UIView *)loadAnimation
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    view.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.2f];
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-80, 40)];
    mainView.backgroundColor=[UIColor whiteColor];
    mainView.center=view.center;
    [view addSubview:mainView];
    
    HYCircleLoadingView *loadView=[[HYCircleLoadingView alloc]initWithFrame:CGRectMake((kWidth-80)/2-70, 5, 30, 30)];
    loadView.lineWidth=3.0f;
    loadView.lineColor=[UIColor lightGrayColor];
    [loadView startAnimation];
    [mainView addSubview:loadView];
    
    ToolLabel *loadLabel=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loadView.frame)+10, 5, 100, 30)];
    [loadLabel setText:@"网页加载中..." txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor darkGrayColor]];
    [mainView addSubview:loadLabel];
    
    return view;
}
@end
