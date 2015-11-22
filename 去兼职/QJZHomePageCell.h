//
//  QJZHomePageCell.h
//  去兼职
//
//  Created by Mac on 15/10/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJZHomePageCell : UITableViewCell
@property(strong,nonatomic)UIImageView *iconImgView;
@property(strong,nonatomic)ToolLabel *titleLab;
@property(strong,nonatomic)ToolLabel *contentLab;
@property(strong,nonatomic)ToolLabel *countLab;

-(void)refreashDataForHomePageIconImgName:(NSString *)imgName title:(NSString *)title count:(NSString *)count;
@end
