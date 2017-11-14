//
//  GBInvoiceInputItemView.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBInputItem : UIView
@property (nonatomic,strong) UITextField *inputField;

+(instancetype)inputItemViewTitle:(NSString *)title placeHolder:(NSString *)placeHolderStr;
@end
