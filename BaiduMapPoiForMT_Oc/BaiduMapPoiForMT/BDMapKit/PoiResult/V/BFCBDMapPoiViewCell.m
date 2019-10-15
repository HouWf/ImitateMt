//
//  BFCBDMapPoiViewCell.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBDMapPoiViewCell.h"
#import "BFCBDMapPoiModel.h"

@interface BFCBDMapPoiViewCell ()

@property (strong, nonatomic) UIView *logoView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;

@end

@implementation BFCBDMapPoiViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLayout];
        
        WEAK
        [RACObserve(self, poiModel) subscribeNext:^(BFCBDMapPoiModel *model) {
            if (!model) {
                return;
            }
            
            STRONG
            if (model.index == 0) {
                self.nameLabel.textColor = BFRedColor;
                self.logoView.backgroundColor = BFRedColor;
                if (![model.name containsString:@"[当前]"]) {
                    model.name = [NSString stringWithFormat:@"[当前]%@",model.name];
                }
            }
            else{
                self.nameLabel.textColor = BFBlackColor;
                self.logoView.backgroundColor = RGB(204, 204, 204);
            }
            
            self.nameLabel.text = model.name;
            NSString *ad = @"";
            if (model.city.length) {
               ad = [NSString stringWithFormat:@"%@ %@",model.city, model.address];
            }
            else{
               ad = model.address;
            }
            self.addressLabel.text = ad;
            
        }];
    }
    return self;
}

- (void)setupLayout{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_offset(15);
        make.height.width.mas_equalTo(8);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(self.logoView.mas_right).offset(15);
        make.height.mas_equalTo(20).priority(999);
        make.right.mas_offset(-15);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.bottom.mas_offset(-15);
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
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextColor:BFBlackColor textFont:DEFAULTFONT(14) textAligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel labelWithTextColor:BFTextGrayColor textFont:DEFAULTFONT(12) textAligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIView *)logoView{
    if (!_logoView) {
        _logoView = [[UIView alloc] init];
        _logoView.backgroundColor = RGB(204, 204, 204);
        _logoView.layer.cornerRadius = 4.f;
        _logoView.layer.masksToBounds = YES;
        [self.contentView addSubview:_logoView];
    }
    return _logoView;
}

@end
