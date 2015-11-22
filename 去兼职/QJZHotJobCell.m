//
//  QJZHotJobCell.m
//  去兼职
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QJZHotJobCell.h"

@implementation QJZHotJobCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=Color(225, 225, 225);
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 95)];
        view.backgroundColor=[UIColor whiteColor];
        
        _iconImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 40, 30)];
        _titleLab=[[ToolLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgView.frame)+5, 10, kWidth-60, 30)];
        
        _addrImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        _addrLab=[[ToolLabel alloc]initWithFrame:CGRectZero];
        
        _timeImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        _timeLab=[[ToolLabel alloc]initWithFrame:CGRectZero];
        
        _priceImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        _priceLab=[[ToolLabel alloc]initWithFrame:CGRectZero];
        
        [view addSubview:_iconImgView];
        [view addSubview:_titleLab];
        [view addSubview:_addrImgView];
        [view addSubview:_addrLab];
        [view addSubview:_timeImgView];
        [view addSubview:_timeLab];
        [view addSubview:_priceImgView];
        [view addSubview:_priceLab];
        [self.contentView addSubview:view];
    }
    
    return self;
}

-(void)refreashDataForHotJob:(NSDictionary *)dict
{
    NSLog(@"%@",dict[@"job_class"]);
    
    if ([dict[@"job_class"] isEqual:@"临时工"]) {
       _iconImgView.image=[UIImage imageNamed:@"临时"];
    }else if([dict[@"job_class"] isEqual:@"送餐员"]){
        _iconImgView.image=[UIImage imageNamed:@"送餐"];
    }else{
        _iconImgView.image=[UIImage imageNamed:dict[@"job_class"]];
    }
    
    
    _titleLab.text=dict[@"job_name"];
    
    _addrImgView.image=[UIImage imageNamed:@"Area"];
    _addrImgView.frame=CGRectMake(CGRectGetMaxX(_iconImgView.frame)+5, 75, 15, 15);
    
    NSString *addrStr=dict[@"address"];
    if ([dict[@"address"] isKindOfClass:[NSNull class]]) {
        addrStr=@"";
    }
    [_addrLab setText:addrStr txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor darkGrayColor]];
    CGSize addrSize=[_addrLab.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat addrX=CGRectGetMaxX(_addrImgView.frame);
    CGFloat addrY=75;
    _addrLab.frame=(CGRect){{addrX,addrY},addrSize};
    
    _timeImgView.image=[UIImage imageNamed:@"Just"];
    _timeImgView.frame=CGRectMake(CGRectGetMaxX(_addrLab.frame)+10, 75, 15, 15);
    
    [_timeLab setText:dict[@"sdate"] txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor darkGrayColor]];
    CGSize timeSize=[dict[@"sdate"] sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat timeX=CGRectGetMaxX(_timeImgView.frame);
    CGFloat timeY=75;
    _timeLab.frame=(CGRect){{timeX,timeY},timeSize};
    
    _priceImgView.image=[UIImage imageNamed:@"Time"];
    _priceImgView.frame=CGRectMake(CGRectGetMaxX(_timeLab.frame)+10, 75, 15, 15);
    
    [_priceLab setText:[NSString stringWithFormat:@"%@%@",dict[@"salary"],dict[@"salary_jiesuan_type"]] txtFont:[UIFont systemFontOfSize:12] txtColor:[UIColor darkGrayColor]];
    CGSize priceSize=[_priceLab.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat priceX=CGRectGetMaxX(_priceImgView.frame);
    CGFloat priceY=75;
    _priceLab.frame=(CGRect){{priceX,priceY},priceSize};
}
@end
