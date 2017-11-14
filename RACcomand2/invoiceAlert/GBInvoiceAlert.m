//
//  GBInvoiceAlert.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/11/1.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceAlert.h"
#import <Masonry.h>
@interface GBInvoiceAlert()
@property (nonatomic,copy) NSArray          *params;
@property (nonatomic,strong) UIButton       *backView;
@property (nonatomic,strong) UIView         *containerView;
@property (nonatomic, strong) UILabel       *titleLabel;//标题
@property (nonatomic,strong) UIView         *topLine;
@property (nonatomic,strong) UIView         *bottomLine;
@property (nonatomic,strong) UIView         *centerLine;
@property (nonatomic,strong) UIButton       *cancelBtn;
@property (nonatomic,strong) void(^confirmBlock)();
@end
@implementation GBInvoiceAlert

+ (instancetype)showWith:(NSArray *)params confirmBlock:(void(^)())confirmBlock {
    GBInvoiceAlert *alert = [[GBInvoiceAlert alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    alert.params = params;
    alert.confirmBlock = confirmBlock;
    [[[UIApplication sharedApplication] keyWindow ] addSubview:alert];
    alert.backView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.9;
    }];
    return alert;
}
- (void)setParams:(NSArray *)params {
    _params = params;
    [self setupUI];
}
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.0f;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)confirm {
    if (self.confirmBlock) { self.confirmBlock(); }
    [self hide];
}
- (void)setupUI {
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(52);
        make.right.equalTo(self).offset(-52);
        make.centerY.equalTo(self);
    }];
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.containerView);
        make.height.equalTo(@43);
        make.top.equalTo(self.containerView);
    }];
    [self.containerView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@(0.5));
        make.left.right.equalTo(self.containerView);
    }];
    [self.params enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger i, BOOL * _Nonnull stop) {
        UILabel *keyLabel = [UILabel new];
        keyLabel.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        keyLabel.font = [UIFont systemFontOfSize:13];
        keyLabel.text = [NSString stringWithFormat:@"%@: ",obj.firstObject];
        [self.containerView addSubview:keyLabel];
        [keyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.topLine.mas_bottom).offset(15 + i * 21);
            make.height.equalTo(@21);
            make.left.equalTo(self.containerView).offset(19);
         }];
        
        UILabel *valueLabel = [UILabel new];
        valueLabel.textColor = [UIColor grayColor];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.text = obj.lastObject;
        [self.containerView addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.containerView).offset(98);
            make.right.lessThanOrEqualTo(self.containerView).offset(-19);
            make.centerY.equalTo(keyLabel);
        }];
    }];
    UILabel *lastLabel = [self.containerView subviews].lastObject;
    if ([((NSArray*)self.params.firstObject).lastObject isEqualToString:@"电子发票"]) {
        UILabel *hintLabel = [UILabel new];
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.numberOfLines = 0;
        hintLabel.text = @"* 请核对邮箱, 发票将在开具后发送到您的邮箱, 请注意查收";
        [self.containerView addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lastLabel.mas_bottom).offset(15);
            make.left.equalTo(self.containerView).offset(19);
            make.right.equalTo(self.containerView).offset(-19);
        }];
    }
    lastLabel = [self.containerView subviews].lastObject;
    [self.containerView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lastLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@(0.5));
    }];
    [self.containerView addSubview:self.centerLine];
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(@(0.5));
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.bottom.equalTo(self.containerView);
    }];

    [self.containerView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.centerLine.mas_left);
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.height.equalTo(@50);
    }];

    [self.containerView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.containerView);
        make.left.equalTo(self.centerLine.mas_right);
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.containerView);
    }];
}
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIView *)centerLine {
    if (!_centerLine) {
        _centerLine = [UIView new];
        _centerLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _centerLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _bottomLine;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _topLine;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text  = @"发票信息确认";
        _titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.layer.cornerRadius = 3;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
- (UIButton *)backView {
    if (!_backView) {
        _backView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
        [_backView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backView;
}
@end
