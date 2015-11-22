//
//  QJZTabBarViewController.m
//  去兼职
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZTabBarViewController.h"
#import "QJZApplyViewController.h"
#import "QJZHomePageViewController.h"
#import "QJZSortViewController.h"
#import "QJZPersonalCenterViewController.h"

@interface QJZTabBarViewController ()
@property (nonatomic,strong)UITabBarController *tabBarController;
@end

@implementation QJZTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QJZApplyViewController *apply=[[QJZApplyViewController alloc]init];
    [self addController:apply title:@"申请" imageName:@"Application.png" imageHighName:@"Application2"];
    
    QJZHomePageViewController *home=[[QJZHomePageViewController alloc]init];
    [self addController:home title:@"主页" imageName:@"Home" imageHighName:@"Home2"];
    
    QJZSortViewController *sort=[[QJZSortViewController alloc]init];
    [self addController:sort title:@"分类" imageName:@"Classification" imageHighName:@"Classification2"];
    
    QJZPersonalCenterViewController *myself = [[QJZPersonalCenterViewController alloc] init];
    [self addController:myself title:@"个人中心" imageName:@"UMS_account_normal_white "imageHighName:@"UMS_account_tap_white"];
    //选择启动子控制器
    [self setSelectedIndex:1];
}

-(void)addController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)name imageHighName:(NSString *)highName
{
    vc.view.backgroundColor=[UIColor whiteColor];
    vc.tabBarItem.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:name];
    //显示图片本来的颜色，不用渲染成其他颜色（比如蓝色）
    vc.tabBarItem.selectedImage=[[UIImage imageNamed:highName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置字体颜色
    NSMutableDictionary *textAttr=[NSMutableDictionary new];
    textAttr[NSForegroundColorAttributeName]=Color(128, 128, 128);
    NSMutableDictionary *textAttr_select=[NSMutableDictionary new];
    textAttr_select[NSForegroundColorAttributeName]=Color(120, 193, 243);
    [vc.tabBarItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:textAttr_select forState:UIControlStateSelected];
    
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
//    nav.navigationBarHidden=YES;
    [self addChildViewController:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
