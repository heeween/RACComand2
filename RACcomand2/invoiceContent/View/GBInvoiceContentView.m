//
//  GBInvoiceDescView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceContentView.h"
#import "GBSelectItem.h"
#import "GBTextItem.h"
#import "GBInputItem.h"
#import <Masonry.h>
@interface GBInvoiceContentView() <UITextFieldDelegate>
@property (nonatomic,strong) UILabel *headerTitleLabel;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) MASConstraint *contentToOwnerItemConstraint;
@property (nonatomic,strong) MASConstraint *contentToTaxPayerItemConstraint;
@end
@implementation GBInvoiceContentView

+(instancetype)contentViewWith:(Invoice_Owner)type {
    GBInvoiceContentView *view = [[GBInvoiceContentView alloc] init];
    [view setupUI];
    view.type = type;
    return view;
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    
    switch (self.type) {
        case Invoice_Owner_Personal:
        {
            [self.contentToOwnerItemConstraint activate];
            [self.contentToTaxPayerItemConstraint deactivate];
            [UIView animateWithDuration:0.3 animations:^{
                self.companyNameItemView.alpha = 0;
                self.taxPayerIDItemView.alpha = 0;
            }];
        }
            break;
        case Invoice_Owner_Company:
        {
            [self.contentToOwnerItemConstraint deactivate];
            [self.contentToTaxPayerItemConstraint activate];
            [UIView animateWithDuration:0.3 animations:^{
                self.companyNameItemView.alpha = 1;
                self.taxPayerIDItemView.alpha = 1;
            }];
        }
            break;
        default:
            break;
    }
    [super updateConstraints];
}
-(void)setType:(Invoice_Owner)type {
    _type = type;
    self.ownerItemView.type = type;
    [self setNeedsUpdateConstraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.markField) {
        if (textField.text.length >= 64 && ![string isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }else {
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) {
            return NO;
        }else{
            char commitChar = [string characterAtIndex:0];
            if (commitChar > 96 && commitChar < 123){
                NSString * uppercaseString = string.uppercaseString;
                NSString * str1 = [textField.text substringToIndex:range.location];
                NSString * str2 = [textField.text substringFromIndex:range.location];
                textField.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
                return NO;
            }else {    
                return YES;
            }
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.taxPayerIDItemView.inputField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}
- (void)setupUI {
    [self addSubview:self.headerTitleLabel];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.ownerItemView];
    [self.containerView addSubview:self.companyNameItemView];
    [self.containerView addSubview:self.taxPayerIDItemView];
    [self.containerView addSubview:self.contentItemView];
    [self.containerView addSubview:self.priceItemView];
    [self.containerView addSubview:self.markField];
    // 发票详情
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(12);
        make.height.equalTo(@32);
        make.top.equalTo(self);
    }];
    // 白色容器view
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.headerTitleLabel.mas_bottom);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
    }];
    // 抬头类型
    [self.ownerItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    // 公司名称
    [self.companyNameItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.ownerItemView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];

    // 纳税人识别号
    [self.taxPayerIDItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.companyNameItemView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    // 发票内容
    [self.contentItemView mas_makeConstraints:^(MASConstraintMaker *make){
        self.contentToOwnerItemConstraint = make.top.equalTo(self.ownerItemView.mas_bottom);
        self.contentToTaxPayerItemConstraint = make.top.equalTo(self.taxPayerIDItemView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    [self.contentToOwnerItemConstraint uninstall];
    [self.contentToTaxPayerItemConstraint uninstall];
    // 开票金额
    [self.priceItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentItemView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    // 备注
    [self.markField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.priceItemView.mas_bottom).offset(15);
        make.left.equalTo(self.containerView).offset(15);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.containerView).offset(-15);
        make.height.equalTo(@36);
    }];
}
- (GBInputItem *)taxPayerIDItemView {
    if (!_taxPayerIDItemView) {
        _taxPayerIDItemView = [GBInputItem inputItemViewTitle:@"纳税人识别号" placeHolder:@"请填写纳税人识别号"];
        _taxPayerIDItemView.inputField.delegate = self;
        _taxPayerIDItemView.inputField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _taxPayerIDItemView;
}
- (GBInputItem *)companyNameItemView {
    if (!_companyNameItemView) {
        _companyNameItemView = [GBInputItem inputItemViewTitle:@"抬头名称" placeHolder:@"请输入单位名称"];
    }
    return _companyNameItemView;
}
- (GBTextItem *)priceItemView {
    if (!_priceItemView) {
        _priceItemView = [GBTextItem normalItemViewTitle:@"开票金额" content:@"25.00元"];
    }
    return _priceItemView;
}
- (GBTextItem *)contentItemView {
    if (!_contentItemView) {
        _contentItemView = [GBTextItem normalItemViewTitle:@"发票内容" content:@"客运服务费"];
    }
    return _contentItemView;
}
- (GBSelectItem *)ownerItemView {
    if (!_ownerItemView) {
        _ownerItemView = [GBSelectItem selectItemViewWith:Invoice_Owner_Personal];
    }
    return _ownerItemView;
}
- (UITextField *)markField {
    if (!_markField) {
        _markField = [[UITextField alloc] init];
        _markField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _markField.leftViewMode = UITextFieldViewModeAlways;
        _markField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备注" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _markField.font = [UIFont systemFontOfSize:12];
        _markField.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        _markField.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        _markField.delegate = self;
    }
    return _markField;
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
        _headerTitleLabel.text = @"发票详情";
    }
    return _headerTitleLabel;
}
@end
