//
//  GBInvoiceAlert.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/11/1.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBInvoiceAlert : UIView
@property (nonatomic,strong) UIButton       *confirmBtn;
+ (instancetype)showWith:(NSArray *)params confirmBlock:(void(^)())confirmBlock;
@end
