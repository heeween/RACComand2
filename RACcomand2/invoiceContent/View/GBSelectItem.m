//
//  GBInvoiceNameItemView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBSelectItem.h"
#import "GBInvoiceContentView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
@interface GBSelectItem()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomLine;
@end
@implementation GBSelectItem

+(instancetype)selectItemViewWith:(Invoice_Owner)type {
    GBSelectItem *view = [[GBSelectItem alloc] init];
    [view setupUI];
    view.type = type;
    return view;
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
-(void)setType:(Invoice_Owner)type {
    switch (type) {
        case Invoice_Owner_Company:
            self.companyButton.selected = YES;
            self.personalButton.selected = NO;
            break;
        case Invoice_Owner_Personal:
            self.companyButton.selected = NO;
            self.personalButton.selected = YES;
            break;
        default:
            break;
    }
}
- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.personalButton];
    [self addSubview:self.companyButton];
    [self addSubview:self.bottomLine];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.personalButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(@78);
    }];
    [self.companyButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.personalButton.mas_left);
        make.width.equalTo(@78);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@(0.5));
    }];
}
- (UIButton *)companyButton {
    if (!_companyButton) {
        _companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_companyButton setTitle:@"单位" forState:UIControlStateNormal];
        [_companyButton setTitleColor:[UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1] forState:UIControlStateSelected];
        [_companyButton setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        [_companyButton setImage:[UIImage imageNamed:@"common_radio_icon_normal"] forState:UIControlStateNormal];
        [_companyButton setImage:[UIImage imageNamed:@"common_radio_icon_select"] forState:UIControlStateSelected];
        _companyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _companyButton.titleEdgeInsets = UIEdgeInsetsFromString(@"{0,2.5,0,-2,5}");
        _companyButton.imageEdgeInsets = UIEdgeInsetsFromString(@"{0,-2.5,0,2.5}");
    }
    return _companyButton;
}
- (UIButton *)personalButton {
    if (!_personalButton) {
        _personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_personalButton setTitle:@"个人" forState:UIControlStateNormal];
        [_personalButton setTitleColor:[UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1] forState:UIControlStateSelected];
        [_personalButton setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        [_personalButton setImage:[UIImage imageNamed:@"common_radio_icon_normal"] forState:UIControlStateNormal];
        [_personalButton setImage:[UIImage imageNamed:@"common_radio_icon_select"] forState:UIControlStateSelected];
        _personalButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _personalButton.titleEdgeInsets = UIEdgeInsetsFromString(@"{0,2.5,0,-2,5}");
        _personalButton.imageEdgeInsets = UIEdgeInsetsFromString(@"{0,-2.5,0,2.5}");
    }
    return _personalButton;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _bottomLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"抬头类型";
    }
    return _titleLabel;
}
@end
