//
//  GBInvoiceNameItemView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBInvoiceEnum.h"
@interface GBSelectItem : UIView
@property (nonatomic,strong) UIButton *personalButton;
@property (nonatomic,strong) UIButton *companyButton;
@property (nonatomic,assign) Invoice_Owner type;
+(instancetype)selectItemViewWith:(Invoice_Owner)type;
@end
