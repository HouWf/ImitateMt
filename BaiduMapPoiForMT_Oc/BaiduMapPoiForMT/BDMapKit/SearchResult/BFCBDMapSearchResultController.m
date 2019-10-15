//
//  BFCBDMapSearchResultController.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBDMapSearchResultController.h"
#import "BFCBDMapSearchResultService.h"

@interface BFCBDMapSearchResultController ()

@property (nonatomic, strong) BFCBDMapSearchResultService *service;

@property (nonatomic, strong) BFCBDMapSearchResultViewModel *viewModel;

@end

@implementation BFCBDMapSearchResultController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedCity = kCustom_cityName;
    }
    return self;
}

- (void)setSelectedCity:(NSString *)selectedCity{
    _selectedCity = selectedCity;
    self.viewModel.currentCity = self.selectedCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[BFCBDMapSearchResultViewModel alloc] init];
    self.service = [BFCBDMapSearchResultService initWithViewModel:self.viewModel];
    self.viewModel.currentCity = self.selectedCity;
    self.view = self.service;
    self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    
    [self.viewModel.callBackSubject subscribeNext:^(NSString *Selector) {
        SEL sel = NSSelectorFromString(Selector);
        if ([self canRunToSelector:sel]) {
            [self runSelector:sel withObjects:@[]];
        }
    }];
}

- (void)updateSearchResultsForSearchController:(NSString *)searchText{
    [self.service updateSearchResultsForSearchController:searchText];
}

- (void)cancelSearch{
    if ([self.delegate respondsToSelector:@selector(cancelSearchResultViewController:)]) {
        [self.delegate cancelSearchResultViewController:self];
    }
}

- (void)didSelectedModel{
    if ([self.delegate respondsToSelector:@selector(searchResultViewController:didSelectedModel:)]) {
        [self.delegate searchResultViewController:self didSelectedModel:self.viewModel.selectedModel];
    }
}

@end
