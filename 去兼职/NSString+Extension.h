//
//  NSString+Extension.h
//  莫名.微博
//
//  Created by zm on 15-6-17.
//  Copyright (c) 2015年 moming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
/**    时间戳转时间字符串      */
+(instancetype)stringWithDate:(NSString *)string;
+(instancetype)stringWithDateDetail:(NSString *)string;
+(instancetype)stringWithDateNoneCHDetail:(NSString *)string;
@end
