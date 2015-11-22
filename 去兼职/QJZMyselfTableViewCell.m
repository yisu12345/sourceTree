//
//  QJZMyselfTableViewCell.m
//  去兼职
//
//  Created by yisu on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "QJZMyselfTableViewCell.h"

@implementation QJZMyselfTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kWidth - 40, 50)];
        view.backgroundColor=[UIColor clearColor];
        
        _iconImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgView.frame)+10, 10, 120, 30)];
        
        _titleLab.textColor = [UIColor whiteColor];
        [view addSubview:_iconImgView];
        [view addSubview:_titleLab];
        [self.contentView addSubview:view];
    }
    
    return self;
}



-(void)refreashDataForHomePageIconImgName:(NSString *)imgName title:(NSString *)title{
    _iconImgView.image=[UIImage imageNamed:imgName];
    
    _titleLab.text=title;
   
  }

@end
