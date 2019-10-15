//
//  UILabel+Category.h
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Category)

+ (UILabel *)labelWithTextColor:(UIColor *)color textFont:(UIFont *)font textAligment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
