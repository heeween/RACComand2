//
//  GBInvoiceBottomView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/31.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBInvoiceEnum.h"
@interface GBInvoiceConfirmView : UIView
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,assign) Invoice_Source type;
+(instancetype)confirmViewWith:(Invoice_Source)type;
@end
