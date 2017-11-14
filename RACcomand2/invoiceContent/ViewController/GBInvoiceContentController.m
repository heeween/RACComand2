//
//  GBInvoiceContentController.m
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/30.
//  Copyright © 2017年 UXing. All rights reserved.
//

#import "GBInvoiceContentController.h"
#import "GBInvoiceContentViewModel.h"
#import "GBInvoiceSourceView.h"
#import "GBInvoiceContentView.h"
#import "GBInvoiceAddressView.h"
#import "GBInvoiceConfirmView.h"
#import "GBSelectItem.h"
#import "GBInputItem.h"
#import "GBTextItem.h"
#import <IQKeyboardManager.h>
#import "GBInvoiceAlert.h"
#import <Toast/UIView+Toast.h>
#import "GBInvoiceAlert.h"
#import "GBInvoiceEnum.h"
#import "GBInvoiceEntity.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface GBInvoiceContentController () <UIScrollViewDelegate>
@property (nonatomic,strong) GBInvoiceContentViewModel *viewModel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) GBInvoiceSourceView *sourceView;
@property (nonatomic,strong) GBInvoiceContentView *contentView;
@property (nonatomic,strong) GBInvoiceAddressView *addressView;
@property (nonatomic,strong) GBInvoiceConfirmView *confirmView;
@end

@implementation GBInvoiceContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曹操开票";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];;
    [self addSubView];
    [self setSubView];
    [self bindViewModel];
    
}


#pragma mark - Private Method
/** 给视图赋值 */
- (void)setSubView {
    self.viewModel.invoice.billPrice = 112.00;
    self.contentView.priceItemView.contentLabel.text = self.viewModel.invoice.price;
    self.addressView.contactNameItemView.inputField.text = self.viewModel.invoice.receiver;
    self.addressView.contactPhoneItemView.inputField.text = self.viewModel.invoice.phone;
    self.addressView.contactMailItemView.inputField.text = self.viewModel.invoice.email;
}
/** 视图数据绑定 */
- (void)bindViewModel {
    
    self.contentView.ownerItemView.personalButton.rac_command = self.viewModel.personalCmd;
    self.contentView.ownerItemView.companyButton.rac_command = self.viewModel.companyCmd;
    self.sourceView.nonPaperButton.rac_command = self.viewModel.nonPaperCmd;
    self.sourceView.paperButton.rac_command = self.viewModel.paperCmd;
    RAC(self.sourceView,type) = self.viewModel.sourceSignal;
    RAC(self.confirmView,type) = self.viewModel.sourceSignal;
    RAC(self.addressView,type) = self.viewModel.sourceSignal;
    RAC(self.contentView,type) = self.viewModel.ownerSignal;
    [self rac_liftSelector:@selector(animatieUpdateSubview:) withSignals:self.viewModel.animateSignal, nil];
    
    // 输入框的信号输入到viewmodel中
    {
        self.viewModel.companyNameSignal = self.contentView.companyNameItemView.inputField.rac_textSignal;
        self.viewModel.taxNumberSignal = self.contentView.taxPayerIDItemView.inputField.rac_textSignal;
        self.viewModel.remarkSignal = self.contentView.markField.rac_textSignal;
        self.viewModel.receiverSignal = self.addressView.contactNameItemView.inputField.rac_textSignal;
        self.viewModel.phoneSignal = self.addressView.contactPhoneItemView.inputField.rac_textSignal;
        self.viewModel.regionSignal = self.addressView.contactAddressItemView.inputField.rac_textSignal;
        self.viewModel.minAddressSignal = self.addressView.contactAddressDescItemView.inputField.rac_textSignal;
        self.viewModel.emailSignal = self.addressView.contactMailItemView.inputField.rac_textSignal;
        RAC(self.viewModel.invoice,companyName) = self.viewModel.companyNameSignal;
        RAC(self.viewModel.invoice,taxNumber) = self.viewModel.taxNumberSignal;
        RAC(self.viewModel.invoice,receiver) = self.viewModel.receiverSignal;
        RAC(self.viewModel.invoice,region) = self.viewModel.regionSignal;
        RAC(self.viewModel.invoice,minAddress) = self.viewModel.minAddressSignal;
        RAC(self.viewModel.invoice,email) = self.viewModel.emailSignal;
    }
    // 下一步按钮 以及弹窗的确认按钮 和viewmodel绑定
    {
        RAC(self.viewModel,errorStrings) = self.viewModel.errorStringSignal;
    }
    // 根据响应事件信号值合并转为控制器操作信号 并且直接绑定到控制器的对象方法
    {
        self.confirmView.confirmButton.rac_command = self.viewModel.nextCmd;
        [self rac_liftSelector:@selector(showAlert:) withSignals:[[self.viewModel.nextCmd executionSignals] switchToLatest], nil];
        [self rac_liftSelector:@selector(showError:) withSignals:self.viewModel.nextCmd.errors, nil];
    }
    // 绑定弹窗的成功和失败信号
    {
        [self rac_liftSelector:@selector(postParamSuccess:) withSignals:[[self.viewModel.confirmCmd executionSignals] switchToLatest], nil];
        [self rac_liftSelector:@selector(postParamFailure:) withSignals:self.viewModel.confirmCmd.errors, nil];
    }
    [self.viewModel.companyCmd execute:nil];
    [self.viewModel.nonPaperCmd execute:nil];
}



#pragma mark - Target Mehtods
/** 动画子控件 */
- (void)animatieUpdateSubview:(id)obj {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
/** 输入错误提醒 */
- (void)showError:(NSError *)error {
    NSArray *errorStrings = error.userInfo[@"errorStrings"];
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [self.view makeToast:[errorStrings componentsJoinedByString:@"  |  "]];
}
/** 输入成功弹窗 */
- (void)showAlert:(id)obj {
    GBInvoiceAlert *alertView = [GBInvoiceAlert showWith:obj confirmBlock:nil];
    alertView.confirmBtn.rac_command = self.viewModel.confirmCmd;
}
/** 开票成功 */
- (void)postParamSuccess:(id)obj {
    [self.view makeToast:@"开票成功"];
}
/** 开票失败 */
- (void)postParamFailure:(id)obj {
    [self.view makeToast:@"开票失败"];
}

#pragma mark - SuperClass Method
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}


/** 视图初始化 */
- (void)addSubView {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view).insets(UIEdgeInsetsFromString(@"{64,0,0,0}"));
    }];
    
    [self.scrollView addSubview:self.sourceView];
    [self.sourceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.scrollView);
        make.width.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.scrollView);
        make.top.equalTo(self.sourceView.mas_bottom);
    }];
    [self.scrollView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.scrollView);
        make.top.equalTo(self.contentView.mas_bottom);
        make.bottom.equalTo(self.scrollView).offset(-110);
    }];
    [self.view addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Other Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}
#pragma mark - Lazy load
- (GBInvoiceContentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [GBInvoiceContentViewModel new];
    }
    return _viewModel;
}
- (GBInvoiceConfirmView *)confirmView {
    if (!_confirmView) {
        _confirmView = [GBInvoiceConfirmView confirmViewWith:Invoice_Source_NonPaper];
    }
    return _confirmView;
}
- (GBInvoiceAddressView *)addressView {
    if (!_addressView) {
        _addressView = [GBInvoiceAddressView addressViewWith:Invoice_Source_NonPaper];
    }
    return _addressView;
}
- (GBInvoiceContentView *)contentView {
    if (!_contentView) {
        _contentView = [GBInvoiceContentView contentViewWith:Invoice_Owner_Company];
    }
    return _contentView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (GBInvoiceSourceView *)sourceView {
    if (!_sourceView) {
        _sourceView = [GBInvoiceSourceView sourceViewWith:Invoice_Source_NonPaper];
    }
    return _sourceView;
}

- (void)dealloc {
    NSLog(@"GBInvoiceContentController销毁了");
}
@end
