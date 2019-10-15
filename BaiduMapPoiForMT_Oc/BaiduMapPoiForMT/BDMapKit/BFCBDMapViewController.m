//
//  BFCBDMapViewController.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBDMapViewController.h"
#import "BFCBDMapViewService.h"

@interface BFCBDMapViewController ()

@property (nonatomic, strong) BFCBDMapViewService *service;
@property (nonatomic, strong) BFCBDMapViewModel *viewModel;

@end

@implementation BFCBDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择地址";
    self.view = self.service;
    
    WEAK
    [self.viewModel.callBackSubject subscribeNext:^(BFCBDMapPoiModel *model) {
        if ([self_weak_.delegate respondsToSelector:@selector(mapViewController:selectedInfo:)]) {
            [self_weak_.delegate mapViewController:self selectedInfo:model];
        }
        [self_weak_.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.service viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.service viewWillDisappear:animated];
}

- (BFCBDMapViewModel *)viewModel{
    if (!_viewModel) {
        self.viewModel = [[BFCBDMapViewModel alloc] init];
    }
    return _viewModel;
}

- (BFCBDMapViewService *)service{
    if (!_service) {
        _service = [[BFCBDMapViewService alloc] initWithViewController:self viewModel:self.viewModel];
    }
    return _service;
}

@end
