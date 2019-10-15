//
//  BFCBaseViewController.h
//  BFCompetition
//
//  Created by hzhy001 on 2018/10/19.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFCBaseViewController : UIViewController

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIBarButtonItem *settingButtonItem;

@property (nonatomic, strong) UIBarButtonItem *backRootVcButtonItem;

@property (nonatomic, strong) UIBarButtonItem *showMoreButtonItem;

@property (nonatomic, strong) UIBarButtonItem *moreButtonItem;

@property (nonatomic, strong) UIBarButtonItem *saveButtonItem;

- (void)settingButtonItemClick:(UIBarButtonItem *)btn;

- (void)backRootVcButtonItemClick:(UIBarButtonItem *)btn;

- (void)showMoreButtonItemClick:(UIBarButtonItem *)btn;

- (void)moreButtonItemClick:(UIBarButtonItem *)btn;

- (void)saveButtonItemClick:(UIBarButtonItem *)btn;

@end
