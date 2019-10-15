//
//  BFCCityButton.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/10/15.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCCityButton.h"

@interface BFCCityButton ()

@property (nonatomic, copy) UILabel *nameLabel;

@property (nonatomic, copy) UIImageView *iconView;

@end

@implementation BFCCityButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayout];
        
        UITapGestureRecognizer *tapGe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tapGe];
    }
    return self;
}

- (void)setupLayout{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(50);
        make.left.mas_offset(5);
        make.height.equalTo(self);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.width.height.mas_equalTo(13);
        make.left.equalTo(self.nameLabel.mas_right).offset(4);
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tapGes{
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        BLOCK_EXEC(self.cityButtonBlock);
    }
}

- (void)setTitle:(NSString *)title{
    self.nameLabel.text = title;
}

- (NSString *)getTitle{
    if (self.nameLabel.text.length) {
        return self.nameLabel.text;
    }
    return @"";
}

#pragma mark - lazy
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextColor:BFBlackColor textFont:DEFAULTFONT(14) textAligment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:GetImage(@"down_icon")];
        [self addSubview:_iconView];
    }
    return _iconView;
}


@end
