//
//  ViewController.m
//  siriDemo
//
//  Created by yeqingyu on 2019/6/19.
//  Copyright © 2019 yeqingyu. All rights reserved.
//

#import "ViewController.h"
#import "PayOrderIntent.h"
#import <IntentsUI/IntentsUI.h>


@interface ViewController ()<INUIAddVoiceShortcutViewControllerDelegate,INUIEditVoiceShortcutViewControllerDelegate>
@property(nonatomic,strong)INUIAddVoiceShortcutViewController *addShortcutVC API_AVAILABLE(ios(12.0));
@property(nonatomic,strong)INUIEditVoiceShortcutViewController *editShortcutVC API_AVAILABLE(ios(12.0));
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// MARK: 下单支付创建siri shortcut
- (IBAction)clickPay:(id)sender {
    if (@available(iOS 12.0, *)) {
        PayOrderIntent *orderIntent = [[PayOrderIntent alloc] init];
        orderIntent.name = @"男性大保健订单";
        orderIntent.price = @"100";
        orderIntent.orderId = @"1";
        INInteraction *interaction = [[INInteraction alloc] initWithIntent:orderIntent response:nil];
        [interaction donateInteractionWithCompletion:^(NSError * _Nullable error) {
            NSLog(@"error===%@",error);
        }];
    }
}

// MARK: 添加快捷方式
- (IBAction)addShortCut:(id)sender {
    if (@available(iOS 12.0, *)) {
        PayOrderIntent *intent = [[PayOrderIntent alloc] init];
        intent.name = @"男性大保健订单";
        intent.price = @"100";
        intent.orderId = @"1";
        intent.suggestedInvocationPhrase = @"下单";
        INShortcut *shortCuts = [[INShortcut alloc] initWithIntent:intent];
        INUIAddVoiceShortcutViewController *vc = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortCuts];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        // Fallback on earlier versions
    }
  
}

//完成
-(void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(INVoiceShortcut *)voiceShortcut error:(NSError *)error API_AVAILABLE(ios(12.0)){
    NSLog(@"添加快捷方式完成==%@",error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didUpdateVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消
-(void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)){
    NSLog(@"取消添加快捷方式");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**通过NSUserActivity创建捷径*/
- (IBAction)addShortCut2:(id)sender {
    [self addCreateOrderActivity];
    [self suggestUserAddShortcutToSiri];
}


///MARK:donate shortcuts
- (void)addCreateOrderActivity {
    //根据plist文件的值，创建 UserActivity
    NSUserActivity *checkInActivity = [[NSUserActivity alloc] initWithActivityType:@"RecordFood"];
    //设置 YES，通过系统的搜索，可以搜索到该 UserActivity
    checkInActivity.eligibleForSearch = YES;
  //允许系统预测用户行为，并在合适的时候给出提醒。（搜索界面，屏锁界面等。）
    if (@available(iOS 12.0, *)) {
        checkInActivity.eligibleForPrediction = YES;
    }
    checkInActivity.title = @"咖啡快捷下单";
    checkInActivity.userInfo = @{@"key1":@"value1"};
    checkInActivity.keywords = [NSSet setWithObjects:@"咖啡",@"下单", nil];
    //引导用户新建语音引导（具体效果见下图）
    if (@available(iOS 12.0, *)) {
        checkInActivity.suggestedInvocationPhrase = @"咖啡下单";
    }
//    CSSearchableItemAttributeSet * attributes = [[CSSearchableItemAttributeSet alloc] init];
//    UIImage *icon = [UIImage imageNamed:@"about_us_logo"];
//    attributes.thumbnailData = UIImagePNGRepresentation(icon);
//    attributes.contentDescription = @"每天一杯咖啡，Lucy in coffee";
//    checkInActivity.contentAttributeSet = attributes;
    self.userActivity = checkInActivity;
}


///MARK:建议用户添加shortcuta到Siri短语
- (void)suggestUserAddShortcutToSiri {
    if (@available(iOS 12.0, *)) {
        [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts, NSError * _Nullable error) {
            BOOL isAdd = NO;
            INVoiceShortcut *shortcut = nil;
            for (INVoiceShortcut *voice in voiceShortcuts) {
                NSLog(@"====>>获取到的VoiceShortcuts :%@",voice.shortcut.userActivity.activityType);
                if ([voice.shortcut.userActivity.activityType isEqualToString:@"RecordFood"]) {
                    isAdd = YES;
                    shortcut = voice;
                    NSLog(@"===>>>快捷下单shortcut已经添加到Siri");
                    NSLog(@"添加内容==%@",voice.invocationPhrase);
                }
            }
            if (isAdd) {
                [self openEditVoiceVC:shortcut];
            } else {
                [self openAddVoiceVC];
            }
        }];
    }
}


///MARK:打开Siri添加短语页面
- (void)openAddVoiceVC {
    if (@available(iOS 12.0, *)) {
        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
        INUIAddVoiceShortcutViewController *addVc = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
        if (!addVc.delegate) {
            addVc.delegate = self;
        }
        
        [self presentViewController:addVc animated:YES completion:^{
            self.addShortcutVC = addVc;
        }];
    }
}
///MARK:打开Siri编辑短语页面
- (void)openEditVoiceVC:(INVoiceShortcut *)voiceShortcut  API_AVAILABLE(ios(12.0)){
    if (@available(iOS 12.0, *)) {
        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
        INUIEditVoiceShortcutViewController *editVC = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:voiceShortcut];
        if (!editVC.delegate) {
            editVC.delegate = self;
        }
        [self presentViewController:editVC animated:YES completion:^{
            self.editShortcutVC = editVC;
        }];
    }
}

-(void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didDeleteVoiceShortcutWithIdentifier:(NSUUID *)deletedVoiceShortcutIdentifier API_AVAILABLE(ios(12.0)){
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)editVoiceShortcutViewControllerDidCancel:(INUIEditVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)){
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
