//
//  IntentHandler.m
//  payOrder
//
//  Created by yeqingyu on 2019/6/19.
//  Copyright © 2019 yeqingyu. All rights reserved.
//

#import "IntentHandler.h"
#import "PayOrderIntent.h"
#import "PayOrderIntentHandler.h"

@interface IntentHandler ()

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    if ([intent isKindOfClass:[PayOrderIntent class]]) {//医生预约
        PayOrderIntentHandler *hander = [[PayOrderIntentHandler alloc]init];
        return hander;
    }
    return nil;
}


@end
