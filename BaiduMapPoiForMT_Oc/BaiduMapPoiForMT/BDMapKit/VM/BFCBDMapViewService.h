//
//  BFCBDMapViewService.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewService.h"
#import "BFCBDMapViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCBDMapViewService : BFCBaseViewService

- (instancetype)initWithViewController:(UIViewController *)VC viewModel:(NSObject *)viewModel;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
