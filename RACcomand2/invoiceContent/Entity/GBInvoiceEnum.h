//
//  Header.h
//  GreenBusiness
//
//  Created by 贺彦文 on 2017/10/31.
//  Copyright © 2017年 UXing. All rights reserved.
//

#ifndef Header_h
#define Header_h

// 发票主体
typedef NS_ENUM(NSInteger, Invoice_Owner)  {
    Invoice_Owner_Company = 1, // 公司
    Invoice_Owner_Personal = 2 // 个人
};

// 发票材质
typedef NS_ENUM(NSInteger, Invoice_Source)  {
    Invoice_Source_Paper = 1, // 纸质
    Invoice_Source_NonPaper = 2 // 电子
};

#endif /* Header_h */
