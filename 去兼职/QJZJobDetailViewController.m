//
//  QJZJobDetailViewController.m
//  去兼职
//
//  Created by Mac on 15/10/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZJobDetailViewController.h"
#import "QJZComplaintsViewController.h"
#import "UMSocial.h"
@interface QJZJobDetailViewController ()<UMSocialUIDelegate>
{
    UIView *mainView;
    NSDictionary *jobDetailDict;
    UIScrollView *_scorllView;
    
    UIView *shareView;
    UIView *applyView;
    UIView *onlineView;
    UITextView *onlineTextView;
}
@end

@implementation QJZJobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BACKGROUNDCOLOR;
    
    [self navForBackViewTitle:@"兼职详情"];
    [self getJobDetailData];
}

#pragma mark - 获取网络数据
- (void)getJobDetailData
{
    //请求管理员
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"action"]=@"find_job_student";
    para[@"id"]=_jobID;
    
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
            NSArray *array=dict[@"data"];
            jobDetailDict=array[0];
            [self setupFirstUI];
        }else{
            [self showMsgAnimation:@"获取数据失败" startY:kHeight-100 width:120];
        }
        [view removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsgAnimation:@"网络错误" startY:kHeight-100 width:100];
        [view removeFromSuperview];
    }];
}

-(void)setupFirstUI
{
    UIButton *complaintsBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 27, 40, 30)];
    [complaintsBtn setTitle:@"投诉" forState:UIControlStateNormal];
    complaintsBtn.tag=6;
    [complaintsBtn addTarget:self action:@selector(jobDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    complaintsBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:complaintsBtn];
    
    _scorllView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _scorllView.backgroundColor=BACKGROUNDCOLOR;
    _scorllView.bounces=NO;
    [self.view addSubview:_scorllView];
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    mainView.backgroundColor=BACKGROUNDCOLOR;
    [_scorllView addSubview:mainView];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 65)];
    view.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:view];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, 10, kWidth-20, 30)];
    [titleLab setText:jobDetailDict[@"name"] txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor blackColor]];
    [view addSubview:titleLab];
    
    UIImageView *addrImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLab.frame)+5,15 , 15)];
    addrImg.image=[UIImage imageNamed:@"Area"];
    [view addSubview:addrImg];
    
    ToolLabel *addrLab=[[ToolLabel alloc]init];
    [addrLab setText:jobDetailDict[@"details_address"] txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor blackColor]];
    CGSize addrSize=[addrLab.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat addrX=CGRectGetMaxX(addrImg.frame)+5;
    CGFloat addrY=CGRectGetMaxY(titleLab.frame)+5;
    addrLab.frame=(CGRect){{addrX,addrY},addrSize};
    [view addSubview:addrLab];
    
    UIImageView *timeImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addrLab.frame)+10, CGRectGetMaxY(titleLab.frame)+5,15 , 15)];
    timeImg.image=[UIImage imageNamed:@"Just"];
    [view addSubview:timeImg];
    
    ToolLabel *timeLab=[[ToolLabel alloc]init];
    [timeLab setText:jobDetailDict[@"sdate"] txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor blackColor]];
    CGSize timeSize=[timeLab.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat timeX=CGRectGetMaxX(timeImg.frame)+5;
    CGFloat timeY=CGRectGetMaxY(titleLab.frame)+5;
    timeLab.frame=(CGRect){{timeX,timeY},timeSize};
    [view addSubview:timeLab];
    
    UIImageView *priceImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLab.frame)+10, CGRectGetMaxY(titleLab.frame)+5,15 , 15)];
    priceImg.image=[UIImage imageNamed:@"Time"];
    [view addSubview:priceImg];
    
    ToolLabel *priceLab=[[ToolLabel alloc]init];
    [priceLab setText:[NSString stringWithFormat:@"%@%@",jobDetailDict[@"salary"] ,jobDetailDict[@"salary_jiesuan_type"]]txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor blackColor]];
    CGSize priceSize=[priceLab.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat priceX=CGRectGetMaxX(priceImg.frame)+5;
    CGFloat priceY=CGRectGetMaxY(titleLab.frame)+5;
    priceLab.frame=(CGRect){{priceX,priceY},priceSize};
    [view addSubview:priceLab];
    
    [self setupSecondUI:CGRectGetMaxY(view.frame)+5];
}

-(void)setupSecondUI:(CGFloat)startY
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, startY, kWidth, 100)];
    view.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:view];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, 5, kWidth-20, 30)];
    [titleLab setText:[NSString stringWithFormat:@"兼职类型：%@",jobDetailDict[@"job_class"]] txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor blackColor]];
    [view addSubview:titleLab];
    
    ToolLabel *linkmanLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLab.frame)+5, kWidth-20, 15)];
    [linkmanLab setText:[NSString stringWithFormat:@"发布机构:%@",jobDetailDict[@"linkman"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor blackColor]];
    [view addSubview:linkmanLab];
    
    ToolLabel *numberLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(linkmanLab.frame)+5, kWidth-20, 15)];
    [numberLab setText:[NSString stringWithFormat:@"招聘人数:%@人",jobDetailDict[@"number"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor blackColor]];
    [view addSubview:numberLab];
    
    ToolLabel *salaryLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(numberLab.frame)+5, kWidth-20, 15)];
    [salaryLab setText:[NSString stringWithFormat:@"待遇:%@%@",jobDetailDict[@"salary"],jobDetailDict[@"salary_jiesuan_type"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor blackColor]];
    [view addSubview:salaryLab];
    
    [self setupThirdUI:CGRectGetMaxY(view.frame)+5];
}

-(void)setupThirdUI:(CGFloat)startY
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, startY, kWidth, 100)];
    view.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:view];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, 10, kWidth, 30)];
    [titleLab setText:@"工作内容:" txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor blackColor]];
    [view addSubview:titleLab];
    
    ToolLabel *jobContentLab=[[ToolLabel alloc]init];
    [jobContentLab setText:jobDetailDict[@"description"] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    jobContentLab.numberOfLines=0;
    CGSize jobContentSize=[jobContentLab.text sizeWithFont:[UIFont systemFontOfSize:14] maxW:kWidth-20];
    CGFloat jobContentX=10;
    CGFloat jobContentY=CGRectGetMaxY(titleLab.frame)+5;
    jobContentLab.frame=(CGRect){{jobContentX,jobContentY},jobContentSize};
    [view addSubview:jobContentLab];
    
    ToolLabel *jobRequireLab=[[ToolLabel alloc]init];
    [jobRequireLab setText:@"任职要求:" txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    CGSize jobRequireSize=[jobRequireLab.text sizeWithFont:[UIFont systemFontOfSize:14] maxW:kWidth-20];
    jobRequireLab.numberOfLines=0;
    CGFloat jobRequireX=10;
    CGFloat jobRequireY=CGRectGetMaxY(jobContentLab.frame)+5;
    jobRequireLab.frame=(CGRect){{jobRequireX,jobRequireY},jobRequireSize};
    [view addSubview:jobRequireLab];
    
    ToolLabel *pointLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(jobRequireLab.frame), kWidth-20, 15)];
    [pointLab setText:@"(本兼职为兼职认证企业发布，经过信息核实可信)" txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor darkGrayColor]];
    pointLab.textAlignment=NSTextAlignmentRight;
    [view addSubview:pointLab];
    
    CGRect rect=view.frame;
    rect.size.height=CGRectGetMaxY(pointLab.frame)+5;
    [view setFrame:rect];
    
    [self setupFourthUI:CGRectGetMaxY(view.frame)+5];
}

-(void)setupFourthUI:(CGFloat)startY
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, startY, kWidth, 120)];
    view.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:view];

    ToolLabel *jobCompanyLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, 5, 65, 20)];
    [jobCompanyLab setText:@"兼职单位:" txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    [view addSubview:jobCompanyLab];
    
    NSString *comStr=jobDetailDict[@"com_name"];
    if ([jobDetailDict[@"com_name"] isKindOfClass:[NSNull class]]) {
        comStr=@"";
    }
    ToolLabel *jobCompanyNameLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jobCompanyLab.frame)+5, 5, kWidth-90, 20)];
    [jobCompanyNameLab setText:comStr txtFont:[UIFont systemFontOfSize:16] txtColor:Color(129, 177, 218)];
    [view addSubview:jobCompanyNameLab];
    
    ToolLabel *jobAddrLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(jobCompanyLab.frame)+10, kWidth-40, 20)];
    [jobAddrLab setText:[NSString stringWithFormat:@"详细地址:%@",jobDetailDict[@"details_address"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    [view addSubview:jobAddrLab];
    
    UIButton *addrBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-30, CGRectGetMaxY(jobCompanyLab.frame)+10, 20, 20)];
    [addrBtn setBackgroundImage:[UIImage imageNamed:@"my_address"] forState:UIControlStateNormal];
    [addrBtn addTarget:self action:@selector(jobDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    addrBtn.tag=1;
    [view addSubview:addrBtn];
    
    ToolLabel *jobContactPersonLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(jobAddrLab.frame)+10, kWidth-20, 20)];
    [jobContactPersonLab setText:[NSString stringWithFormat:@"联系人:%@",jobDetailDict[@"linkman"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    [view addSubview:jobContactPersonLab];
    
    ToolLabel *jobContactTelLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(jobContactPersonLab.frame)+10, kWidth-20, 20)];
    [jobContactTelLab setText:[NSString stringWithFormat:@"联系电话:%@",jobDetailDict[@"linkman_tel"]] txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor darkGrayColor]];
    [view addSubview:jobContactTelLab];
    
    UIButton *telBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-30, CGRectGetMaxY(jobContactPersonLab.frame)+10, 20, 20)];
    [telBtn setBackgroundImage:[UIImage imageNamed:@"my_tel"] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(jobDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    telBtn.tag=2;
    [view addSubview:telBtn];
    
    [self setupLastUI:CGRectGetMaxY(view.frame)+5];
}

-(void)setupLastUI:(CGFloat)startY
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, startY, kWidth, 100)];
    view.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:view];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, kWidth, 1)];
    lineView.backgroundColor=BACKGROUNDCOLOR;
    [view addSubview:lineView];
    
    NSArray *titleArray=@[@"收藏",@"分享",@"报名"];
    NSArray *imgArray=@[@"my_sc",@"my_fx",@"my_bm"];
    for (int i=0; i<titleArray.count; i++) {
        UIView *lastView=[[UIView alloc]initWithFrame:CGRectMake(i*kWidth/3, CGRectGetMaxY(lineView.frame)+10, kWidth/3, 80)];
        [view addSubview:lastView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/6-20, 0, 40, 40)];
        imgView.image=[UIImage imageNamed:imgArray[i]];
        [lastView addSubview:imgView];
        
        ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(kWidth/6-20, CGRectGetMaxY(imgView.frame)+5, 40, 20)];
        [titleLab setText:titleArray[i] txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor blackColor]];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [lastView addSubview:titleLab];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/6-20, 0, 40, 65)];
        btn.tag=i+3;
        [btn addTarget:self action:@selector(jobDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:btn];
    }

    CGRect rect=mainView.frame;
    rect.size.height=CGRectGetMaxY(view.frame);
    [mainView setFrame:rect];
    
    _scorllView.contentSize=CGSizeMake(kWidth, mainView.frame.size.height);
}

#pragma mark - 点击事件
-(void)jobDetailBtnAction:(UIButton *)btn
{
    if (btn.tag==1) {
        //定位
    }
    if (btn.tag==2) {
        //电话
        UIWebView *callWebView = [[UIWebView alloc] init];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",jobDetailDict[@"linkman_tel"]]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];
    }
    if (btn.tag==3) {
        //收藏
    }
    if (btn.tag==4) {
        //分享
        [self share];
    }
    if (btn.tag==5) {
        //报名
        [self apply];
    }
    if (btn.tag==6) {
        //投诉
        [self.navigationController pushViewController:[QJZComplaintsViewController new] animated:YES];
    }
}

#pragma mark - 分享
-(void)share
{
//    shareView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    shareView.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.3f];
//    [self.view addSubview:shareView];
//    
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-180, kWidth, 180)];
//    view.backgroundColor=[UIColor whiteColor];
//    [shareView addSubview:view];
//    
//    NSArray *titleArray=@[@"QQ好友",@"QQ空间",@"腾讯微博",@"微信好友",@"微信朋友圈",@"新浪微博"];
//    NSArray *imgArray=@[@"weixin",@"weixin",@"weixin",@"weixin",@"weixinfrident",@"weibo"];
//    for (int i=0; i<titleArray.count; i++) {
//        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(i%3*kWidth/3, i>2?90:0, kWidth/3, 90)];
//        [view addSubview:bgView];
//        
//        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/6-20, 10, 40, 40)];
//        imgView.image=[UIImage imageNamed:imgArray[i]];
//        imgView.userInteractionEnabled=YES;
//        [bgView addSubview:imgView];
//        
//        ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+10, kWidth/3, 20)];
//        [titleLab setText:titleArray[i] txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor blackColor]];
//        titleLab.textAlignment=NSTextAlignmentCenter;
//        [bgView addSubview:titleLab];
//        
//        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/6-40, 10, 80, 70)];
//        [btn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag=i+11;
//        [bgView addSubview:btn];
    
//    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"564bea4de0f55af8d700081a"
                                      shareText:@"想兼职就快来使用优兼职吧！"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToDouban,UMShareToRenren,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToWechatFavorite,nil]
                                       delegate:self];
    
}

-(void)shareBtnAction:(UIButton *)btn
{
//    if (btn.tag==11) {
//        //QQ好友
//    }
//    if (btn.tag==12) {
//        //QQ空间
//    }
//    if (btn.tag==13) {
//        //腾讯微博
//    }
//    if (btn.tag==14) {
//        //微信好友
//    }
//    if (btn.tag==15) {
//        //微信朋友圈
//    }
//    if (btn.tag==16) {
        //新浪微博
//        [UMSocialSnsService presentSnsIconSheetView:self
//    appKey:@"564bea4de0f55af8d700081a"
//    shareText:@"想兼职就快来使用优兼职吧！"
//    shareImage:[UIImage imageNamed:@"icon.png"]
//    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
//    delegate:self];
//    }
}

#pragma mark - 报名
-(void)apply
{
    applyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    applyView.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.3f];
    [self.view addSubview:applyView];

    UIButton *msgBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kHeight/2-50, kWidth-20, 40)];
    msgBtn.backgroundColor=Color(65, 144, 224);
    [msgBtn setTitle:@"短信报名" forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    msgBtn.tag=21;
    [applyView addSubview:msgBtn];
    
    UIButton *onlineBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kHeight/2+10, kWidth-20, 40)];
    onlineBtn.backgroundColor=Color(65, 144, 224);
    [onlineBtn setTitle:@"在线报名" forState:UIControlStateNormal];
    [onlineBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    onlineBtn.tag=22;
    [applyView addSubview:onlineBtn];
}

-(void)applyBtnAction:(UIButton *)btn
{
    if (btn.tag==21) {
        
    }
    if (btn.tag==22) {
        [self onlineApply];
    }
}

#pragma mark - 在线报名
-(void)onlineApply
{
    [applyView removeFromSuperview];
    
    onlineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    onlineView.backgroundColor=[UIColor colorWithWhite:0.3f alpha:0.3f];
    [self.view addSubview:onlineView];

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, kHeight/2-100, kWidth-20, 200)];
    view.backgroundColor=[UIColor whiteColor];
    [onlineView addSubview:view];
    
    ToolLabel *titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(0, 0, kWidth-20, 40)];
    [titleLab setText:@"发送报告申请" txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor whiteColor]];
    titleLab.backgroundColor=Color(65, 144, 224);
    titleLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:titleLab];
    
    onlineTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, 45, kWidth-30, 80)];
    onlineTextView.layer.cornerRadius=5;
    onlineTextView.backgroundColor=Color(240, 240, 240);
    [view addSubview:onlineTextView];
    
    UIImageView *pointImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(onlineTextView.frame)+10, 10, 10)];
    pointImgView.image=[UIImage imageNamed:@"boot_page_bule_point"];
    [view addSubview:pointImgView];
    
    ToolLabel *promptLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pointImgView.frame), CGRectGetMaxY(onlineTextView.frame)+5, kWidth-60, 20)];
    [promptLab setText:@"注,附件简历" txtFont:[UIFont systemFontOfSize:14] txtColor:Color(54, 144, 239)];
    [view addSubview:promptLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(promptLab.frame)+5, kWidth-30, 1)];
    lineView.backgroundColor=[UIColor blackColor];
    [view addSubview:lineView];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+5, kWidth-20, 40)];
    [btn setTitle:@"报名" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:btn];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [shareView removeFromSuperview];
    [applyView removeFromSuperview];
    [onlineView removeFromSuperview];
}

@end
