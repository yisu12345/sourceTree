//
//  moreTableViewCell.h
//  去兼职
//
//  Created by yisu on 15/11/20.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface moreTableViewCell : UITableViewCell

@property(strong,nonatomic)UIImageView *iconImgView;
@property(strong,nonatomic)ToolLabel *titleLab;

-(void)refreashDataForHomePageIconImgName:(NSString *)imgName title:(NSString *)title;


@end
