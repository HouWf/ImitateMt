//
//  BFCBDMapSearchResultController.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewController.h"
#import "BFCBDMapPoiModel.h"
@class BFCBDMapSearchResultController;

NS_ASSUME_NONNULL_BEGIN

@protocol AdSearchResultDelegate <NSObject>

- (void)cancelSearchResultViewController:(BFCBDMapSearchResultController *)seachVc;

- (void)searchResultViewController:(BFCBDMapSearchResultController *)seachVc didSelectedModel:(BFCBDMapPoiModel *)resultModel;

@end

@interface BFCBDMapSearchResultController : BFCBaseViewController

@property (nonatomic, weak) id<AdSearchResultDelegate>delegate;

- (void)updateSearchResultsForSearchController:(NSString *)searchText;

@property (nonatomic, copy) NSString *selectedCity;

@end


NS_ASSUME_NONNULL_END
