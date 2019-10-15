//
//  BFCPoiResultListService.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewService.h"
#import "BFCPoiResultViewModel.h"
@class BFCBDMapPoiModel;

NS_ASSUME_NONNULL_BEGIN

@interface BFCPoiResultListService : BFCBaseViewService

- (void)reloadViewWithModelList:(NSArray <BFCBDMapPoiModel *>*)modelList;

@end

NS_ASSUME_NONNULL_END
