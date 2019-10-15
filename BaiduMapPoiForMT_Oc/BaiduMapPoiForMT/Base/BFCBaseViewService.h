//
//  BFCBaseViewService.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/9/16.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFCBaseViewService : UIView

+ (instancetype)initWithViewModel:(NSObject *)viewModel;

- (instancetype)initWithViewModel:(NSObject *)viewModel;

@end

NS_ASSUME_NONNULL_END
