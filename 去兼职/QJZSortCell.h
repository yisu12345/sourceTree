//
//  QJZSortCell.h
//  去兼职
//
//  Created by Mac on 15/10/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJZSortCell : UITableViewCell
@property(strong,nonatomic)UIImageView *iconImgView;
@property(strong,nonatomic)ToolLabel *contentLab;

-(void)refreashDataForSort:(NSString *)selectStr;
@end
