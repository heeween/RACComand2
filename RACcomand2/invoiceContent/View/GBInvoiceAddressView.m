//
//  GBInvoiceAddressView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceAddressView.h"
#import "GBInputItem.h"
#import "AddressPickerView.h"
#import <Masonry.h>
@interface GBInvoiceAddressView() <UITextFieldDelegate,AddressPickerViewDelegate>
@property (nonatomic,strong) UILabel *headerTitleLabel;
@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) MASConstraint *mailBottomConstraint;
@property (nonatomic,strong) MASConstraint *addressDescConstraint;

@end
@implementation GBInvoiceAddressView

+(instancetype)addressViewWith:(Invoice_Source)type{
    GBInvoiceAddressView *view = [[GBInvoiceAddressView alloc] init];
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
            [self.mailBottomConstraint install];
            [self.addressDescConstraint uninstall];
            self.contactAddressItemView.alpha = 0;
            self.contactAddressDescItemView.alpha = 0;
            self.contactMailItemView.alpha = 1;
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make){
                make.bottom.equalTo(self);
            }];

        }
            break;
        case Invoice_Source_Paper:
        {
            [self.mailBottomConstraint uninstall];
            [self.addressDescConstraint install];
            self.contactAddressItemView.alpha = 1;
            self.contactAddressDescItemView.alpha =1;
            self.contactMailItemView.alpha = 0;
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make){
                make.bottom.equalTo(self).offset(-30);
            }];
        }
        default:
            break;
    }
    [super updateConstraints];
}
    
- (void)setType:(Invoice_Source)type {
    _type = type;
    [self setNeedsUpdateConstraints];
}
- (void)selectProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    self.contactAddressItemView.inputField.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.contactNameItemView.inputField isFirstResponder]) {
        [self.contactNameItemView.inputField resignFirstResponder];
        [self.contactPhoneItemView.inputField becomeFirstResponder];
    }else if ([self.contactPhoneItemView.inputField isFirstResponder]){
        [self.contactPhoneItemView.inputField resignFirstResponder];
        if (self.type == Invoice_Source_NonPaper) {
            [self.contactAddressItemView.inputField becomeFirstResponder];
        }else {
            [self.contactMailItemView.inputField becomeFirstResponder];
        }
    }else if ([self.contactAddressItemView.inputField isFirstResponder]) {
        [self.contactAddressItemView.inputField resignFirstResponder];
        [self.contactAddressDescItemView.inputField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0 ){return YES;}
    if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)setupUI {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.headerTitleLabel];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contactNameItemView];
    [self.containerView addSubview:self.contactPhoneItemView];
    [self.containerView addSubview:self.contactMailItemView];
    [self.containerView addSubview:self.contactAddressItemView];
    [self.containerView addSubview:self.contactAddressDescItemView];
    // 收件信息
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
    [self.contactNameItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    [self.contactPhoneItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contactNameItemView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@50);
    }];
    [self.contactMailItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.contactPhoneItemView.mas_bottom);
        make.height.equalTo(@50);
        self.mailBottomConstraint = make.bottom.equalTo(self.containerView);
    }];
    [self.contactAddressItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.contactPhoneItemView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.contactAddressDescItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.contactAddressItemView.mas_bottom);
        make.height.equalTo(@50);
        self.addressDescConstraint = make.bottom.equalTo(self.containerView);
    }];
    [self.mailBottomConstraint uninstall];
    [self.addressDescConstraint uninstall];
}
- (GBInputItem *)contactNameItemView {
    if (!_contactNameItemView) {
        _contactNameItemView = [GBInputItem inputItemViewTitle:@"联系人" placeHolder:@"请输入联系人姓名"];
        _contactNameItemView.inputField.returnKeyType = UIReturnKeyNext;
        _contactNameItemView.inputField.delegate = self;
        _contactNameItemView.inputField.text = @"贺彦文";
    }
    return _contactNameItemView;
}
- (GBInputItem *)contactPhoneItemView {
    if (!_contactPhoneItemView) {
        _contactPhoneItemView = [GBInputItem inputItemViewTitle:@"电话" placeHolder:@"请输入联系电话"];
        _contactPhoneItemView.inputField.returnKeyType = UIReturnKeyNext;
        _contactPhoneItemView.inputField.delegate = self;
        _contactPhoneItemView.inputField.keyboardType = UIKeyboardTypeNumberPad;
        _contactPhoneItemView.inputField.text = @"12348";
    }
    return _contactPhoneItemView;
}
- (GBInputItem *)contactMailItemView {
    if (!_contactMailItemView) {
        _contactMailItemView = [GBInputItem inputItemViewTitle:@"邮箱" placeHolder:@"请输入收件人电子邮箱"];
        _contactMailItemView.inputField.returnKeyType = UIReturnKeyDone;
        _contactMailItemView.inputField.keyboardType = UIKeyboardTypeEmailAddress;
        _contactMailItemView.inputField.text = @"askdjf";
    }
    return _contactMailItemView;
}
- (GBInputItem *)contactAddressItemView {
    if (!_contactAddressItemView) {
        _contactAddressItemView = [GBInputItem inputItemViewTitle:@"地址" placeHolder:@"请输入地址"];
        _contactAddressItemView.inputField.returnKeyType = UIReturnKeyNext;
        _contactAddressItemView.inputField.delegate = self;
        AddressPickerView *pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height ,  [UIScreen mainScreen].bounds.size.width, 165)];
        _contactAddressItemView.inputField.inputView = pickerView;
        pickerView.delegate = self;
    }
    return _contactAddressItemView;
}
- (GBInputItem *)contactAddressDescItemView {
    if (!_contactAddressDescItemView) {
        _contactAddressDescItemView = [GBInputItem inputItemViewTitle:@"详细地址" placeHolder:@"请填写详细地址"];
        _contactAddressDescItemView.inputField.returnKeyType = UIReturnKeyDone;
    }
    return _contactAddressDescItemView;
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
        _headerTitleLabel.text = @"收件信息";
    }
    return _headerTitleLabel;
}


@end
