//
//  QJZNearViewController.m
//  去兼职
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZNearJobViewController.h"
#import "QJZTabBarViewController.h"
#import "QJZAnnotation.h"
#import "QJZJobDetailViewController.h"
@interface QJZNearJobViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKAnnotation>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    UITextField *_searchField;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch;
}
@property (nonatomic,assign)double curLatitude;
@property (nonatomic,assign)double curLongitude;
@property (nonatomic,strong)QJZAnnotation *annotation;
@property (nonatomic,strong)NSString *annoID;
@property (nonatomic,strong)NSMutableArray *annoArr;
@property (nonatomic,strong)BMKPointAnnotation* item;
@property (nonatomic,assign)int tag;
@end

@implementation QJZNearJobViewController
-(NSMutableArray *)jobGeoArray
{
    if (!_jobGeoArray) {
        _jobGeoArray = [NSMutableArray array];
    }
    return _jobGeoArray;
}
-(NSMutableArray *)annoArr
{
    if (!_annoArr) {
        _annoArr = [NSMutableArray array];
    }
    return _annoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BACKGROUNDCOLOR;
    self.annotation = [QJZAnnotation new];
//    [self navForBackViewTitle:@"附近兼职"];
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 70, kWidth, kHeight - 70)];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [self locationService];
    [self startLocation];
    [self setMainUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}
#pragma mark -- 定位功能
-(void)locationService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _geocodesearch =[[BMKGeoCodeSearch alloc]init];//初始化检索对象
    
}
-(void)startLocation
{
    NSLog(@"进入定位");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    //_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//普通箭头
    //    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//罗盘箭头
    _mapView.showsUserLocation = YES;//显示定位图层
    
}
-(void)stopLocation
{
    [_locService stopUserLocationService];
}
#pragma mark -- 定位的代理
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    self.curLatitude = userLocation.location.coordinate.latitude;
    self.curLongitude = userLocation.location.coordinate.longitude;
    
    NSMutableDictionary   *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"pageNumber"];
    [dic setObject:@"100" forKey:@"pagesize"];
    [dic setValue:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"lat"];//纬度   22.5528650
    [dic setValue:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"lng"];//经度   113.8866490
    [self getAllSource];
    
    [self getReverseGeocode];//地理编码
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
}
#pragma mark -- 搜索栏以及ui
-(void)setMainUI
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    navView.backgroundColor=Color(65, 144, 224);
    [self.view addSubview:navView];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 27, 30, 30)];
    [backBtn addTarget:self action:@selector(navBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(52,27, kWidth-100, 30)];
    searchImg.image=[UIImage imageNamed:@"Business-Entrance"];
    searchImg.userInteractionEnabled=YES;
    [navView addSubview:searchImg];
    _searchField = [[UITextField alloc]initWithFrame:CGRectMake(62, 29, kWidth-120, 30)];
    _searchField.placeholder = @"搜索附近5公里内的兼职";
    _searchField.font=[UIFont systemFontOfSize:14];
    [navView addSubview:_searchField];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.frame = CGRectMake(30, 30, 30, 30);
    [btn addTarget:self action:@selector(getSource) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn];
    btn.sd_layout.leftSpaceToView(_searchField,15).rightSpaceToView(navView,10).topSpaceToView(navView,33).bottomSpaceToView(navView,20);
    
}
-(void)getSource
{
    [self.jobGeoArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=select_nearby_job&cityname=成都市&job_class=%@",kServer_URL,_searchField.text];
    NSLog(@"%@",_searchField.text);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.jsonArr = [dic objectForKey:@"data"];
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]] isEqualToString:@"200"])
        {

            for (NSDictionary *jsonDic in self.jsonArr) {
                [self.jobGeoArray addObject:jsonDic];
            }
           [self getReverseGeocode];
            NSLog(@"%lu",(unsigned long)self.jobGeoArray.count);
        }
        else{
            [self showMsgAnimation:@"暂无该兼职种类" startY:kHeight-100 width:130];
        }
        
        [view removeFromSuperview];
        _searchField.text = nil;
        [self.view endEditing:YES];
        NSLog(@"%@",self.jsonArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}
#pragma mark -- 加载所有的大头针
-(void)getAllSource
{
    [self.jobGeoArray removeAllObjects];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@student.php?action=select_nearby_job&cityname=成都市",kServer_URL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //加载动画
    UIView *view=[self loadAnimation];
    [self.view addSubview:view];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.jsonArr = [dic objectForKey:@"data"];
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]] isEqualToString:@"200"])
        {
            
            for (NSDictionary *jsonDic in self.jsonArr) {
                [self.jobGeoArray addObject:jsonDic];
            }
            [self getReverseGeocode];
            NSLog(@"%lu",(unsigned long)self.jobGeoArray.count);
        }
        else{
            [self showMsgAnimation:@"暂无该兼职种类" startY:kHeight-100 width:130];
        }
        
        [view removeFromSuperview];
        _searchField.text = nil;
        [self.view endEditing:YES];
        NSLog(@"%@",self.jsonArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}
-(void)getReverseGeocode
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    for (NSDictionary *jsonDic in self.jsonArr) {
        pt = (CLLocationCoordinate2D){[jsonDic[@"lat"] floatValue], [jsonDic[@"lng"] floatValue]};
                BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
    }
    

}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        return nil;
    }
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
//        ((BMKPinAnnotationView*)annotationView).image = nil;
        for (NSDictionary *jsonDic in self.jsonArr) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer_URL,jsonDic[@"pic"]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageWithData:data];
        }
        
        
    }
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        //大头针出来的位置!!!
        for (NSDictionary *jsonDic in self.jsonArr)
        {
                self.annotation = [[QJZAnnotation alloc]init];
                self.annotation.coordinate = CLLocationCoordinate2DMake([jsonDic[@"lat"] floatValue], [jsonDic[@"lng"] floatValue]);
                self.annotation.title = [NSString stringWithFormat:@"%@,%@%@",jsonDic[@"name"],jsonDic[@"salary"],jsonDic[@"salary_jiesuan_type"]];
                self.annotation.subtitle = [NSString stringWithFormat:@"可申请时间:%@",jsonDic[@"job_time"]];
            self.annotation.jug = jsonDic[@"linkman_tel"];
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer_URL,jsonDic[@"pic"]]];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            self.annotation.image = [UIImage imageWithData:data];
//            self.annotation.jug = @[self.annotation.lat,self.annotation.lng];
            if ([_mapView.annotations containsObject:self.annotation]) {
                break;
            }

                [_mapView addAnnotation:self.annotation];
                _mapView.centerCoordinate = result.location;
        }
    }
}
#pragma mark --点击大头针title跳转界面
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (int i=0; i<array.count; i++)
        
    {
        if (view.annotation.coordinate.latitude ==((BMKPointAnnotation*)array[i]).coordinate.latitude)
            
        {
            
            //获取到当前的大头针  你可以执行一些操作
                QJZJobDetailViewController *job=[[QJZJobDetailViewController alloc]init];
                job.jobID=[self.jobGeoArray[i] objectForKey:@"id"];
                [self.navigationController pushViewController:job animated:YES];
        }
        
//        else
//            
//        {
//            
//            //对其余的大头针进行操作  我是删除
//            
//            [_mapView removeAnnotation:array[i]];
//            
//        }
        
    }

    
}

-(void)navBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
