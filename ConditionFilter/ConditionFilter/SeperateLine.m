//
//  SeperateLine.m
//  XYRenting
//
//  Created by 张体宾 on 2018/6/28.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "SeperateLine.h"

#import "UIColor+HexString.h"

@implementation SeperateLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        
        [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0.5)];
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //ios6需要延迟加载
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.2];
    }
    return self;
}

- (void)reset{
    [self setBackgroundColor:[UIColor colorWithHexString:@"dadada"]];
    [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0.5)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
