//
//  HSYViewController.m
//  HSYQrCodeCameraToolsKit
//
//  Created by 317398895@qq.com on 11/15/2019.
//  Copyright (c) 2019 317398895@qq.com. All rights reserved.
//

#import "HSYViewController.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>
#import "HSYQrCameraTools.h"

@interface HSYViewController () <HSYQrCodeCameraViewControllerDelegate>

@end

@implementation HSYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull  button) {
        //        HSYQrCodeCameraViewController *vc = [[HSYQrCodeCameraViewController alloc] init];
        //        vc.qrDelegate = self;
        //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        //        [self presentViewController:navigationController animated:YES completion:nil];
        [HSYQrCameraTools  hsy_presentQrCodeCustomCamera:^(HSYQrCodeCameraViewController * _Nonnull viewController, NSString * _Nonnull metadataValue) {
            NSLog(@"x.metadata => %@", metadataValue);
            NSLog(@"completed");
            [button hsy_setTitle:metadataValue];
        }];
        //        [HSYQrCameraTools hsy_presentQrCodeCamera:^(HSYQrCodeCameraViewController * _Nonnull viewController, NSString * _Nonnull metadataValue) {
        //            NSLog(@"x.metadata => %@", metadataValue);
        //            NSLog(@"completed");
        //            [button hsy_setTitle:metadataValue];
        //        }];
    }];
    [button hsy_setTitle:@"clicked me"];
    button.backgroundColor = UIColor.greenColor;
    button.frame = self.view.bounds;
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - HSYQrCodeCameraViewControllerDelegate

- (void)hsy_qrCodeDidOutputMetadata:(RACSignal<RACTuple *> * _Nonnull (^)(RACTuple * _Nonnull))metadata
{
    [[metadata(RACTuplePack(@(YES), @(YES),  @(YES)))  deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"x.metadata => %@", x.first);
        NSLog(@"completed");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
