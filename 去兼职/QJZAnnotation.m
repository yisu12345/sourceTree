//
//  QJZAnnotation.m
//  去兼职
//
//  Created by yisu on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "QJZAnnotation.h"

@implementation QJZAnnotation

- (BOOL)isEqual:(QJZAnnotation *)object {
    return [self.title isEqual:object.title];
}

@end
