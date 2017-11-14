//
//  GBInvoiceContentViewModel.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/31.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceContentViewModel.h"
#import "GBInvoiceSourceView.h"
#import "GBInvoiceContentView.h"
#import "GBInvoiceAddressView.h"
#import "GBInvoiceConfirmView.h"
#import "GBSelectItem.h"
#import "GBInputItem.h"
#import "GBInvoiceEnum.h"
#import "GBInvoiceEntity.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface NSString(invoice)
- (BOOL)isTaxNumber;
- (BOOL)isEmail;
@end


@interface GBInvoiceContentViewModel ()
@end
@implementation GBInvoiceContentViewModel
- (instancetype)init {
    if (self = [super init]) {
        [self setupCmd];
        
    }
    return self;
}

- (void)setupCmd {
    self.personalCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@(Invoice_Owner_Personal)];
    }];
    self.companyCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@(Invoice_Owner_Company)];
    }];
    self.nonPaperCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@(Invoice_Source_NonPaper)];
    }];
    self.paperCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@(Invoice_Source_Paper)];
    }];
    RACSignal *personalSignal = [[self.personalCmd executionSignals] switchToLatest];
    RACSignal *companySignal = [[self.companyCmd executionSignals] switchToLatest];
    RACSignal *nonPaperSignal = [[self.nonPaperCmd executionSignals] switchToLatest];
    RACSignal *paperSignal = [[self.paperCmd executionSignals] switchToLatest];
    self.ownerSignal = [RACSignal merge:@[personalSignal,companySignal]];
    self.sourceSignal = [RACSignal merge:@[nonPaperSignal,paperSignal]];
    self.animateSignal = [RACSignal merge:@[self.ownerSignal,self.sourceSignal]];
    RAC(self.invoice,sourceType) = self.sourceSignal;
    RAC(self.invoice,ownerType) = self.ownerSignal;
}


- (RACCommand *)confirmCmd {
    if (!_confirmCmd) {
        _confirmCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                if (arc4random() % 2 == 0) {
                    [subscriber sendNext:@"开票成功"];
                    [subscriber sendCompleted];
                }else {
                    NSError *error = [NSError errorWithDomain:@"开票失败" code:00 userInfo:nil];
                    [subscriber sendError:error];
                }
                return nil;
            }];
        }];
    }
    return _confirmCmd;
}
- (RACCommand *)nextCmd {
    if (!_nextCmd) {
        @weakify(self);
        _nextCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if (self.errorStrings == nil || self.errorStrings.count <= 0) {
                    [subscriber sendNext:[self.invoice showParame]];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendError:[NSError errorWithDomain:@"输入有误" code:0 userInfo:@{@"errorStrings":self.errorStrings}]];
                }
                return nil;
            }];
        }];
    }
    return _nextCmd;
}
- (RACSignal *)errorStringSignal {
    if (!_errorStringSignal) {
        RACSignal *companyNameError = [self.companyNameSignal map:^id(NSString *value) {
            if (value.length <= 0) {
                return @"公司名称不能为空";
            }else {
                return @"";
            }
        }];
        RACSignal *taxNumberError = [self.taxNumberSignal map:^id(NSString *value) {
            if (value.length <= 0) {
                return @"纳税人识别号不能为空";
            }else if (![value isTaxNumber]) {
                return @"纳税人识别号输入不正确";
            }else {
                return @"";
            }
        }];
        RACSignal *receiverError = [self.receiverSignal map:^id(NSString *value) {
            return value.length > 0 ? @"" : @"联系人不能为空";
        }];
        RACSignal *phoneError = [self.phoneSignal map:^id(NSString *value) {
            if (value.length <= 0) {
                return @"电话不能为空";
            }else if (value.length != 11) {
                return @"电话输入不正确";
            }else {
                return @"";
            }
        }];
        RACSignal *regionError = [self.regionSignal map:^id(NSString *value) {
            return value.length > 0 ? @"" : @"地址不能为空";
        }];
        RACSignal *minaddressError = [self.minAddressSignal map:^id(NSString *value) {
            return value.length > 0 ? @"" : @"详细地址不能为空";
        }];
        RACSignal *emailError = [self.emailSignal map:^id(NSString *value) {
            if (value.length <= 0) {
                return @"邮箱不能为空";
            }else if (![value isEmail]) {
                return @"邮箱输入不正确";
            }else {
                return @"";
            }
        }];
        
        
        NSDictionary *sourceDict =
        @{
          @(Invoice_Source_Paper):
              [RACSignal combineLatest:@[receiverError,phoneError,regionError,minaddressError] reduce:^id(NSString *receiver, NSString *phone,NSString *region,NSString *minaddress){
                  NSMutableArray *array = [NSMutableArray array];
                  if (receiver.length > 0) { [array addObject:receiver]; }
                  if (phone.length > 0) { [array addObject:phone]; }
                  if (region.length > 0) { [array addObject:region]; }
                  if (minaddress.length > 0) { [array addObject:minaddress]; }
                  return array;
              }],
          @(Invoice_Source_NonPaper):
              [RACSignal combineLatest:@[receiverError,phoneError,emailError] reduce:^id(NSString *receiver, NSString *phone,NSString *email){
                  NSMutableArray *array = [NSMutableArray array];
                  if (receiver.length > 0) { [array addObject:receiver]; }
                  if (phone.length > 0) { [array addObject:phone]; }
                  if (email.length > 0) { [array addObject:email]; }
                  return array;
              }]
          };
        RACSignal *sourceError = [RACSignal switch:self.sourceSignal cases:sourceDict default:nil];
        NSDictionary *ownerDict =
        @{
          @(Invoice_Owner_Personal): [RACSignal return:nil],
          @(Invoice_Owner_Company):
              [RACSignal combineLatest:@[companyNameError,taxNumberError] reduce:^id(NSString *companyName, NSString *taxNumber){
                  NSMutableArray *array = [NSMutableArray array];
                  if (companyName.length > 0) { [array addObject:companyName]; }
                  if (taxNumber.length > 0) { [array addObject:taxNumber]; }
                  return array;
              }]
          };
        RACSignal *ownerError = [RACSignal switch:self.ownerSignal cases:ownerDict default:nil];
        _errorStringSignal = [RACSignal combineLatest:@[sourceError,ownerError] reduce:^id(NSArray *sourceArray, NSArray *ownerArray){
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:sourceArray];
            [array addObjectsFromArray:ownerArray];
            return array;
        }];
    }
    return _errorStringSignal;
}

- (GBInvoiceEntity *)invoice {
    if (!_invoice) {
        _invoice = [GBInvoiceEntity getFromDiskOrMemory];
    }
    return _invoice;
}

- (void)dealloc {
    NSLog(@"GBInvoiceContentViewModel销毁了");
}
@end

@implementation NSString(invoice)
#pragma mark - 是否为合法纳税人识别号
- (BOOL)isTaxNumber {
    //    NSString *regex = @"^((\\d{6}[0-9A-Z]{9})|([0-9A-Za-z]{2}\\d{6}[0-9A-Za-z]{10}))$";
    NSString *regex = @"^[0-9A-Za-z]{15,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject: self]) {
        return NO;
    }
    return YES;
}
- (BOOL)isPureNumber {
    NSString *regex = @"^(\\d{n})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject: self]) {
        return NO;
    }
    return YES;
}
#pragma mark - 是否为合法E-mail地址
- (BOOL)isEmail {
    NSString *regex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject: self]) {
        return NO;
    }
    return YES;
}
@end
