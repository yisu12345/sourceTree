//
//  QJZHomePageViewController.h
//  去兼职
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface QJZHomePageViewController : ToolViewController
@property (nonatomic,strong)NSMutableArray *jobArray;

//手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
