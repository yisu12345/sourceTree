//
//  QJZHotJobCell.h
//  去兼职
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJZHotJobCell : UITableViewCell
@property(strong,nonatomic)UIImageView *iconImgView;
@property(strong,nonatomic)UIImageView *addrImgView;
@property(strong,nonatomic)UIImageView *timeImgView;
@property(strong,nonatomic)UIImageView *priceImgView;
@property(strong,nonatomic)ToolLabel *titleLab;
@property(strong,nonatomic)ToolLabel *addrLab;
@property(strong,nonatomic)ToolLabel *timeLab;
@property(strong,nonatomic)ToolLabel *priceLab;

-(void)refreashDataForHotJob:(NSDictionary *)dict;
@end
