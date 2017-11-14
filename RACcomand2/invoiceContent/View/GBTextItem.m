//
//  GBInvoiceNormalItemView.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBTextItem.h"
#import <Masonry.h>
@interface GBTextItem()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomLine;
@end
@implementation GBTextItem

+(instancetype)normalItemViewTitle:(NSString *)title content:(NSString *)content {
    
    GBTextItem *view = [[GBTextItem alloc] init];
    [view setupUI];
    view.titleLabel.text = title;
    view.contentLabel.text = content;
    return view;
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.bottomLine];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@(0.5));
    }];

}
- (void)hiddenBottomLine {
    self.bottomLine.hidden = YES;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"内容";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = @"详细内容";
    }
    return _contentLabel;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
    return _bottomLine;
}
@end
