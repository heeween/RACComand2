//
//  GBInvoiceDescView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBInvoiceEnum.h"
@class GBSelectItem,GBInputItem,GBTextItem;
@interface GBInvoiceContentView : UIView
@property (nonatomic,strong) GBSelectItem *ownerItemView;
@property (nonatomic,strong) GBInputItem *companyNameItemView;
@property (nonatomic,strong) GBInputItem *taxPayerIDItemView;
@property (nonatomic,strong) GBTextItem *contentItemView;
@property (nonatomic,strong) GBTextItem *priceItemView;
@property (nonatomic,strong) UITextField *markField;
@property (nonatomic,assign) Invoice_Owner type;
+(instancetype)contentViewWith:(Invoice_Owner)type;
@end
