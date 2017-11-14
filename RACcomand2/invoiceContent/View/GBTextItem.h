//
//  GBInvoiceNormalItemView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBTextItem : UIView
@property (nonatomic,strong) UILabel *contentLabel;
+(instancetype)normalItemViewTitle:(NSString *)title content:(NSString *)content;
- (void)hiddenBottomLine;
@end
