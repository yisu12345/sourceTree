//
//  QJZSortCell.m
//  去兼职
//
//  Created by Mac on 15/10/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZSortCell.h"

@implementation QJZSortCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=Color(225, 225, 225);
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        view.backgroundColor=Color(247, 247, 247);
        
        _iconImgView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-30, 10, 20, 20)];
        _iconImgView.image=[UIImage imageNamed:@"right"];
        
        _contentLab=[[ToolLabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        
        [view addSubview:_iconImgView];
        [view addSubview:_contentLab];
        [self.contentView addSubview:view];
    }
    
    return self;
}

-(void)refreashDataForSort:(NSString *)selectStr
{
    [_contentLab setText:selectStr txtFont:[UIFont systemFontOfSize:16] txtColor:[UIColor darkGrayColor]];
}

@end
