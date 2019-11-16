//
//  HSYQrCameraTools.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "HSYQrCameraTools.h"
#import <HSYMethodsToolsKit/UIViewController+Controller.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import "HSYCustomQrCodeCameraViewController.h"

@implementation HSYQrCameraTools

+ (void)hsy_pushQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
{
    HSYQrCodeCameraViewController *vc = [[HSYQrCodeCameraViewController alloc] init];
    [[vc.rac_qrCodeCamera deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYQrCodeCameraDidOutputMetadataBlock  _Nullable x) {
        [[x(RACTuplePack(@(YES), @(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable tuple) {
            if (metadataBlock) {
                metadataBlock(tuple.second, tuple.first);
            }
        }];
    }];
    [UIViewController.hsy_currentViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)hsy_pushQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
{
    HSYCustomQrCodeCameraViewController *vc = [[HSYCustomQrCodeCameraViewController alloc] init];
    [[vc.rac_qrCodeCamera deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYQrCodeCameraDidOutputMetadataBlock  _Nullable x) {
        [[x(RACTuplePack(@(YES), @(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable tuple) {
            if (metadataBlock) {
                metadataBlock(tuple.second, tuple.first);
            }
        }];
    }];
    [UIViewController.hsy_currentViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)hsy_presentQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock forCameraTitle:(nullable NSString *)title
{
    HSYQrCodeCameraViewController *vc = [[HSYQrCodeCameraViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.navigationBar.topItem.title = (title.length ? title : HSYLOCALIZED(@"扫一扫"));
    [[vc.rac_qrCodeCamera deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYQrCodeCameraDidOutputMetadataBlock  _Nullable x) {
        [[x(RACTuplePack(@(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable tuple) {
            if (metadataBlock) {
                metadataBlock(tuple.second, tuple.first);
            }
        }];
    }];
    [UIViewController.hsy_currentViewController presentViewController:navigationController animated:YES completion:nil];
}

+ (void)hsy_presentQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock forCameraTitle:(nullable NSString *)title
{
    HSYCustomQrCodeCameraViewController *vc = [[HSYCustomQrCodeCameraViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.navigationBar.topItem.title = (title.length ? title : HSYLOCALIZED(@"扫一扫"));
    [[vc.rac_qrCodeCamera deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYQrCodeCameraDidOutputMetadataBlock  _Nullable x) {
        [[x(RACTuplePack(@(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable tuple) {
            if (metadataBlock) {
                metadataBlock(tuple.second, tuple.first);
            }
        }];
    }];
    [UIViewController.hsy_currentViewController presentViewController:navigationController animated:YES completion:nil];
}

@end
