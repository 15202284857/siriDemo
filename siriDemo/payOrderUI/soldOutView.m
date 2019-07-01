
//
//  soldOutView.m
//  payOrderUI
//
//  Created by yeqingyu on 2019/6/19.
//  Copyright © 2019 yeqingyu. All rights reserved.
//

#import "soldOutView.h"

@implementation soldOutView
+(instancetype)show{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
