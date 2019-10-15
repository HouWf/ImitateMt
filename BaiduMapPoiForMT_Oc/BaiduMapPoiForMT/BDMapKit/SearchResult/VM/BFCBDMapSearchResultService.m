//
//  BFCBDMapSearchResultService.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBDMapSearchResultService.h"
#import "BFCBDMapPoiModel.h"
#import "AdSearchResoultViewCell.h"
#import "BFCBDMapPoiModel.h"

@interface BFCBDMapSearchResultService ()<UITableViewDelegate, UITableViewDataSource, BMKSuggestionSearchDelegate, BMKPoiSearchDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) BMKSuggestionSearch *search;

@property (nonatomic, strong) BFCBDMapSearchResultViewModel *viewModel;

@property (nonatomic, copy) NSString *searchText;

@end

@implementation BFCBDMapSearchResultService

- (instancetype)initWithViewModel:(NSObject *)viewModel{
    if (self == [super initWithViewModel:viewModel]) {
        self.viewModel = (BFCBDMapSearchResultViewModel *)viewModel;
        
        self.search = [[BMKSuggestionSearch alloc] init];
        self.search.delegate = self;
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)mengcengTap{
    [self.viewModel.callBackSubject sendNext:Method_cancelSearch];
}

- (void)updateSearchResultsForSearchController:(NSString *)searchText{
    if (searchText.length == 0) {
        [self.dataSource removeAllObjects];
        self.tableView.hidden = YES;
        [self.tableView reloadData];
        [self addGestureRecognizer:self.tap];
    }
    else{
        self.tableView.hidden = NO;
        [self removeGestureRecognizer:self.tap];
        
        self.searchText = searchText;
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = self.viewModel.currentCity;
        option.keyword  = searchText;
        option.cityLimit = YES;
        BOOL flag = [self.search suggestionSearch:option];
        if (flag) {
            NSLog(@"Sug检索发送成功");
        }  else  {
            NSLog(@"Sug检索发送失败");
        }
    }
}

#pragma mark - BMKSuggestionSearchDelegate
/**
 *返回suggestion搜索结果
 *
 1）Sug检索的本质是根据部分关键字检索出来可能的完整关键词名称，即关键词匹配；
 2）POI检索的功能是检索POI，如果需要查询某些关键词对应的POI的具体信息，请使用POI检索来完成。
 注意：Sug检索结果的第一条可能存在没有经纬度信息的情况，该条结果为文字联想出来的关键词结果，并不对应任何确切POI点。
 例如输入“肯”，第一条结果为“肯德基”，这条结果是一个泛指的名称，不会带有经纬度等信息。
 常用的使用方式：用户输入“关键字”时以Sug检索做为检索入口，边输入边检索热词；输入完成后如还没有搜到结果，再用POI检索以“关键字”为keywords再继续搜索。
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:( BMKSuggestionSearchResult*)result errorCode:(BMKSearchErrorCode)error{
   if (error == BMK_SEARCH_NO_ERROR) {
       NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
       for (int i = 0; i < result.suggestionList.count; i++) {
           BMKSuggestionInfo* poi = [result.suggestionList objectAtIndex:i];
           BFCBDMapPoiModel *model = [[BFCBDMapPoiModel alloc]init];
           model.name = poi.key;
           model.city = poi.city;
           model.district = poi.district;
           model.address = poi.address;
           model.lat = poi.location.latitude;
           model.lon = poi.location.longitude;
           model.searchText = self.searchText;
           
           // TODO: 定位经纬度
           double lat = kCustom_current_lat;
           double lon = kCustom_current_lon;
           CLLocationCoordinate2D orCoor = CLLocationCoordinate2DMake(lat, lon);
           CLLocationCoordinate2D trasCoor = BMKCoordTrans(orCoor, BMK_COORDTYPE_GPS, BMK_COORDTYPE_BD09LL);
           BMKMapPoint point1 = BMKMapPointForCoordinate(trasCoor);
           BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(model.lat, model.lon));
           CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
           model.distance = distance;
        
           [array addObject:model];
       }
       self.dataSource = array;
       [self.tableView reloadData];
   } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
       NSLog(@"起始点有歧义");
   } else {
       // 各种情况的判断。。。
   }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_identifier = @"cellId";
    AdSearchResoultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if (!cell) {
        cell = [[AdSearchResoultViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    BFCBDMapPoiModel *model = self.dataSource[indexPath.row];
    cell.resultModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BFCBDMapPoiModel *model = self.dataSource[indexPath.row];
    self.viewModel.selectedModel = model;
    [self.viewModel.callBackSubject sendNext:Method_didSelectedModel];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.hidden = YES;
        self.tableView.estimatedRowHeight = 70;
        [self addSubview:self.tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
       _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengcengTap)];
    }
    return _tap;
}

@end
