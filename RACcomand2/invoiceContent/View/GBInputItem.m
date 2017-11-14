//
//  GBInvoiceInputItemView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInputItem.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface GBInputItem()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomLine;
@end
@implementation GBInputItem

+(instancetype)inputItemViewTitle:(NSString *)title placeHolder:(NSString *)placeHolderStr{
    GBInputItem *view = [[GBInputItem alloc] init];
    [view setupUI];
    view.titleLabel.text = title;
    view.inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderStr attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    return view;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)setupUI {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputField];
    [self addSubview:self.bottomLine];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.right.greaterThanOrEqualTo(self.inputField.mas_left).offset(-10);
    }];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@(0.5));
    }];

}
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _inputField.font = [UIFont systemFontOfSize:14];
        _inputField.textAlignment = NSTextAlignmentRight;
        _inputField.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
    }
    return _inputField;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor =  [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _bottomLine;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor =  [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"抬头类型";
    }
    return _titleLabel;
}
@end

