//
//  BFCBaseViewController.m
//  BFCompetition
//
//  Created by hzhy001 on 2018/10/19.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import "BFCBaseViewController.h"

@interface BFCBaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BFCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置界面不延伸，导航会变灰
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 防止导航变灰
    self.navigationController.navigationBar.translucent = NO;

}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (UIBarButtonItem *)settingButtonItem{
    if (!_settingButtonItem) {
        
    }
    return _settingButtonItem;
}

- (UIBarButtonItem *)backRootVcButtonItem{
    if (!_backRootVcButtonItem) {
        _backRootVcButtonItem = [[UIBarButtonItem alloc] initWithImage:GetImage(@"back_black") style:UIBarButtonItemStyleDone target:self action:@selector(backRootVcButtonItemClick:)];
    }
    return _backRootVcButtonItem;
}

- (UIBarButtonItem *)showMoreButtonItem{
    if (!_showMoreButtonItem) {
        _showMoreButtonItem = [[UIBarButtonItem alloc] initWithImage:GetImage(@"baritem_more_icon") style:UIBarButtonItemStyleDone target:self action:@selector(showMoreButtonItemClick:)];
    }
    return _showMoreButtonItem;
}

- (UIBarButtonItem *)moreButtonItem{
    if (!_moreButtonItem) {
        _moreButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(moreButtonItemClick:)];
    }
    return _moreButtonItem;
}

- (UIBarButtonItem *)saveButtonItem{
    if (!_moreButtonItem) {
        _moreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    }
    return _moreButtonItem;
}

- (void)settingButtonItemClick:(UIBarButtonItem *)btn{
    
}

- (void)backRootVcButtonItemClick:(UIBarButtonItem *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showMoreButtonItemClick:(UIBarButtonItem *)btn{
    
}

- (void)moreButtonItemClick:(UIBarButtonItem *)btn{
    
}

- (void)saveButtonItemClick:(UIButton *)btn{
    
}

-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_saveButton setTitleColor:BFRedColor forState:UIControlStateNormal];
        [_saveButton setTitleColor:BFTextGrayColor forState:UIControlStateDisabled];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.titleLabel.font = DEFAULTFONT(14.0);
        [_saveButton addTarget:self action:@selector(saveButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
