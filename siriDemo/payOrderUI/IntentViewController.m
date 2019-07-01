//
//  IntentViewController.m
//  payOrderUI
//
//  Created by yeqingyu on 2019/6/19.
//  Copyright © 2019 yeqingyu. All rights reserved.
//
#import "IntentViewController.h"
#import "PayOrderIntent.h"
#import "unLoginView.h"
#import "payOrderView.h"
#import "serverErrorView.h"
#import "successView.h"
#import "soldOutView.h"
@interface IntentViewController ()
@property(nonatomic,strong)unLoginView *loginView;
@property(nonatomic,strong) payOrderView*payOrderView;
@property(nonatomic,strong) serverErrorView *errorView;
@property(nonatomic,strong) successView *successView;
@property(nonatomic,strong) soldOutView *soldOutView;
@end

@implementation IntentViewController
-(soldOutView *)soldOutView{
    if (!_soldOutView) {
        _soldOutView = [soldOutView show];
    }
    return _soldOutView;
}
-(serverErrorView *)errorView{
    if (!_errorView) {
        _errorView = [serverErrorView show];
    }
    return _errorView;
}

-(successView *)successView{
    if (!_successView) {
        _successView = [successView show];
    }
    return _successView;
}
-(unLoginView *)loginView{
    if (!_loginView) {
        _loginView = [unLoginView show];
    }
    return _loginView;
}
-(payOrderView *)payOrderView{
    if (!_payOrderView) {
        _payOrderView = [payOrderView show];
    }
    return _payOrderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - INUIHostedViewControlling
- (void)configureViewForParameters:(NSSet <INParameter *> *)parameters ofInteraction:(INInteraction *)interaction interactiveBehavior:(INUIInteractiveBehavior)interactiveBehavior context:(INUIHostedViewContext)context completion:(void (^)(BOOL success, NSSet <INParameter *> *configuredParameters, CGSize desiredSize))completion {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGSize desiredSize = CGSizeZero;
    if (interaction.intentHandlingStatus ==
        INIntentHandlingStatusReady) {
          desiredSize = [self displayPayOrderView];
    }else if(interaction.intentHandlingStatus == INIntentHandlingStatusSuccess){
        INIntentResponse *intentResponse = interaction.intentResponse; //医生预约
        if ([intentResponse isKindOfClass:[PayOrderIntentResponse class]]) {
            PayOrderIntentResponse *response = (PayOrderIntentResponse *)intentResponse;
            if (response.code == PayOrderIntentResponseCodeFailureUnLogin) {
                desiredSize = [self displayPunchUnLoginResult];
            }else if(response.code == PayOrderIntentResponseCodeFailureWithServer){
                desiredSize = [self displayServerError];
            }else if(response.code == PayOrderIntentResponseCodeFailureOutDate){
                desiredSize = [self displaySoldOutView];
            }else{
                desiredSize = [self displaySuccessView];
            }
        }
    }
    if (CGSizeEqualToSize(desiredSize,CGSizeZero)) {
        completion(NO, [NSSet new], CGSizeZero);
        return;
    }else{
        if (completion) {
            completion(YES, parameters, desiredSize);
        }
    }
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

// MARK: 显示未登录页面
- (CGSize)displayPunchUnLoginResult{
    [self.view addSubview:self.loginView];
    CGRect frame = CGRectMake(0, 0, [self desiredSize].width,110);
    self.loginView.frame = frame;
    return frame.size;
}

// MARK: 显示下单支付页面
- (CGSize)displayPayOrderView{
    [self.view addSubview:self.payOrderView];
    CGRect frame = CGRectMake(0, 0, [self desiredSize].width, 110);
    self.payOrderView.frame = frame;
    return frame.size;
}

// MARK: 显示服务器接口错误页面
- (CGSize)displayServerError{
    [self.view addSubview:self.errorView];
    CGRect frame = CGRectMake(0, 0, [self desiredSize].width, 110);
    self.errorView.frame = frame;
    return frame.size;
}
// MARK: 销售完毕
- (CGSize)displaySoldOutView{
    [self.view addSubview:self.soldOutView];
    CGRect frame = CGRectMake(0, 0, [self desiredSize].width, 110);
    self.soldOutView.frame = frame;
    return frame.size;
}
// MARK: 显示下单成功
- (CGSize)displaySuccessView{
    [self.view addSubview:self.successView];
    CGRect frame = CGRectMake(0, 0, [self desiredSize].width, 110);
    self.successView.frame = frame;
    return frame.size;
}
@end
