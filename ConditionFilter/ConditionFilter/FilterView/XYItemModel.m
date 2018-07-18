//
//  XYItemModel.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYItemModel.h"

@implementation XYItemModel

+ (instancetype)modelWithText:(NSString *)text currentID:(NSString *)currentID isSelect:(BOOL)select {
    XYItemModel *model = [[XYItemModel alloc] init];
    model.displayText = text;
    model.currentID = currentID;
    model.seleceted = select;
    return model;
}

@end
