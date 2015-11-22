//
//  QJZHomePageViewController.m
//  去兼职
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZHomePageViewController.h"
#import "QJZHomePageCell.h"
#import "QJZLoginViewController.h"
#import "QJZHotJobViewController.h"
#import "QJZNearJobViewController.h"
#import "QJZLikeJobViewController.h"
#import "QJZNewJobViewController.h"
#import "QJZSearchViewController.h"

#define WIDTH 180
#define SCREENWIDTH self.view.bounds.size.width
#define SCREENHEIGHT self.view.bounds.size.height

@interface QJZHomePageViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
{
    UITextField *searchField;
    UITableView *_tableView;
    NSMutableArray *homePageArray;
    NSArray *imgArray;
    NSArray *titleArray;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSArray *homeImgArray;
    NSTimer *_timer;
    int pageNumber;
    
    //侧滑
    UIView *menuView_;
    BOOL isRight_;
    UITableView *menuTable_;
}
@end

@implementation QJZHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobArray = [NSMutableArray array];
    [self setupNavUI];
    [self getHomePageData];
    //scrollView动画播放
    _timer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(playingImage) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    //侧滑
    //添加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
   
}

#pragma mark -侧滑

- (void)menuLeftMove {
    [UITableView animateWithDuration:0.3 animations:^{
        [UITableView setAnimationBeginsFromCurrentState:YES];
        CGPoint point = menuView_.frame.origin;
        point = CGPointMake(menuView_.frame.origin.x - WIDTH, menuView_.frame.origin.y);
        menuView_.frame = CGRectMake( point.x , point.y , menuView_.frame.size.width, menuView_.frame.size.height);
    }];
    isRight_ = YES;
    NSLog(@"左边移动");
}

- (void)menuRightMove {
    [UITableView animateWithDuration:0.3 animations:^{
        [UITableView setAnimationBeginsFromCurrentState:YES];
        CGPoint point = menuView_.frame.origin;
        point = CGPointMake(menuView_.frame.origin.x + WIDTH, menuView_.frame.origin.y);
        menuView_.frame = CGRectMake( point.x , point.y , menuView_.frame.size.width, menuView_.frame.size.height);
    }];
    isRight_ = NO;
    NSLog(@"右边移动");
}

//添加手势侧滑菜单
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    if ((sender.direction == UISwipeGestureRecognizerDirectionLeft) && !isRight_) {
        [self menuLeftMove];
        isRight_ = YES;
    }
    
    if ((sender.direction == UISwipeGestureRecognizerDirectionRight) && isRight_) {
        [self menuRightMove];
        isRight_ = NO;
    }
}

//添加菜单方法
- (void)addMenu {
    //添加menu底部View
    menuView_ = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x-WIDTH, 64, 180, SCREENHEIGHT-108)];
    menuView_.backgroundColor = [UIColor cyanColor];
    
    //添加底图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, SCREENHEIGHT-108)];
    imageView.image = [UIImage imageNamed:@"menu.jpg"];
    
    //添加用户头像
    UIImageView *userLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    userLogo.image = [UIImage imageNamed:@"logo2.png"];
    
    //添加用户名label
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 120, 30)];
    userLabel.text = @"泡妞狂魔";
    userLabel.backgroundColor = [UIColor clearColor];
    
    //添加用户签名信息
    UITextView *userText = [[UITextView alloc] initWithFrame:CGRectMake(40, 60, 120, 50)];
    userText.text = @"Your laugh is my motivation,i think it's the time to force myself to limit..";
    userText.font = [UIFont fontWithName:nil size:13];
    userText.backgroundColor = [UIColor clearColor];
    
    //添加menu的tableView
    menuTable_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 180, SCREENHEIGHT-208) style:UITableViewStyleGrouped];
    menuTable_.backgroundColor = [UIColor clearColor];//设置为透明色
    menuTable_.dataSource = self;
    menuTable_.delegate = self;
    [self.view addSubview:menuView_];
    [menuView_ addSubview:imageView];
    [menuView_ addSubview:userLogo];
    [menuView_ addSubview:userLabel];
    [menuView_ addSubview:userText];
    [menuView_ addSubview:menuTable_];
}


#pragma mark - 获取网络数据
- (void)getHomePageData
{
    homePageArray=[NSMutableArray array];
    imgArray=@[@"hotJob",@"nearJob",@"likeJob",@"newJob"];
    titleArray=@[@"热门兼职",@"附近兼职",@"感兴趣的兼职",@"最新兼职"];
    
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_home_data";
    
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
            NSString *str=[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"hot_job_count"]];
            [homePageArray addObject:str];
            str=[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"like_job_count"]];
            [homePageArray addObject:str];
            str=[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"nearby_job_count"]];
            [homePageArray addObject:str];
            str=[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"new_job_count"]];
            [homePageArray addObject:str];
            
            [self getHomeImgData];
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

- (void)getHomeImgData
{
    [self createPageControl];
    pageNumber=0;
    
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"select_ad_list_company";
    
    NSString *serverURL=[NSString stringWithFormat:@"%@company.php?",kServer_URL];
    
    //序列化
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    
    //发送请求
    [mgr POST:serverURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //JSON数据转字典
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        if ([dict[@"code"] isEqual:@"200"]) {
//            
//        }
        homeImgArray=dict[@"data"];
        [self showPicForHome];
        
//        else{
//            [self showMsgAnimation:@"获取数据失败" startY:kHeight-100 width:120];
//        }
        [view removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}

#pragma mark - 导航
-(void)setupNavUI
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 154)];
    navView.backgroundColor=Color(65, 144, 224);
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-30, 27, 60, 30)];
    titleLab.text=@"去兼职";
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:18];
    [navView addSubview:titleLab];
    
    UIImageView *showTitleImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 74, kWidth-80, 30)];
    showTitleImg.image=[UIImage imageNamed:@"Ad"];
    [navView addSubview:showTitleImg];
    
    UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(showTitleImg.frame)+10, kWidth-100, 30)];
    searchImg.image=[UIImage imageNamed:@"Business-Entrance"];
    searchImg.userInteractionEnabled=YES;
    [navView addSubview:searchImg];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(CGRectGetMaxX(searchImg.frame)+10, CGRectGetMaxY(showTitleImg.frame)+10, 30, 30);
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getSource) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn];
    searchImg.sd_layout.leftSpaceToView(navView,30).rightSpaceToView(btn,10).widthIs(kWidth-100);
    btn.sd_layout.leftSpaceToView(searchImg,10).rightSpaceToView(navView,30).widthIs(30);
    
//    UIView *searchBgView=[[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(showTitleImg.frame)+10, kWidth-60, 30)];
//    searchBgView.layer.cornerRadius=5;
//    searchBgView.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.3f];
//    [navView addSubview:searchBgView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth-80, 20)];
    searchField.placeholder=@"搜索更多兼职,祝你更快找到好工作";
    searchField.font=[UIFont systemFontOfSize:14];
    [searchImg addSubview:searchField];
    [self setupMainUI:CGRectGetMaxY(navView.frame)];

}
#pragma mark -- 搜索栏的数据请求
-(void)getSource
{
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    if (searchField.text.length == 0) {
        [self showMsgAnimation:@"搜索不能为空" startY:kHeight-100 width:120];
    }
    [self.jobArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=search_job_student&keyword=%@",kServer_URL,searchField.text];
    NSLog(@"%@",searchField.text);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
   [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
      NSArray *arr = [dic objectForKey:@"data"];
       if ([dic[@"code"] isEqualToString:@"200"])
       {
           QJZSearchViewController *sv = [QJZSearchViewController new];
           [self.navigationController pushViewController:sv animated:YES];
           for (NSDictionary *jsonDic in arr) {
               [self.jobArray addObject:jsonDic];
           }
           
           sv.dataArr = [NSMutableArray arrayWithArray:self.jobArray];
           
           NSLog(@"%lu",(unsigned long)self.jobArray.count);
       }
       else{
           if (searchField.text.length!=0) {
               [self showMsgAnimation:@"暂无该兼职" startY:kHeight-100 width:120];
           }
       }
       [_tableView reloadData];
       [view removeFromSuperview];
       searchField.text = nil;
       [self.view endEditing:YES];
//       if ([dic[@"code"] isEqualToString:@"200"]) {
//           for (int i = 0;i<18;i++)
//           {
//                if ([searchField.text isEqualToString:[[arr valueForKey:@"name"]objectAtIndex:i]]) {
//                    NSString *nameStr = [NSString stringWithFormat:@"%@",[[arr valueForKey:@"name"]objectAtIndex:i]];
//                    [self.nameArray addObject:nameStr];
//                    NSString *picStr = [NSString stringWithFormat:@"%@",[[arr valueForKey:@"pic"]objectAtIndex:i]];
//                    [self.picArray addObject:picStr];
//                    NSLog(@"%@",[[arr valueForKey:@"name"]objectAtIndex:i]);
//                    NSLog(@"%lu",(unsigned long)self.nameArray.count);
//                    NSLog(@"%lu",(unsigned long)self.picArray.count);
//                    
//                      }
//               self.nameArray = nil;
//               self.picArray = nil;
//          
//                  }
//           NSLog(@"%@",dic);
//       }

       NSLog(@"%@",arr);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
       [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
       [view removeFromSuperview];
   }];
}
#pragma mark - scrollViewSet
-(void)showPicForHome
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 154, kWidth, 120)];
    [self.view addSubview:_scrollView];
    int i=0;
    for (i=0; i<homeImgArray.count; i++) {
        NSDictionary *dict=homeImgArray[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, 120)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer_URL,dict[@"pic_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"banner%d",i+1]];
        [_scrollView addSubview:imageView];
    }
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;//不显示水平线
    _scrollView.contentSize=CGSizeMake(i*kWidth, 0);//活动范围，这里只支持左右，上下不支持
}

-(void)createPageControl
{
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.numberOfPages=homeImgArray.count;
    _pageControl.currentPage=0;
    _pageControl.pageIndicatorTintColor=Color(135, 135, 135);
    _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage=scrollView.contentOffset.x/kWidth;
}

-(void)playingImage
{
    if (pageNumber==homeImgArray.count) {
        pageNumber=0;
    }
    _scrollView.contentOffset=CGPointMake((_pageControl.currentPage+pageNumber)*kWidth, 0) ;
    pageNumber++;
}

#pragma mark - tableView初始化
-(void)setupMainUI:(CGFloat)startY
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, startY+120, kWidth, kHeight-startY-168)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces=NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return homePageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    QJZHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QJZHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreashDataForHomePageIconImgName:imgArray[indexPath.row] title:titleArray[indexPath.row] count:homePageArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self.navigationController pushViewController:[QJZHotJobViewController new] animated:YES];
//        [self presentViewController:[QJZHotJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==1) {
        [self.navigationController pushViewController:[QJZNearJobViewController new] animated:YES];
//        [self presentViewController:[QJZNearJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==2) {
        [self.navigationController pushViewController:[QJZLikeJobViewController new] animated:YES];
//        [self presentViewController:[QJZLikeJobViewController new] animated:YES completion:nil];
    }
    if (indexPath.row==3) {
        [self.navigationController pushViewController:[QJZNewJobViewController new] animated:YES];
//        [self presentViewController:[QJZNewJobViewController new] animated:YES completion:nil];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
