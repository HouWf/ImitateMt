//
//  BFCBaseViewModel.h
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFCBaseViewModel : NSObject

@property (nonatomic, strong) RACSubject *callBackSubject;

@end

NS_ASSUME_NONNULL_END
