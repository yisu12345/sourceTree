//
//  UserInfo.h
//  暖暖
//
//  Created by  ht on 15/10/18.
//  Copyright (c) 2015年  ht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
static NSString *domain = @"ht.local";
@interface UserInfo : NSObject

singleton_interface(UserInfo)
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *pwd;
//注册相关
@property (nonatomic,copy)NSString *registerUser;
@property (nonatomic,copy)NSString *registerPwd;

@property (nonatomic,copy)NSString *jid;
//修改昵称
@property (nonatomic,copy)NSString *changeNickName;
//用户的登陆状态
@property (nonatomic,assign)BOOL isLogin;
//是否进入过欢迎界面
@property (nonatomic,assign)BOOL isLaunched;
-(void)saveToSandbox;
-(void)loadInfoFromSandbox;
-(void)saveRegisterInfoToSandbox;
@end
