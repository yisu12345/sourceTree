//
//  QJZHomePageCell.m
//  去兼职
//
//  Created by Mac on 15/10/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZHomePageCell.h"

@implementation QJZHomePageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=Color(225, 225, 225);
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        view.backgroundColor=[UIColor whiteColor];
        
        _iconImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgView.frame)+10, 10, 120, 30)];
        _countLab=[[ToolLabel alloc]initWithFrame:CGRectZero];
        _contentLab=[[ToolLabel alloc]initWithFrame:CGRectZero];
        
        [view addSubview:_iconImgView];
        [view addSubview:_titleLab];
        [view addSubview:_countLab];
        [view addSubview:_contentLab];
        [self.contentView addSubview:view];
    }
    
    return self;
}

-(void)refreashDataForHomePageIconImgName:(NSString *)imgName title:(NSString *)title count:(NSString *)count
{
    _iconImgView.image=[UIImage imageNamed:imgName];
    
    _titleLab.text=title;
    [_countLab setText:count txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor redColor]];
    CGSize countSize=[count sizeWithFont:[UIFont systemFontOfSize:14]];
    CGFloat countX=kWidth-countSize.width-20;
    CGFloat countY=15;
    _countLab.frame=(CGRect){{countX,countY},countSize};
    
    [_contentLab setText:@"发布" txtFont:[UIFont systemFontOfSize:14] txtColor:[UIColor lightGrayColor]];
    _contentLab.frame=CGRectMake(CGRectGetMinX(_countLab.frame)-30, 15, 30, 20);
}

@end
