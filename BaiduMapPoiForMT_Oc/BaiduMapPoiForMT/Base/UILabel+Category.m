//
//  UILabel+Category.m
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (UILabel *)labelWithTextColor:(UIColor *)color textFont:(UIFont *)font textAligment:(NSTextAlignment)alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}


@end
