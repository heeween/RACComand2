//
//  GBInvoiceEntity.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/11/3.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBInvoiceEnum.h"
/*
 * 要申请开发票的发票模型
 */
@interface GBInvoiceEntity : NSObject

@property (nonatomic,assign) Invoice_Source sourceType;
@property (nonatomic,assign) Invoice_Owner ownerType;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *taxNumber;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *receiver;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *minAddress;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *customerNo;    // 乘客编号
@property (nonatomic,strong) NSString *companyNo;     // 公司编号
@property (nonatomic,strong) NSString *price;
@property (nonatomic,assign) double billPrice;
@property (nonatomic,strong) NSString *orderList;     // 选中发票号

+ (instancetype)getFromDiskOrMemory;
- (NSDictionary *)postParame;
- (NSArray *)showParame;
- (void)save;
@end
