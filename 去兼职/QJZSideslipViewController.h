//
//  SideslipViewController.h
//  去兼职
//
//  Created by Mac on 15/10/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ToolViewController.h"

@interface QJZSideslipViewController : ToolViewController
{
@private
    UIViewController * leftControl;
    UITabBarController * mainControl;
    
    CGFloat scalef;
}

//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;

//初始化
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UITabBarController *)MainView;


//恢复位置
-(void)showMainView;

//显示左视图
-(void)showLeftView;

@end
