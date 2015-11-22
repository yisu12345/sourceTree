//
//  QJXRegisterViewController.m
//  去兼职
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZRegisterViewController.h"
#import "QJZServiceViewController.h"

@interface QJZRegisterViewController ()
{
    UITextField *phoneNumberField;
    UITextField *codeField;
    UITextField *pwdField;
    UITextField *surePwdField;
    
    UIImageView *selectImgView;
    
    UIButton *getCodeBtn;
    NSString *phoneCodestr;       //获取的的手机验证码字符串
}
@end

@implementation QJZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNavUI];
    
}

-(void)setupNavUI
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor=Color(65, 144, 224);
    [self.view addSubview:navView];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 27, 30, 30)];
    [backBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag=1;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
    [navView addSubview:backBtn];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-30, 27, 60, 30)];
    titleLab.text=@"注册";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:18];
    [navView addSubview:titleLab];
    
    UIButton *completeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 27, 40, 30)];
    [completeBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.tag=3;
    titleLab.textColor=[UIColor whiteColor];
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [navView addSubview:completeBtn];
    
    [self setupMainUI:CGRectGetMaxY(navView.frame)];
}

-(void)setupMainUI:(CGFloat)startY
{
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, kWidth, kHeight-startY)];
    mainView.backgroundColor=Color(233, 233, 233);
    [self.view addSubview:mainView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 20, kWidth-140, 40)];
    bgView.backgroundColor=Color(244, 243, 244);
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=5;
    [mainView addSubview:bgView];
    
    phoneNumberField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, kWidth-160, 20)];
    phoneNumberField.placeholder=@"请输入手机号码";
    [bgView addSubview:phoneNumberField];
    
    getCodeBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bgView.frame)+5, 20, 115, 40)];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"Get"] forState:UIControlStateNormal];
    [mainView addSubview:getCodeBtn];
    
    NSArray *titleArray=@[@"请输入验证码",@"密码由6-12位数字和字母组成",@"重复密码"];
    for (int i=0; i<titleArray.count; i++) {
        UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(10, 80+i*60, kWidth-40, 40)];
        backgroundView.backgroundColor=Color(244, 243, 244);
        backgroundView.layer.masksToBounds=YES;
        backgroundView.layer.cornerRadius=5;
        [mainView addSubview:backgroundView];
        
        if (i==0) {
            codeField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, kWidth-60, 20)];
            codeField.placeholder=titleArray[i];
            [backgroundView addSubview:codeField];
        }else if(i==1){
            pwdField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, kWidth-60, 20)];
            pwdField.placeholder=titleArray[i];
            [backgroundView addSubview:pwdField];
        }else{
            surePwdField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, kWidth-60, 20)];
            surePwdField.placeholder=titleArray[i];
            [backgroundView addSubview:surePwdField];
        }
    }
    
    selectImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 260, 20, 20)];
    selectImgView.userInteractionEnabled=YES;
    selectImgView.image=[UIImage imageNamed:@"select_yes"];
    [mainView addSubview:selectImgView];
    
    ToolLabel *selectLab=[[ToolLabel alloc]initWithFrame:CGRectMake(45, 260, 115, 20)];
    selectLab.font=[UIFont systemFontOfSize:16];
    [selectLab setText:@"我已阅读并同意" txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor blackColor]];
    [mainView addSubview:selectLab];
    
    UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 260, 145, 20)];
    [selectBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag=4;
    [mainView addSubview:selectBtn];
    
    UIButton *serviceBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame), 260, 65, 20)];
    [serviceBtn setTitle:@"服务条款" forState:UIControlStateNormal];
    serviceBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [serviceBtn setTitleColor:Color(98, 170, 222) forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.tag=5;
    [mainView addSubview:serviceBtn];
}

-(void)navBtnAction:(UIButton *)btn
{
    if (btn.tag==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (btn.tag==2) {
        
    }
    if (btn.tag==3) {
        
        //Z注册的完成
        NSLog(@"phoneCodestr = %@", phoneCodestr);
        [codeField.text isEqualToString:phoneCodestr];
        NSLog(@"codeField.text = %@", codeField.text);
        if (  [pwdField.text isEqualToString:surePwdField.text]) {
            NSLog(@"111");
            
            NSString *serverURL=[NSString stringWithFormat:@"%@public.php?action=userRegister&moblie=%@&password=%@",kServer_URL, phoneNumberField.text, pwdField.text];
            AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            [manager POST:serverURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //[SXLoadingView hideProgressHUD];
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                NSString *code=dic[@"code"];
                NSLog(@"%@",dic);
                NSLog(@"%@",code);
                if ([code isEqualToString:@"200"]) {
                    NSLog(@"注册成功");
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"恭喜你注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                }else{
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //[SXLoadingView hideProgressHUD];
                // [CHHLoadingView showAlertLV:@"修改失败" duration:0];
                //NSLog(@"%@",error);
                NSLog(@"注册失败");
            }];
            
        }else{
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请从新注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
            
        }
        
    }
    if (btn.tag==4) {
        if (btn.selected==YES) {
            selectImgView.image=[UIImage imageNamed:@"select_yes"];
            btn.selected=NO;
        }else{
            selectImgView.image=[UIImage imageNamed:@"select_no"];
            btn.selected=YES;
        }
    }
    if (btn.tag==5) {
        [self presentViewController:[QJZServiceViewController new] animated:YES completion:nil];
    }
}

-(void)getCodeBtnAction
{
    if ( phoneNumberField.text != nil && ![phoneNumberField.text  isEqual: @"" ]) {
        
        [self startTime];
        
        NSString *serverURL=[NSString stringWithFormat:@"%@public.php?action=getSmscode&moblie=%@",kServer_URL, phoneNumberField.text];
        
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager POST:serverURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[SXLoadingView hideProgressHUD];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSArray *arr = [dic objectForKey:@"data"];
            //NSLog(@"1 = %@", arr);
           phoneCodestr = [[arr valueForKey:@"sms_code"] objectAtIndex:0];
            //NSLog(@"2 = %@", phoneCodestr);
            
            NSString *code=dic[@"code"];
            NSLog(@"%@",dic);
            if ([code isEqualToString:@"200"]) {
                NSLog(@"获取验证码chenggong");
            }else{
                //[CHHLoadingView showAlertLV:@"修改失败" duration:0];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SXLoadingView hideProgressHUD];
            // [CHHLoadingView showAlertLV:@"修改失败" duration:0];
            NSLog(@"%@",error);
        }];
        
    }else{
        
        NSLog(@"buwei ");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入错误" message:@"请输入电话号码"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
    
}

//点击发送验证码，实现倒计时
-(void)startTime{
    __block int timeout=10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [getCodeBtn setTitle:[NSString stringWithFormat:@"发送中%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                getCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
