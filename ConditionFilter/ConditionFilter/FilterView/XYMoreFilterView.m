//
//  XYMoreFilterView.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/18.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYMoreFilterView.h"

#import "SeperateLine.h"
#import "XYOptionItem.h"
#import "UIColor+HexString.h"
#import "UIButton+Block.h"

#define EMPTY_STRING(string) \
( [string isKindOfClass:[NSNull class]] || \
string == nil || [string isEqualToString:@""])
#define GET_STRING(string) (EMPTY_STRING(string) ? @"" : string)
#define L(s) NSLocalizedString((s), nil)

///强弱引用
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface XYMoreFilterView ()

@property (nonatomic, strong) NSMutableArray *houseTypeArr;
@property (nonatomic, strong) NSString *currentDecorate;

@end

@implementation XYMoreFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initItems];
    }
    return self;
}

- (void)initItems {
    NSArray *itemArr = @[@"户型(可多选)", @"装修(单选)", @"其他(自定义其他条件)"];
    NSArray *conditionArr = @[@"一室", @"二室", @"三室", @"四室"];
    NSArray *decorateArr = @[@"精装", @"毛坯", @"简装"];
    self.houseTypeArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < itemArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + 120*i, 150, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.text = itemArr[i];
        [self addSubview:titleLabel];
        CGFloat width = (self.frame.size.width - 30 - 12*3)/4.0;
        if (i == 0) {
            for (int j = 0; j < conditionArr.count; j++) {
                XYOptionItem *item = [[XYOptionItem alloc] initWithFrame:CGRectMake(15 + (width+12)*j, 50+120*i, width, 30)];
                item.tag = 100 + j;
                [item setTitle:[conditionArr objectAtIndex:j] forState:UIControlStateNormal];
                @weakify(self);
                [item addAction:^(UIButton *btn) {
                    btn.selected = !btn.selected;
                    @strongify(self);
                    if (btn.selected) {
                        [self.houseTypeArr addObject:item.titleLabel.text];
                    }
                    else {
                        [self.houseTypeArr removeObject:item.titleLabel.text];
                    }
                }];
                [self addSubview:item];
            }
        }
        else if (i == 1) {
            for (int j = 0; j < decorateArr.count; j++) {
                XYOptionItem *item = [[XYOptionItem alloc] initWithFrame:CGRectMake(15 + (width+12)*j, 50+120*i, width, 30)];
                item.tag = 200 + j;
                [item setTitle:[decorateArr objectAtIndex:j] forState:UIControlStateNormal];
                
                [item addAction:^(UIButton *btn) {
                    for (UIView *view in self.subviews) {
                        if (view.tag >= 200 && view.tag < 203 && [view isKindOfClass:[XYOptionItem class]]) {
                            XYOptionItem *tmp = (XYOptionItem *)view;
                            if (tmp.tag == 200 + j) {
                                tmp.selected = !tmp.selected;
                                if (tmp.selected) {
                                    self.currentDecorate = tmp.titleLabel.text;
                                }
                                else {
                                    self.currentDecorate = @"";
                                }
                            }
                            else {
                                tmp.selected = NO;
                            }
                        }
                    }
                }];
                
                [self addSubview:item];
            }
        }
        
        SeperateLine *sepLine = [[SeperateLine alloc] initWithFrame:CGRectMake(15, 120*i, self.frame.size.width - 15, .5)];
        [self addSubview:sepLine];
        
    }
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(40, self.frame.size.height - 60, 80, 35);
    clearBtn.layer.cornerRadius = 3.0;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.borderColor = [UIColor grayColor].CGColor;
    clearBtn.layer.borderWidth = .8;
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [clearBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:clearBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(self.frame.size.width - 120, self.frame.size.height - 60, 80, 35);
    confirmBtn.layer.cornerRadius = 3.0;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    confirmBtn.layer.borderColor = [UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0].CGColor;
    [confirmBtn setTitleColor:[UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0] forState:UIControlStateNormal];
    confirmBtn.layer.borderWidth = .8;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    
}

- (void)houseItemBtnDidClick:(id)sender {
    
}


- (void)clearBtnDidClick:(id)sender {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[XYOptionItem class]]) {
            XYOptionItem *tmp = (XYOptionItem *)view;
            tmp.selected = NO;
            [self.houseTypeArr removeAllObjects];
            self.currentDecorate = @"";
        }
    }
}

- (void)confirmBtnDidClick:(id)sender {
    [self.delegate filterMoreCondition:@{
                                         @"houseType":self.houseTypeArr,
                                         @"decorateType":GET_STRING(self.currentDecorate)
                                         }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
