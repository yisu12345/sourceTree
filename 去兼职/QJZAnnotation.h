//
//  QJZAnnotation.h
//  去兼职
//
//  Created by yisu on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QJZAnnotation : NSObject<BMKAnnotation>

///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/// 要显示的标题
@property (copy) NSString *title;
/// 要显示的副标题
@property (copy) NSString *subtitle;
//大头针图片属性
@property (nonatomic, strong) UIImage *image;
//做大头针是否唯一判断的属性
@property (nonatomic,strong)NSString * jug;









@end
