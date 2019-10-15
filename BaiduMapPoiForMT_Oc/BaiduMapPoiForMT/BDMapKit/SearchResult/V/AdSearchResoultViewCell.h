//
//  AdSearchResoultViewCell.h
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/12.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BFCBDMapPoiModel;

NS_ASSUME_NONNULL_BEGIN

@interface AdSearchResoultViewCell : UITableViewCell

@property (nonatomic, strong) BFCBDMapPoiModel *resultModel;

@end

NS_ASSUME_NONNULL_END
