//
//  BFCCityButton.h
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFCCityButton : UIView

@property (nonatomic, copy) dispatch_block_t cityButtonBlock;

- (void)setTitle:(NSString *)title;

- (NSString *)getTitle;

@end

NS_ASSUME_NONNULL_END
