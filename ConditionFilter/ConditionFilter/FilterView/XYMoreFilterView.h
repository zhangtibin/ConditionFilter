//
//  XYMoreFilterView.h
//  XYRenting
//
//  Created by 张体宾 on 2018/7/18.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYMoreFilterViewDelegate <NSObject>

- (void)filterMoreCondition:(NSDictionary *)conditions;

@end

@interface XYMoreFilterView : UIView

@property (nonatomic, weak) id <XYMoreFilterViewDelegate>delegate;


@end
