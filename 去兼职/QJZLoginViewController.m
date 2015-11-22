//
//  QJZLoginViewController.m
//  去兼职
//
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZLoginViewController.h"
#import "QJZRegisterViewController.h"
#import "QJZTabBarViewController.h"
#import "QJZForgetPasswordViewController.h"
#import "QJZSideslipViewController.h"
#import "QJZPersonalCenterViewController.h"
#import "QJZHomePageViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
@interface QJZLoginViewController ()<UITextFieldDelegate>
{
    UITextField *accountField;
    UITextField *pwdField;
    UIView *mainView;
    
    UIImageView *selectBtnView;
    UIImageView *lineView;
    UIImageView *linePwdView;
}
@end

@implementation QJZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainUI];
}

-(void)setupMainUI
{
    //firstUI
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-40, 30, 80, 80)];
    headView.image=[UIImage imageNamed:@"icon"];
    [mainView addSubview:headView];
    
    UIImageView *accountImg=[[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(headView.frame)+20, 30, 30)];
    accountImg.image=[UIImage imageNamed:@"User"];
    [mainView addSubview:accountImg];
    
    accountField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(accountImg.frame)+10, CGRectGetMaxY(headView.frame)+20, kWidth-220, 30)];
    accountField.placeholder=@"Username";
    accountField.delegate=self;
    accountField.tag=1;
    [mainView addSubview:accountField];
    
    lineView=[[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(accountImg.frame)+5, kWidth-80, 5)];
    lineView.image=[UIImage imageNamed:@"line_g"];
    [mainView addSubview:lineView];
    
    UIImageView *pwdImg=[[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(lineView.frame)+20, 30, 30)];
    pwdImg.image=[UIImage imageNamed:@"Password"];
    [mainView addSubview:pwdImg];
    
    pwdField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pwdImg.frame)+10, CGRectGetMaxY(lineView.frame)+20, kWidth-220, 30)];
    pwdField.placeholder=@"Password";
    pwdField.delegate=self;
    pwdField.tag=2;
    [mainView addSubview:pwdField];
    
    linePwdView=[[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(pwdImg.frame)+5, kWidth-80, 5)];
    linePwdView.image=[UIImage imageNamed:@"line_g"];
    [mainView addSubview:linePwdView];
    
    //secondUI
    selectBtnView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-230, CGRectGetMaxY(linePwdView.frame)+10, 20, 20)];
    selectBtnView.image=[UIImage imageNamed:@"select_yes"];
    selectBtnView.userInteractionEnabled=YES;
    [mainView addSubview:selectBtnView];
    
    ToolLabel *pwdLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectBtnView.frame)+5, CGRectGetMaxY(linePwdView.frame)+10, 65, 20)];
    [pwdLab setText:@"记住密码" txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor grayColor]];
    [mainView addSubview:pwdLab];
    
    UIButton *rememberBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-230, CGRectGetMaxY(linePwdView.frame)+10, 90, 20)];
    rememberBtn.tag=6;
    [rememberBtn addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:rememberBtn];
    
    UIButton *forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rememberBtn.frame)+20, CGRectGetMaxY(linePwdView.frame)+10, 80, 20)];
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forgetBtn.tag=7;
    [forgetBtn addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:forgetBtn];
    
    UIButton *loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(selectBtnView.frame)+20, kWidth-80, 40)];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"landed"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:loginBtn];
    
    //lastUI
    UIImageView *lastImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-120, kWidth, 120)];
    lastImgView.image=[UIImage imageNamed:@"Landed-bj"];
    lastImgView.userInteractionEnabled=YES;
    [mainView addSubview:lastImgView];
    
    NSArray *imgArray=@[@"qq",@"Micro-channel",@"Sina"];
    for (int i=0; i<imgArray.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-75+i*60, 30, 30, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        [lastImgView addSubview:btn];
    }
    
    NSArray *titleArray=@[@"马上注册",@"我去看看"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-90+i*91, 75, 90, 30)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+4;
        [lastImgView addSubview:btn];
    }
}

-(void)loginBtnAction

{
    if ((accountField.text != nil && ![accountField.text  isEqual: @""]) && (pwdField.text != nil && ![pwdField.text  isEqual: @""])) {
        NSLog(@"111");
        
        NSString *serverURL=[NSString stringWithFormat:@"%@public.php?action=userLogin&username=%@&password=%@&usertype＝1",kServer_URL, accountField.text, pwdField.text];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager POST:serverURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[SXLoadingView hideProgressHUD];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSString *code=dic[@"code"];
            NSLog(@"%@",dic);
            if ([code isEqualToString:@"200"]) {
                NSLog(@"登陆成功");
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登陆成功" message:@"恭喜你登陆成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                
                
            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"请重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SXLoadingView hideProgressHUD];
            // [CHHLoadingView showAlertLV:@"修改失败" duration:0];
            //NSLog(@"%@",error);
            NSLog(@"登陆失败");
        }];
        
    }else{
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"请重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
    }
    
    
    
}

-(void)otherBtnAction:(UIButton *)btn
{
    if (btn.tag==1) {
        
    }
    if (btn.tag==2) {
        
    }
    if (btn.tag==3) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
            }});
        //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
        }];
        [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsFriends is %@",response.data);
        }];
        [self.navigationController pushViewController:[QJZTabBarViewController new] animated:YES];
        
    }
    if (btn.tag==4) {
        [self presentViewController:[QJZRegisterViewController new] animated:YES completion:nil];
    }
    if (btn.tag==5) {
        //        [self presentViewController:[QJZTabBarViewController new] animated:YES completion:nil];
        [self.navigationController pushViewController:[QJZTabBarViewController new] animated:YES];
        
        //        QJZPersonalCenterViewController * personal = [[QJZPersonalCenterViewController alloc]init];
        //        QJZTabBarViewController * tabBar = [[QJZTabBarViewController alloc]init];
        //
        //        QJZSideslipViewController * sideslip = [[QJZSideslipViewController alloc]initWithLeftView:personal andMainView:tabBar];
        //
        //        //滑动速度系数
        //        [sideslip setSpeedf:0.5];
        //
        //        //点击视图是是否恢复位置
        //        sideslip.sideslipTapGes.enabled = YES;
        //        [self.navigationController pushViewController:sideslip animated:YES];
        //        [self presentViewController:sideslip animated:YES completion:nil];
    }
    if (btn.tag==6) {
        if (btn.selected==YES) {
            selectBtnView.image=[UIImage imageNamed:@"select_yes"];
            btn.selected=NO;
        }else{
            selectBtnView.image=[UIImage imageNamed:@"select_no"];
            btn.selected=YES;
        }
    }
    if (btn.tag==7) {
        [self presentViewController:[QJZForgetPasswordViewController new] animated:YES completion:nil];
    }
    
}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        lineView.image=[UIImage imageNamed:@"line_b"];
    }else{
        linePwdView.image=[UIImage imageNamed:@"line_b"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        lineView.image=[UIImage imageNamed:@"line_g"];
    }else{
        linePwdView.image=[UIImage imageNamed:@"line_g"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [accountField resignFirstResponder];
    [pwdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
