//
//  BFCBDMapViewController.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewController.h"
#import "BFCBDMapPoiModel.h"
@class BFCBDMapViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol BDMapViewControllerDelegate <NSObject>

- (void)mapViewController:(BFCBDMapViewController *)mapView selectedInfo:(BFCBDMapPoiModel *)poiModel;

@end

@interface BFCBDMapViewController : BFCBaseViewController

@property (nonatomic, weak) id<BDMapViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
