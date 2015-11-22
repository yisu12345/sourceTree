//
//  ToolViewController.h
//  去兼职
//
//  Created by Mac on 15/10/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolViewController : UIViewController
@property(strong,nonatomic)UIView *tabBarView;

/**  自定义导航栏  */
-(void)navForBackViewTitle:(NSString *)title;
-(void)navViewTitle:(NSString *)title;
/**  加载动画  */
-(UIView *)loadAnimation;

/**  提示信息展示  */
-(void)showMsgAnimation:(NSString *)str startY:(CGFloat)startY width:(CGFloat)width;
@end
