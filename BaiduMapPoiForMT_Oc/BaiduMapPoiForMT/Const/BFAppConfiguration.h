//
//  BFAppConfiguration.h
//  BFCompetition
//
//  Created by hzhy001 on 2018/10/19.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFAppConfiguration : NSObject

// 百度AK
UIKIT_EXTERN NSString *const kBdApp_AK;

// 当前定位城市名称
UIKIT_EXTERN NSString *const kCustom_cityName;

// 当前定位经纬度
UIKIT_EXTERN double kCustom_current_lat;

UIKIT_EXTERN double kCustom_current_lon;



@end
