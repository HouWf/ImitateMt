//
//  BFCPoiResultListService.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCPoiResultListService.h"
#import "BFCBDMapPoiViewCell.h"

@interface BFCPoiResultListService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BFCPoiResultViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray <BFCBDMapPoiModel *>*dataSrouce;

@end

@implementation BFCPoiResultListService

- (instancetype)initWithViewModel:(NSObject *)viewModel{
    if (self == [super initWithViewModel:viewModel]) {
        self.viewModel = (BFCPoiResultViewModel *)viewModel;
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadViewWithModelList:(NSArray <BFCBDMapPoiModel *>*)modelList
{
    self.dataSrouce = modelList.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSrouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFCBDMapPoiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[BFCBDMapPoiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    BFCBDMapPoiModel *model = self.dataSrouce[indexPath.row];
    cell.poiModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BFCBDMapPoiModel *model = self.dataSrouce[indexPath.row];
    [[self.viewModel callBackSubject] sendNext:model];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSrouce{
    if (!_dataSrouce){
        _dataSrouce = [NSMutableArray array];
    }
    return _dataSrouce;
}

@end
