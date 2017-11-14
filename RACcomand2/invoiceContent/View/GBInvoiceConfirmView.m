//
//  GBInvoiceBottomView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/31.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceConfirmView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
@interface GBInvoiceConfirmView()
@property (nonatomic,strong) UILabel *paperHintLabel;
@property (nonatomic,strong) CAGradientLayer *paperHintBackLayer;
@end
@implementation GBInvoiceConfirmView
+(instancetype)confirmViewWith:(Invoice_Source)type {
    GBInvoiceConfirmView *view = [[GBInvoiceConfirmView alloc] init];
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
            [UIView animateWithDuration:0.3 animations:^{
                self.paperHintLabel.alpha = 0;
                self.paperHintBackLayer.frame = CGRectMake(0, -8, [UIScreen mainScreen].bounds.size.width, 8);
                self.paperHintBackLayer.locations = @[@0,@0.5,@1];
            }];
        }
            break;
        case Invoice_Source_Paper:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.paperHintLabel.alpha = 1;
                self.paperHintBackLayer.frame = CGRectMake(0, -45, [UIScreen mainScreen].bounds.size.width, 45);
                self.paperHintBackLayer.locations = @[@0,@0.3,@1];
            }];
        }
            break;
        default:
            break;
    }
    [super updateConstraints];
}
- (void)setType:(Invoice_Source)type {
    _type = type;
    [self setNeedsUpdateConstraints];
}
- (void)setupUI {
    [self addSubview:self.confirmButton];
    [self addSubview:self.paperHintLabel];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@65);
    }];
    
    [self.paperHintLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.height.equalTo(@45);
    }];
    [self.confirmButton.layer addSublayer:self.paperHintBackLayer];
}
- (CAGradientLayer *)paperHintBackLayer {
    if (!_paperHintBackLayer) {
        _paperHintBackLayer = [CAGradientLayer layer];
        _paperHintBackLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:0].CGColor,(id)[UIColor colorWithWhite:1 alpha:1].CGColor];
        _paperHintBackLayer.locations = @[@0,@0.3,@1];
        _paperHintBackLayer.zPosition = -1;
    }
    return _paperHintBackLayer;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateDisabled];
        _confirmButton.backgroundColor = [UIColor colorWithRed:17/255.0 green:144/255.0 blue:101/255.0 alpha:1];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _confirmButton;
}
- (UILabel *)paperHintLabel {
    if (!_paperHintLabel) {
        _paperHintLabel = [UILabel new];
        _paperHintLabel.textColor = [UIColor lightGrayColor];
        _paperHintLabel.textAlignment = NSTextAlignmentCenter;
        _paperHintLabel.font = [UIFont systemFontOfSize:12];
        _paperHintLabel.text = @"纸质发票满200元免邮, 未满200元到付";
    }
    return _paperHintLabel;
}
@end
