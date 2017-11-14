//
//  GBInvoiceTypeView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBInvoiceEnum.h"
@interface GBInvoiceSourceView : UIView
@property (nonatomic,assign) Invoice_Source type;
@property (nonatomic,strong) UIButton *nonPaperButton;
@property (nonatomic,strong) UIButton *paperButton;
+(instancetype)sourceViewWith:(Invoice_Source)type;
@end
