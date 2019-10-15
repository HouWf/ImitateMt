//
//  BFCPoiResultListController.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewController.h"
#import "BFCBDMapPoiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCPoiResultListController : BFCBaseViewController

@property (nonatomic, strong)    NSArray *resultListArray;

@property (nonatomic, copy) void(^poiListBlock)(BFCBDMapPoiModel *model);

@end

NS_ASSUME_NONNULL_END
