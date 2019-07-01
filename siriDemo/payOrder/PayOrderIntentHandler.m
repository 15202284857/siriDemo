
//
//  PayOrderIntentHandler.m
//  payOrder
//
//  Created by yeqingyu on 2019/6/19.
//  Copyright © 2019 yeqingyu. All rights reserved.
//
#define isLogin YES  //是否登录
#define isSoldOut NO//是否销售完毕
#import "PayOrderIntentHandler.h"
@implementation PayOrderIntentHandler
-(void)confirmPayOrder:(PayOrderIntent *)intent completion:(void (^)(PayOrderIntentResponse * _Nonnull))completion{
    NSLog(@"%s",__func__);
    
    PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc]initWithCode:PayOrderIntentResponseCodeContinueInApp userActivity:nil];
    completion(response);
//
//    if (!isLogin) {//未登录
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc]initWithCode:PayOrderIntentResponseCodeFailureUnLogin userActivity:nil];
//        completion(response);
//    }else if (isSoldOut) {//销售完毕
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc]initWithCode:PayOrderIntentResponseCodeFailureOutDate userActivity:nil];
//        completion(response);
//    }else{//准备完成
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc]initWithCode:PayOrderIntentResponseCodeReady userActivity:nil];
//        completion(response);
//    }
}

//- (void)handlePayOrder:(nonnull PayOrderIntent *)intent completion:(nonnull void (^)(PayOrderIntentResponse * _Nonnull))completion {
//    NSLog(@"%s",__func__);
//    if (!isLogin) {
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc] initWithCode:PayOrderIntentResponseCodeContinueInApp userActivity:nil];
//        completion(response);
//    }else if(isSoldOut){
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc] initWithCode:PayOrderIntentResponseCodeContinueInApp userActivity:nil];
//        completion(response);
//    }else{
//        PayOrderIntentResponse *response = [[PayOrderIntentResponse alloc] initWithCode:PayOrderIntentResponseCodeSuccess userActivity:nil];
//        completion(response);
//    }
//}

@end
