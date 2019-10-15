//
//  BFCBDMapViewService.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBDMapViewService.h"
#import "BFCPoiResultListController.h"
#import "BFCBDMapViewController.h"
#import "BFCBDMapSearchResultController.h"
#import "GYZChooseCityController.h"
#import "BFCCityButton.h"

@interface BFCBDMapViewService ()<BMKPoiSearchDelegate,
BMKMapViewDelegate,
BMKLocationAuthDelegate,
BMKGeoCodeSearchDelegate,
BMKLocationManagerDelegate,
GYZChooseCityDelegate,
AdSearchResultDelegate,
UISearchBarDelegate>

@property (nonatomic, strong) BFCPoiResultListController *poiResultVC;

@property (nonatomic, strong) BFCBDMapViewController *VC;

@property (nonatomic, strong) BFCBDMapViewModel *viewModel;

// map
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
// 搜索服务
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
// 地图
@property (nonatomic, strong) BMKMapView *mapView;
// 位置服务
@property (nonatomic, strong) BMKLocationManager *locationManager;
// 中心点
@property (nonatomic, strong) UIImageView *poiView;
// 回到原来位置
@property (nonatomic, strong) UIButton *getLocationBtn;
// poi内容列表
@property (nonatomic, strong) UIView *contentView;
// 顶部视图
@property (nonatomic, strong) UIView *toobarView;
// 城市选择按钮
@property (nonatomic, strong) BFCCityButton *cityButton;
// 搜索框
@property (nonatomic, strong) UISearchBar *searchBar;
// 搜索结果页
@property (nonatomic, strong) BFCBDMapSearchResultController *searchResultView;

@end

@implementation BFCBDMapViewService

- (instancetype)initWithViewController:(UIViewController *)VC viewModel:(NSObject *)viewModel{
    if (self == [super init]) {
        self.VC = (BFCBDMapViewController *)VC;
        self.viewModel = (BFCBDMapViewModel *)viewModel;
        
        [self.cityButton setTitle:kCustom_cityName];
        
        WEAK
        [self.cityButton setCityButtonBlock:^{
            [self_weak_ cityBtnClick];
        }];
        [self.poiResultVC setPoiListBlock:^(BFCBDMapPoiModel *model) {
            // 地图跳转到指定位置
//            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){model.lat,model.lon};
//            [self_weak_.mapView setCenterCoordinate:pt animated:YES];
            // 数据回传
            [self_weak_.viewModel.callBackSubject sendNext:model];
        }];
        [self.contentView addSubview:self.poiResultVC.view];

        [self setupLayout];
        [self initLocation];
    }
    return self;
}

- (void)setupLayout{
    [self.toobarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.toobarView);
        make.width.mas_equalTo(70);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityButton.mas_right);
        make.height.mas_equalTo(44);
        make.right.mas_offset(-15);
        make.centerY.equalTo(self.toobarView);
    }];
    
    CGFloat mapWith = Main_Screen_Width/2;
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.toobarView.mas_bottom);
        make.height.mas_equalTo(mapWith);
    }];
    
    [self.poiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapView);
        make.centerY.equalTo(self.mapView.mas_centerY).offset(-20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.getLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.poiResultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.searchResultView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toobarView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kBdApp_AK authDelegate:self];
    self.mapView.delegate = self;
    self.poiSearch.delegate = self;
    self.geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kBdApp_AK authDelegate:nil];
    self.mapView.delegate = nil;
    self.poiSearch.delegate = nil;
    self.geocodesearch.delegate = nil;
}

- (void)initLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        // 定位功能可用，开始定位
        [self setLocation];
        [self startLocation];
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ){
        NSLog(@"跳转授权");
        if (![CLLocationManager locationServicesEnabled]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    else{
        NSLog(@"[CLLocationManager authorizationStatus] == %i",[CLLocationManager authorizationStatus]);
    }
}

#pragma mark 设置定位参数
- (void)setLocation
{
    self.locationManager = [[BMKLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10;
    self.locationManager.distanceFilter = distance;
    
    self.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    self.locationManager.locationTimeout = 10;
}

- (void)startLocation{
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

/// geo检索
- (void)geoCodeWithName:(NSString *)cityName address:(NSString *)address{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city = cityName;
    geoCodeSearchOption.address = address;
    BOOL flag = [self.geocodesearch geoCode: geoCodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }  else  {
        NSLog(@"geo检索发送失败");
    }
}

/// 反geo检索
- (void)reverseGeocodeWithLocation:(CLLocationCoordinate2D)pt{
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = pt;
    reverseGeocodeSearchOption.pageNum = 0;
    reverseGeocodeSearchOption.pageSize = 100;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
     NSLog(@"反geo检索发送成功");
    }
    else
    {
     NSLog(@"反geo检索发送成功");
    }
}

/// 重构poi结果，刷新地域列表
- (void)loadPoiDataWithList:(NSArray <BMKPoiInfo *>*)poiList{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < poiList.count; i++) {
        BMKPoiInfo* poi = poiList[i];
        BFCBDMapPoiModel *model = [[BFCBDMapPoiModel alloc] init];
        model.name = poi.name;
        model.province = poi.province;
        model.city = poi.city;
        model.address = poi.address;
        model.lat = poi.pt.latitude;
        model.lon = poi.pt.longitude;
        model.index = i;
        [array addObject:model];
        if (i == 0 && model.city.length) {
            [self.cityButton setTitle:model.city];
        }
    }
    self.poiResultVC.resultListArray = [NSArray arrayWithArray:array];
}

#pragma mark - action
- (void)currentAddressMsg:(UIButton *)sender{
    self.getLocationBtn.enabled = NO;
    WEAK
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self_weak_.getLocationBtn.enabled = YES;
    });
    [self initLocation];
}

- (void)cityBtnClick{
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    cityPickerVC.delegate = self;
    [self.VC presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
}

#pragma mark - GYZChooseCityDelegate

- (void)cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city{
    [self geoCodeWithName:city.cityName address:city.cityName];
    // 修改z选择的城市
    [self.cityButton setTitle:city.cityName];
    [chooseCityController dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController{
    [chooseCityController dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - AdSearchResultDelegate
- (void)cancelSearchResultViewController:(BFCBDMapSearchResultController *)seachVc{
    [self searchBarCancelButtonClicked:self.searchBar];
}

- (void)searchResultViewController:(BFCBDMapSearchResultController *)seachVc didSelectedModel:(BFCBDMapPoiModel *)resultModel
{
    [self.viewModel.callBackSubject sendNext:resultModel];
}

#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    NSLog(@"didFailWithError = %@",error);
}

/**
 *用户位置更新后，会调用此函数
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.poiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mapView).offset(-35);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
          [self.poiView mas_updateConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(self.mapView).offset(-20);
          }];
          [self layoutIfNeeded];
      } completion:nil];
    }];

    self.getLocationBtn.enabled = YES;
    [self reverseGeocodeWithLocation:location.location.coordinate];
    [_mapView setCenterCoordinate:location.location.coordinate animated:YES];
    [_locationManager stopUpdatingLocation];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
// ???: 选择城市后地图是否定位到地图s城市
//        BMKCoordinateRegion region ;//表示范围的结构体
//        CLLocationCoordinate2D coor;
//        coor.latitude = result.location.latitude;
//        coor.longitude = result.location.longitude;
//        region.center = coor;//中心点
//        region.span.latitudeDelta = 0.2;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
//        region.span.longitudeDelta = 0.2;//纬度范围
//        [self.mapView setRegion:region animated:YES];
    }
    
    [_locationManager stopUpdatingLocation];
}

/**
 *返回反地理编码搜索结果
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        [self loadPoiDataWithList:result.poiList];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [self loadPoiDataWithList:poiResult.poiInfoList];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    }
    else {
        // 各种情况的判断。。。
    }
}

#pragma mark - BMKMapViewDelegate
/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.poiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mapView).offset(-35);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
          [self.poiView mas_updateConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(self.mapView).offset(-20);
          }];
          [self layoutIfNeeded];
      } completion:nil];
    }];

    [self reverseGeocodeWithLocation:mapView.centerCoordinate];
}

/// 大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{

    static NSString *pinID = @"pinID";
    // 从缓存池取出大头针数据视图
    BMKAnnotationView *customView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    // 如果取出的为nil , 那么就手动创建大头针视图
    if (customView == nil) {
        customView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
    }
    // 1. 设置大头针图片
    customView.image = [UIImage imageNamed:@"point"];
    // 2. 设置弹框
    customView.canShowCallout = YES;

    return customView;
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchResultView.view.hidden = NO;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    // 搜索时显示搜索的城市
    self.searchResultView.selectedCity = [self.cityButton getTitle];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchResultView.view.hidden = NO;
    [self.searchResultView updateSearchResultsForSearchController:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.searchResultView updateSearchResultsForSearchController:@""];
    self.searchResultView.view.hidden = YES;
}

#pragma mark - lazy

- (BMKPoiSearch *)poiSearch{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc] init];
    }
    return _poiSearch;
}

- (BMKGeoCodeSearch *)geocodesearch{
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geocodesearch;
}

- (BFCPoiResultListController *)poiResultVC{
    if (!_poiResultVC) {
        _poiResultVC = [[BFCPoiResultListController alloc] init];
        [self.VC addChildViewController:_poiResultVC];
    }
    return _poiResultVC;
}

- (BFCBDMapSearchResultController *)searchResultView{
    if (!_searchResultView) {
        _searchResultView = [[BFCBDMapSearchResultController alloc] init];
        _searchResultView.view.hidden = YES;
        [self.VC addChildViewController:_searchResultView];
        [self addSubview:_searchResultView.view];
        _searchResultView.delegate = self;
    }
    return _searchResultView;
}

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toobarView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2)];
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = YES;
        _mapView.zoomEnabledWithTap = NO;
        _mapView.zoomLevel = 17;
        
        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
        displayParam.isRotateAngleValid = false;//跟随态旋转角度是否生效
        displayParam.isAccuracyCircleShow = false;//精度圈是否显示
        [self.mapView updateLocationViewWithParam:displayParam];
        [self addSubview:self.mapView];
    }
    return _mapView;
}

- (UIImageView *)poiView{
    if (!_poiView) {
        _poiView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"poi"]];
        _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
        [self.mapView addSubview:_poiView];
    }
    return _poiView;
}

- (UIButton *)getLocationBtn{
    if (!_getLocationBtn) {
        _getLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getLocationBtn.frame = CGRectMake(_mapView.frame.size.width - 45, _mapView.frame.size.height - 55, 40, 40);
        [_getLocationBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
        [_getLocationBtn addTarget:self action:@selector(currentAddressMsg:) forControlEvents:UIControlEventTouchUpInside];
        _getLocationBtn.enabled = NO;
        [self.mapView addSubview:_getLocationBtn];
    }
    return _getLocationBtn;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIView *)toobarView{
    if (!_toobarView) {
        _toobarView = [[UIView alloc] init];
        _toobarView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_toobarView];
    }
    return _toobarView;
}

- (BFCCityButton *)cityButton{
    if (!_cityButton) {
        _cityButton = [[BFCCityButton alloc] init];
        [self.toobarView addSubview:_cityButton];
    }
    return _cityButton;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.translucent  = YES;
        _searchBar.delegate     = self;
        _searchBar.placeholder  = @"请输入您的地址";
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.tintColor = UIColor.grayColor;
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
        [self.toobarView addSubview:_searchBar];
    }
    return _searchBar;
}

@end
