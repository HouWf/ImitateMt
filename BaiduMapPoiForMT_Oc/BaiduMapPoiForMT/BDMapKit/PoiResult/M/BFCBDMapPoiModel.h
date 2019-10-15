//
//  BFCBDMapPoiModel.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFCBDMapPoiModel : NSObject

@property (nonatomic, copy) NSString *name;
// 省
@property (nonatomic, copy) NSString *province;
// 市
@property (nonatomic, copy) NSString *city;
// 联想结果所在区县
@property (nonatomic, copy) NSString *district;
// 位置
@property (nonatomic, copy) NSString *address;
// 距离
@property (nonatomic, assign) double distance;
// 经度
@property (nonatomic, assign) double lat;
// 纬度
@property (nonatomic, assign) double lon;
// 编号
@property (nonatomic, assign) NSInteger index;
// 关键字
@property (nonatomic, copy) NSString *key;
// 搜索关键词
@property (nonatomic, copy) NSString *searchText;

@end

NS_ASSUME_NONNULL_END
