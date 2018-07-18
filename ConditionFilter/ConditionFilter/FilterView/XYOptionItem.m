//
//  XYOptionItem.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/18.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYOptionItem.h"

#import "UIColor+HexString.h"

@implementation XYOptionItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3.0;
    [self setClipsToBounds:YES];
    
}

- (void)initUI {
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.layer.borderColor = [UIColor colorWithHexString:@"ebebeb"].CGColor;
    self.layer.borderWidth = .8;

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0].CGColor;
    }
    else {
        self.layer.borderColor = [UIColor colorWithHexString:@"ebebeb"].CGColor;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
