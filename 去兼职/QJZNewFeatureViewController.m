//
//  QJZNewFeatureViewController.m
//  去兼职
//
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZNewFeatureViewController.h"
#import "QJZHomeViewController.h"

@interface QJZNewFeatureViewController ()<UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
    UIPageControl *m_pageControl;
}
@end

@implementation QJZNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    m_scrollView=[self create_scrollView];
    m_pageControl=[self create_pageControl];
    m_scrollView.delegate=self;
    
    [self.view addSubview:m_scrollView];
    [self.view addSubview:m_pageControl];
}

-(UIPageControl *)create_pageControl
{
    UIPageControl *pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 10)];
    pageControl.numberOfPages=4;
    pageControl.currentPage=0;
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=Color(134, 194, 255);
    return pageControl;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    m_pageControl.currentPage=m_scrollView.contentOffset.x/kWidth;
}
-(UIScrollView *)create_scrollView
{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    int i=0;
    for (i=0; i<4; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight)];
        imageView.userInteractionEnabled=YES;
        if (kWidth==320) {
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"guile%d.jpg",i+1]];
        }else{
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"guile%d.jpg",i+1]];
        }
        if (i==3) {            
            UIView *shareView=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2-59, kHeight-101, 122, 42)];
            shareView.backgroundColor=Color(134, 194, 255);
            shareView.layer.masksToBounds=YES;
            shareView.layer.cornerRadius=21;
            [imageView addSubview:shareView];
            
            UIButton *share=[[UIButton alloc]initWithFrame:CGRectMake(1, 1, 120, 40)];
            share.backgroundColor=[UIColor whiteColor];
            [share setTitle:@"立即体验" forState:UIControlStateNormal];
            share.layer.masksToBounds=YES;
            share.layer.cornerRadius=20;
            [share setTitleColor:Color(134, 194, 255) forState:UIControlStateNormal];
            [share addTarget:self action:@selector(start_clicked) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:share];
        }
        UIButton *jumpBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, kHeight-40, 50, 30)];
        [jumpBtn setTitle:@"跳过>>" forState:UIControlStateNormal];
        [jumpBtn setTitleColor:Color(134, 194, 255) forState:UIControlStateNormal];
//        [jumpBtn setBackgroundImage:[UIImage imageNamed:@"boot_page_skip"] forState:UIControlStateNormal];
        jumpBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [jumpBtn addTarget:self action:@selector(start_clicked) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:jumpBtn];
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize=CGSizeMake(i*kWidth, 0);//活动范围，只支持左右
    scrollView.pagingEnabled=YES;//翻页
    scrollView.bounces=NO;//去掉弹簧
    scrollView.showsHorizontalScrollIndicator=NO;//去掉水平线
    return scrollView;
}
-(void)start_clicked
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:[QJZHomeViewController new]];
    nav.navigationBarHidden=YES;
    window.rootViewController=nav;
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.isLaunched = YES;
    [userInfo saveToSandbox];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
