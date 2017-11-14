//
//  GBInvoiceAddressView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBInvoiceEnum.h"
@class GBInputItem;
@interface GBInvoiceAddressView : UIView
@property (nonatomic,assign) Invoice_Source type;

@property (nonatomic,strong) GBInputItem *contactNameItemView;
@property (nonatomic,strong) GBInputItem *contactPhoneItemView;
@property (nonatomic,strong) GBInputItem *contactMailItemView;
@property (nonatomic,strong) GBInputItem *contactAddressItemView;
@property (nonatomic,strong) GBInputItem *contactAddressDescItemView;
+(instancetype)addressViewWith:(Invoice_Source)type;
@end
