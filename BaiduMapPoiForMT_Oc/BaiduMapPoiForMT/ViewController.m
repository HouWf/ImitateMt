//
//  ViewController.m
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/11.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "ViewController.h"
#import "BFCBDMapViewController.h"

@interface ViewController ()<BDMapViewControllerDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *action;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择地址";
    
    [self setupLayout];
    WEAK
    [[self.action rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self_weak_ showMapView];
    }];
}

- (void)setupLayout{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_greaterThanOrEqualTo(20);
        make.top.mas_offset(50);
    }];
    
    [self.action mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.label);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.label.mas_bottom).offset(20);
    }];
}

#pragma mark - BDMapViewControllerDelegate
- (void)mapViewController:(BFCBDMapViewController *)mapView selectedInfo:(BFCBDMapPoiModel *)poiModel;
{
    NSString *ad = @"";
    if (poiModel.city.length) {
       ad = [NSString stringWithFormat:@"%@ %@",poiModel.city, poiModel.address];
    }
    else{
       ad = poiModel.address;
    }
    self.label.text = ad;
}

/// 跳转地图选择地址页
- (void)showMapView{
    BFCBDMapViewController *mapCtr = [[BFCBDMapViewController alloc] init];
    mapCtr.delegate = self;
    [self.navigationController pushViewController:mapCtr animated:YES];
}

- (UILabel *)label{
    if (!_label) {
        _label = [UILabel labelWithTextColor:BFBlackColor textFont:DEFAULTFONT(15) textAligment:NSTextAlignmentCenter];
        _label.numberOfLines = 0;
        _label.text = @"显示地址";
        [self.view addSubview:_label];
    }
    return _label;
}

- (UIButton *)action{
    if (!_action) {
        _action = [UIButton buttonWithType:UIButtonTypeCustom];
        [_action setTitle:@"跳转地图" forState:UIControlStateNormal];
        [_action setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        _action.layer.borderWidth = 1;
        _action.layer.borderColor = BFGrayColor.CGColor;
        _action.layer.cornerRadius = 5.f;
        _action.layer.masksToBounds = YES;
        [self.view addSubview:_action];
    }
    return _action;
}

@end
