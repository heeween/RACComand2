# 知识点
* RACSignal与OC对象方法的绑定
* RACSignal与OC对象属性的绑定
* [RACSignal merge:], Merge操作的使用
* [RACSignal combineLatest: reduce:^id(){}], Combine和reduce操作的使用
* [RACSignal return:nil] 与[RACSignal empty], nil信号和空信号的区别

# 示例项目功能
* 点击电子发票 纸质发票 个人 公司四个按钮 界面作出变化
* 根据四种状态检查Textfiled内容是否输入错误
* 输入错误Toast弹出错误内容
* 输入正确Alert弹出确认信息

# 示例项目地址
github: https://github.com/heeween/RACComand2.git

[Reactivate用法示例1简书介绍](http://www.jianshu.com/p/4301ce6af1f4)

[Reactivate2用法示例2简书介绍](http://www.jianshu.com/p/cf34dedd76f6)

用到的城市选择器属于[Jonhory](http://www.jianshu.com/u/fd320d65dbd8)

![2017-11-14 13.58.33.gif](http://upload-images.jianshu.io/upload_images/661867-3e91f68506626532.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 构建电子发票 纸质发票 个人 公司四个按钮的RACCommand对象
```objc
// GBInvoiceContentViewModel.m中代码
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
```
# 在控制器中将RACCommand对象和按钮事件绑定
```objc
// GBInvoiceContentController.m 中代码
    self.contentView.ownerItemView.personalButton.rac_command = self.viewModel.personalCmd;
    self.contentView.ownerItemView.companyButton.rac_command = self.viewModel.companyCmd;
    self.sourceView.nonPaperButton.rac_command = self.viewModel.nonPaperCmd;
    self.sourceView.paperButton.rac_command = self.viewModel.paperCmd;
```
# 将上述四个command的包含的信号合并为source何owner两个信号
```objc
// GBInvoiceContentViewModel.m中代码
    RACSignal *personalSignal = [[self.personalCmd executionSignals] switchToLatest];
    RACSignal *companySignal = [[self.companyCmd executionSignals] switchToLatest];
    RACSignal *nonPaperSignal = [[self.nonPaperCmd executionSignals] switchToLatest];
    RACSignal *paperSignal = [[self.paperCmd executionSignals] switchToLatest];
    self.ownerSignal = [RACSignal merge:@[personalSignal,companySignal]];
    self.sourceSignal = [RACSignal merge:@[nonPaperSignal,paperSignal]];
```
# 分别将source和owner信号绑定对应的view上
```objc
// GBInvoiceContentController.m 中代码
    RAC(self.sourceView,type) = self.viewModel.sourceSignal;
    RAC(self.confirmView,type) = self.viewModel.sourceSignal;
    RAC(self.addressView,type) = self.viewModel.sourceSignal;
    RAC(self.contentView,type) = self.viewModel.ownerSignal;
```
# 将source和owner两个信号合并为动画信号
```objc
// GBInvoiceContentViewModel.m中代码
    self.animateSignal = [RACSignal merge:@[self.ownerSignal,self.sourceSignal]];
```
# 将动画信号绑定到控制器的动画方法
```objc
// GBInvoiceContentController.m 中代码
    [self rac_liftSelector:@selector(animatieUpdateSubview:) withSignals:self.viewModel.animateSignal, nil];

/** 动画子控件 */
- (void)animatieUpdateSubview:(id)obj {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
```
# 收集控制器中各输入框的信号,并且绑定到viewmode中发票对象的属性上
```objc
// GBInvoiceContentController.m 中代码
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
```
# 在viewmodel中根据source和owner信号,对各个输入框的信号进行merge和reduce操作,整合成错误字符串信号errorStringSignal
```objc
// GBInvoiceContentViewModel.m中代码
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
```
# 把errorStringSignal和errorstring属性
* 这步看似多次一举,实则是因为页面需求并不是每次有错误就弹出,而是在点击下一步的时候才弹出
* 因为先用errorstring属性保存错误值,点击下一步的通过subscriper发出
```objc
// GBInvoiceContentController.m 中代码
        RAC(self.viewModel,errorStrings) = self.viewModel.errorStringSignal;
```
# 创建下一步command,有错误senderror,没有sendcomplete
```objc
// GBInvoiceContentViewModel.m中代码
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
```
# 下一步command与下一步按钮绑定,并且绑定成功和失败信号到对应的控制器方法
```objc
// GBInvoiceContentController.m 中代码
        self.confirmView.confirmButton.rac_command = self.viewModel.nextCmd;

        [self rac_liftSelector:@selector(showAlert:) withSignals:[[self.viewModel.nextCmd executionSignals] switchToLatest], nil];
        [self rac_liftSelector:@selector(showError:) withSignals:self.viewModel.nextCmd.errors, nil];

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
```
# 创建comfirmCmd
```objc
// GBInvoiceContentViewModel.m中代码
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
```
# 最后一步绑定弹窗确定按钮和comfirmCmd,并且绑定成功和失败信号到对应的控制器方法
```objc
// GBInvoiceContentController.m 中代码
    // 绑定弹窗的成功和失败信号
    {
        [self rac_liftSelector:@selector(postParamSuccess:) withSignals:[[self.viewModel.confirmCmd executionSignals] switchToLatest], nil];
        [self rac_liftSelector:@selector(postParamFailure:) withSignals:self.viewModel.confirmCmd.errors, nil];
    }

/** 开票成功 */
- (void)postParamSuccess:(id)obj {
    [self.view makeToast:@"开票成功"];
}
/** 开票失败 */
- (void)postParamFailure:(id)obj {
    [self.view makeToast:@"开票失败"];
}
```

> 1,使用RACComand和RACSigna,可以很方便的拿到各自独立的事件或信号.
2, RAC有大量的信号操作,可以非常方便做业务逻辑.不管是信号合并信号转化都不需要蛋疼的中间变量.
3,RAC有吊炸天的绑定,更是方便了从结果到界面的one step.
