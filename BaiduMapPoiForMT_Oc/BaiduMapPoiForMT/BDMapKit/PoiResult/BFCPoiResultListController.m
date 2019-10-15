//
//  BFCPoiResultListController.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCPoiResultListController.h"
#import "BFCPoiResultListService.h"

@interface BFCPoiResultListController ()

@property (nonatomic, strong) BFCPoiResultListService *service;

@property (nonatomic, strong) BFCPoiResultViewModel *viewModel;

@end

@implementation BFCPoiResultListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.viewModel = [[BFCPoiResultViewModel alloc] init];
    self.service = [BFCPoiResultListService initWithViewModel:self.viewModel];
    self.view = self.service;
    
    WEAK
    [self.viewModel.callBackSubject subscribeNext:^(BFCBDMapPoiModel *model) {
        BLOCK_EXEC(self_weak_.poiListBlock, model);
    }];
}

- (void)setResultListArray:(NSArray *)resultListArray{
    if (resultListArray != nil) {
        _resultListArray = nil;
        _resultListArray = resultListArray;
        [self.service reloadViewWithModelList:resultListArray];
    }
}

@end
