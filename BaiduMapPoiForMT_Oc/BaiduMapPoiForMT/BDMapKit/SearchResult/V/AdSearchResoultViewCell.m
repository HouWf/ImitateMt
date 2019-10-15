//
//  AdSearchResoultViewCell.m
//  BaiduMapPoiForMT
//
//  Created by hzhy001 on 2019/10/12.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "AdSearchResoultViewCell.h"
#import "BFCBDMapPoiModel.h"

@interface AdSearchResoultViewCell ()

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *address_label;

@property (nonatomic, strong) UILabel *distance_label;

@end

@implementation AdSearchResoultViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLayout];
        
        [RACObserve(self, resultModel) subscribeNext:^(BFCBDMapPoiModel *model) {
            if (!model) {
                return ;
            }
            
            if ([model.name containsString:model.searchText]) {
                NSString *namSt = model.name;
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.name];
                NSDictionary *dic = @{NSForegroundColorAttributeName:BFRedColor};
                [att addAttributes:dic range:[namSt rangeOfString:model.searchText]];
                self.name_label.attributedText = att;
            }
            else{
                self.name_label.text = model.name;
            }
            if (model.address.length) {
                self.address_label.text = model.address;
            }
            else{
                self.address_label.text = [NSString stringWithFormat:@"%@%@",model.city, model.district];
            }
            
            if (model.distance > 0){
                double dis = model.distance / 1000;
                self.distance_label.text = [NSString stringWithFormat:@"%.2f千米", dis];
            }
            else{
                self.distance_label.text = @"";
            }
       
        }];
        
    }
    return self;
}

- (void)setupLayout{
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(15);
        make.height.mas_equalTo(20).priority(999);
        make.right.equalTo(self.distance_label.mas_left).offset(-10);
    }];
    
    [self.address_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.name_label);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.name_label.mas_bottom).offset(5);
        make.bottom.mas_offset(-15);
    }];

    [self.distance_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - lazy
- (UILabel *)name_label{
    if (!_name_label) {
        _name_label = [UILabel labelWithTextColor:BFBlackColor textFont:DEFAULTFONT(14) textAligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_name_label];
    }
    return _name_label;
}

- (UILabel *)address_label{
    if (!_address_label) {
        _address_label = [UILabel labelWithTextColor:BFTextGrayColor textFont:DEFAULTFONT(12) textAligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_address_label];
    }
    return _address_label;
}

- (UILabel *)distance_label{
    if (!_distance_label) {
        _distance_label = [UILabel labelWithTextColor:rgba(204, 204, 204, 1) textFont:DEFAULTFONT(12) textAligment:NSTextAlignmentRight];
        [self.contentView addSubview:_distance_label];
    }
    return _distance_label;
}


@end
