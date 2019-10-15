//
//  BFCBaseViewModel.m
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewModel.h"

@implementation BFCBaseViewModel

- (RACSubject *)callBackSubject{
    if (!_callBackSubject) {
        _callBackSubject = [RACSubject subject];
    }
    return _callBackSubject;
}

@end
