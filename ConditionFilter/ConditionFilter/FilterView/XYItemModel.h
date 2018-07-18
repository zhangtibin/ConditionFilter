//
//  XYItemModel.h
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYItemModel : NSObject

@property (nonatomic, copy) NSString *displayText;// 筛选条上显示的文字
@property (nonatomic, copy) NSString *currentID;// 当前筛选条的id;
@property (nonatomic, assign) BOOL seleceted;// 是否显示选中。
@property (nonatomic, strong) NSArray *dataSource;// 多级列表时，存储下一级的数据。

+ (instancetype) modelWithText:(NSString *)text currentID:(NSString *)currentID isSelect:(BOOL)select;

@end
