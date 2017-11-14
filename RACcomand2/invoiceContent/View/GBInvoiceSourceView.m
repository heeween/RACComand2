//
//  GBInvoiceTypeView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceSourceView.h"
#import <Masonry.h>

@interface GBInvoiceSourceView()
@property (nonatomic,strong) UILabel *headerTitleLabel;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) UIView *indicatorLine;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) MASConstraint *indicatorWithNonPaperConstraint;
@property (nonatomic,strong) MASConstraint *indicatorWithPaperConstraint;
@end

@implementation GBInvoiceSourceView

+(instancetype)sourceViewWith:(Invoice_Source)type {
    GBInvoiceSourceView *view = [[GBInvoiceSourceView alloc] init];
    [view setupUI];
    view.type = type;
    return view;
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    switch (self.type) {
        case Invoice_Source_NonPaper:
        {
            [self.indicatorWithNonPaperConstraint activate];
            [self.indicatorWithPaperConstraint deactivate];
        }
            break;
            
        case Invoice_Source_Paper:
        {
            [self.indicatorWithNonPaperConstraint deactivate];
            [self.indicatorWithPaperConstraint activate];
        }
            break;
        default:
            break;
    }

    [super updateConstraints];
}
-(void)setType:(Invoice_Source)type {
    _type = type;
    [self setNeedsUpdateConstraints];
    
    switch (self.type) {
        case Invoice_Source_NonPaper:
            self.nonPaperButton.selected = YES;
            self.paperButton.selected = NO;
            break;
            
        case Invoice_Source_Paper:
            self.nonPaperButton.selected = NO;
            self.paperButton.selected = YES;
            break;
        default:
            break;
    }
}
- (void)setupUI {
    
    [self addSubview:self.headerTitleLabel];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.nonPaperButton];
    [self.containerView addSubview:self.paperButton];
    [self.containerView addSubview:self.bottomLine];
    [self.containerView addSubview:self.indicatorLine];
    [self.containerView addSubview:self.descLabel];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(18);
        make.bottom.equalTo(self.containerView.mas_top).offset(-8);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.headerTitleLabel);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
    }];
    [self.nonPaperButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self.containerView);
        make.height.equalTo(@44);
    }];
    [self.paperButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.top.equalTo(self.containerView);
        make.left.equalTo(self.nonPaperButton.mas_right);
        make.width.height.equalTo(self.nonPaperButton);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.nonPaperButton.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@(0.5));
    }];
    [self.indicatorLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.nonPaperButton);
        make.height.equalTo(@(2));
        make.bottom.equalTo(self.bottomLine);
        self.indicatorWithNonPaperConstraint = make.centerX.equalTo(self.nonPaperButton);
        self.indicatorWithPaperConstraint = make.centerX.equalTo(self.paperButton);
    }];
    [self.indicatorWithNonPaperConstraint deactivate];
    [self.indicatorWithPaperConstraint deactivate];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.nonPaperButton.mas_bottom).offset(10);
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.bottom.equalTo(self.containerView).offset(-10);
    }];
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.text = @"尊敬的用户您好，如你急需报销，我们推荐您使用电子发票。根据国家相关规定，电子发票的法律效力、基本用途、基本使用规定与税务机关监制的增值税纸质发票相同。";
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (UIView *)indicatorLine {
    if (!_indicatorLine) {
        _indicatorLine = [UIView new];
        _indicatorLine.backgroundColor =  [UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1];
    }
    return _indicatorLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _bottomLine;
}
- (UIButton *)paperButton {
    if (!_paperButton) {
        _paperButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paperButton setTitle:@"纸质发票" forState:UIControlStateNormal];
        [_paperButton setTitleColor: [UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1] forState:UIControlStateSelected];
        [_paperButton setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        [_paperButton setImage:[UIImage imageNamed:@"common_radio_icon_normal"] forState:UIControlStateNormal];
        [_paperButton setImage:[UIImage imageNamed:@"common_radio_icon_select"] forState:UIControlStateSelected];
        _paperButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _paperButton.titleEdgeInsets = UIEdgeInsetsFromString(@"{0,2.5,0,-2,5}");
        _paperButton.imageEdgeInsets = UIEdgeInsetsFromString(@"{0,-2.5,0,2.5}");
    }
    return _paperButton;
}
- (UIButton *)nonPaperButton {
    if (!_nonPaperButton) {
        _nonPaperButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nonPaperButton setTitle:@"电子发票" forState:UIControlStateNormal];
        [_nonPaperButton setTitleColor: [UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1] forState:UIControlStateSelected];
        [_nonPaperButton setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        [_nonPaperButton setImage:[UIImage imageNamed:@"common_radio_icon_normal"] forState:UIControlStateNormal];
        [_nonPaperButton setImage:[UIImage imageNamed:@"common_radio_icon_select"] forState:UIControlStateSelected];
        _nonPaperButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _nonPaperButton.titleEdgeInsets = UIEdgeInsetsFromString(@"{0,2.5,0,-2,5}");
        _nonPaperButton.imageEdgeInsets = UIEdgeInsetsFromString(@"{0,-2.5,0,2.5}");
    }
    return _nonPaperButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        _containerView.layer.shadowRadius = 10;
        _containerView.layer.shadowOffset = CGSizeMake(0, 5);
        _containerView.layer.shadowOpacity = 1;
    }
    return _containerView;
}
- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [UILabel new];
        _headerTitleLabel.textColor = [UIColor lightGrayColor];
        _headerTitleLabel.font = [UIFont systemFontOfSize:13];
        _headerTitleLabel.text = @"发票类型";
    }
    return _headerTitleLabel;
}
@end
