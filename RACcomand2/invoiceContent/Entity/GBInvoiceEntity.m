//
//  GBInvoiceEntity.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/11/3.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceEntity.h"
//#import "GBUserInfo.h"
@interface GBInvoiceEntity() <NSCoding>
@end
@implementation GBInvoiceEntity
+ (instancetype)getFromDiskOrMemory {
    GBInvoiceEntity *invoice = [GBInvoiceEntity getFromDisk];
    if (!invoice) {
        invoice = [GBInvoiceEntity getFromMemory];
    }
    invoice.companyNo = [self companyId];
    invoice.customerNo = [self customerId];
    invoice.content = @"客运服务费";
    invoice.sourceType = Invoice_Source_NonPaper;
    invoice.ownerType = Invoice_Owner_Company;
    return invoice;
}
+ (instancetype)getFromMemory {
    GBInvoiceEntity *entity = [GBInvoiceEntity new];
    entity.phone = @"18329112605";
    entity.receiver = @"贺彦文";
    entity.email = @"heyanwen20009@hotmail.com";
    entity.companyName = @"杭州优行科技有限公司";
    entity.content = @"客运服务费";
    entity.sourceType = Invoice_Source_NonPaper;
    entity.ownerType = Invoice_Owner_Company;
    return entity;
}
- (void)setBillPrice:(double)billPrice {
    _billPrice = billPrice;
    self.price =  [NSString stringWithFormat:@"%.2f元", billPrice / 100.f];
}
static NSString *whloePath;
+ (instancetype)getFromDisk {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *cacheDirectory =[paths objectAtIndex:0];
    NSString *invoiceDirectory = @"/invoice/";
    NSString *whloeDirectory = [NSString stringWithFormat:@"%@%@",cacheDirectory,invoiceDirectory];
    [self createDirectory:whloeDirectory];
    whloePath = [NSString stringWithFormat:@"%@%@",whloeDirectory,@"infoice.cc"];
    [self createPath:whloePath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile: whloePath];
}
+ (void)createDirectory:(NSString *)directory {
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        return;
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:directory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}
+ (void)createPath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        return;
    }
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.receiver forKey:@"receiver"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.minAddress forKey:@"minAddress"];
    [aCoder encodeObject:self.region forKey:@"region"];
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.taxNumber forKey:@"taxNumber"];
    [aCoder encodeObject:self.content forKey:@"content"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.receiver = [aDecoder decodeObjectForKey:@"receiver"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.minAddress = [aDecoder decodeObjectForKey:@"minAddress"];
        self.region = [aDecoder decodeObjectForKey:@"region"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.taxNumber = [aDecoder decodeObjectForKey:@"taxNumber"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    return self;
}
- (void)save {
    [NSKeyedArchiver archiveRootObject:self toFile:whloePath];
}

- (NSArray *)showParame {
    
    NSMutableArray *parames = [NSMutableArray array];
    
    switch (self.sourceType) {
        case Invoice_Source_Paper: [parames addObject:@[@"发票类型",@"纸质发票"]]; break;
        case Invoice_Source_NonPaper: [parames addObject:@[@"发票类型",@"电子发票"]]; break;
        default: break;
    }
    switch (self.ownerType) {
        case Invoice_Owner_Personal: [parames addObject:@[@"发票抬头",@"个人"]]; break;
        case Invoice_Owner_Company: [parames addObject:@[@"发票抬头",@"公司"]]; break;
        default: break;
    }
    switch (self.ownerType) {
        case Invoice_Owner_Personal:
        {
        }
            break;
        case Invoice_Owner_Company:
        {
            [parames addObject:@[@"纳税人识别号",self.taxNumber]];
        }
        default:
            break;
    }
    switch (self.sourceType) {
        case Invoice_Source_Paper:
        {
            [parames addObject:@[@"收件人",self.receiver]];
            [parames addObject:@[@"收件人电话",self.phone]];
            NSString *address = [NSString stringWithFormat:@"%@%@",self.region, self.minAddress];
            [parames addObject:@[@"收件人地址",address]];
        }
            break;
        case Invoice_Source_NonPaper:
        {
            [parames addObject:@[@"收件人邮箱",self.email]];
        }
        default:
            break;
    }
    return parames;
}
#pragma mark - Getter
+ (NSString *)customerId {
    return @"270858";
    //    return [NSString stringWithFormat:@"%lld", [GBUserInfo sharedUserInfo].user.userId];
}
+ (NSString *)companyId {
    return @"19";
    //    return [[[GBUserInfo sharedUserInfo].user.companyList objectAtSafeIndex:0] safeObjectForKey:@"id"];
}
@end
