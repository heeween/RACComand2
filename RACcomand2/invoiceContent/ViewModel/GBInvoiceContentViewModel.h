//
//  GBInvoiceContentViewModel.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/31.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GBInvoiceSourceView,
GBInvoiceContentView,
GBInvoiceAddressView,
GBInvoiceConfirmView,
GBSelectItem,
GBInputItem,
GBInvoiceEntity,
RACCommand,
RACSignal;

@interface GBInvoiceContentViewModel : NSObject
// 信号的输入
@property (nonatomic,strong) RACCommand *personalCmd;
@property (nonatomic,strong) RACCommand *companyCmd;
@property (nonatomic,strong) RACCommand *nonPaperCmd;
@property (nonatomic,strong) RACCommand *paperCmd;
@property (nonatomic,strong) RACCommand *nextCmd;
@property (nonatomic,strong) RACCommand *confirmCmd;

@property (nonatomic,strong) GBInvoiceEntity *invoice;
// 信号的输出
@property (nonatomic,strong) RACSignal *ownerSignal;
@property (nonatomic,strong) RACSignal *sourceSignal;
// 根据owner和source衍变的界面动画信号
@property (nonatomic,strong) RACSignal *animateSignal;

// 信号的输入
@property (nonatomic,strong) RACSignal *companyNameSignal;
@property (nonatomic,strong) RACSignal *taxNumberSignal;
@property (nonatomic,strong) RACSignal *remarkSignal;
@property (nonatomic,strong) RACSignal *receiverSignal;
@property (nonatomic,strong) RACSignal *phoneSignal;
@property (nonatomic,strong) RACSignal *regionSignal;
@property (nonatomic,strong) RACSignal *minAddressSignal;
@property (nonatomic,strong) RACSignal *emailSignal;
@property (nonatomic,strong) RACSignal *errorStringSignal;
@property (nonatomic,strong) NSArray *errorStrings;


@end
