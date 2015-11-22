//
//  ToolLabel.m
//  修修助手
//
//  Created by Mac on 15-7-15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ToolLabel.h"

@implementation ToolLabel

-(void)setText:(NSString *)txt txtFont:(UIFont*)fnt txtColor:(UIColor *)color
{
    self.text=txt;
    self.font=fnt;
    self.textColor=color;
}

@end
