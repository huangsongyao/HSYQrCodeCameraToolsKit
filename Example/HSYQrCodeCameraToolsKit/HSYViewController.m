//
//  HSYViewController.m
//  HSYQrCodeCameraToolsKit
//
//  Created by 317398895@qq.com on 11/15/2019.
//  Copyright (c) 2019 317398895@qq.com. All rights reserved.
//

#import "HSYViewController.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/UIAlertController+RACSignal.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>
#import "HSYQrCameraTools.h"

@interface HSYViewController ()

@end

@implementation HSYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull  button) {
        @weakify(self);
//        [HSYQrCameraTools hsy_presentQrCodeCustomCamera:^(HSYQrCodeCameraViewController * _Nonnull viewController, NSString * _Nonnull metadataValue) { 
//            NSLog(@"x.metadata => %@", metadataValue);
//            NSLog(@"completed");
//            [button hsy_setTitle:metadataValue];
//        } discernQrCodeImage:^RACSignal<RACTuple *> * _Nonnull(NSString * _Nonnull qrString, BOOL isDiscernSuccess) {
//            BOOL stopCamera = YES;
//            BOOL backLast = YES;
//            if (!isDiscernSuccess) {
//                stopCamera = !stopCamera;
//                backLast = !backLast;
//                @strongify(self);
//                [[[UIAlertController hsy_showAlertController:self.presentedViewController title:@"failure" message:qrString alertActionTitles:@[@"YES"]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIAlertAction * _Nullable x) {}];
//            }
//            return [RACSignal hsy_sendTupleSignal:RACTuplePack(@(stopCamera), @(backLast))];
//        } forCameraTitle:@"test"];
        [HSYQrCameraTools hsy_pushQrCodeCustomCamera:^(HSYQrCodeCameraViewController * _Nonnull viewController, NSString * _Nonnull metadataValue) { 
            NSLog(@"x.metadata => %@", metadataValue);
            NSLog(@"completed");
            [button hsy_setTitle:metadataValue];
        } discernQrCodeImage:^RACSignal<RACTuple *> * _Nonnull(NSString * _Nonnull qrString, BOOL isDiscernSuccess) {
            return [RACSignal hsy_sendTupleSignal:RACTuplePack(@(YES), @(YES))];
        }];
    }];
    [button hsy_setTitle:@"clicked me"];
    button.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.5];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
