//
//  BFCBDMapSearchResultService.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewService.h"
#import "BFCBDMapSearchResultViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCBDMapSearchResultService : BFCBaseViewService

- (void)updateSearchResultsForSearchController:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
