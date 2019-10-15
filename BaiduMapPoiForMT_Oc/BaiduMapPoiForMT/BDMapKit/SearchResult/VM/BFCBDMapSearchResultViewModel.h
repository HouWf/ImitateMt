//
//  BFCBDMapSearchResultViewModel.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewModel.h"
#import "BFCBDMapPoiModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * Method_cancelSearch       = @"cancelSearch";
static NSString * Method_didSelectedModel   = @"didSelectedModel";

@interface BFCBDMapSearchResultViewModel : BFCBaseViewModel

@property (nonatomic, copy) NSString *currentCity;

@property (nonatomic, strong) BFCBDMapPoiModel *selectedModel;

@end

NS_ASSUME_NONNULL_END
