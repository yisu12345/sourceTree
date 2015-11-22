//
//  UserInfo.m
//  暖暖
//
//  Created by  ht on 15/10/18.
//  Copyright (c) 2015年  ht. All rights reserved.
//

#import "UserInfo.h"
#define UserName @"user"
#define PassWord @"pwd"
#define LoginStatus @"isLogin"
#define ChangeNickName @"nickName"
#define Launched @"launched"


@implementation UserInfo
singleton_implementation(UserInfo)
-(void)saveToSandbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserName];
    [defaults setObject:self.pwd forKey:PassWord];
    [defaults setBool:self.isLogin forKey:LoginStatus];
    [defaults setObject:self.changeNickName forKey:ChangeNickName];
    [defaults setBool:self.isLaunched forKey:Launched];
    [defaults synchronize];
    
}
-(void)loadInfoFromSandbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserName];
    self.isLogin = [defaults boolForKey:LoginStatus];
    self.changeNickName = [defaults objectForKey:ChangeNickName];
    self.isLaunched = [defaults boolForKey:Launched];
}

-(void)saveRegisterInfoToSandbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.registerUser forKey:@"registerUser"];
    [defaults setObject:self.registerPwd forKey:@"registerPwd"];
    [defaults synchronize];
}
-(NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}
@end
