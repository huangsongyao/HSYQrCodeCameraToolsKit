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
#import "ZLPhotoActionSheet+RACSignal.h"
#import <HSYMethodsToolsKit/UINavigationBar+NavigationItem.h>
#import <HSYMethodsToolsKit/CIDetector+QRImage.h>

@implementation HSYQrCameraTools

#pragma mark - Push

+ (void)hsy_pushQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
{
    [self.class hsy_pushQrCodeCamera:metadataBlock isCustomCamera:NO];
}

+ (void)hsy_pushQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
{
    [self.class hsy_pushQrCodeCamera:metadataBlock isCustomCamera:YES];
}

+ (void)hsy_pushQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock isCustomCamera:(BOOL)isCustom
{
    HSYQrCodeCameraViewController *vc = [[NSClassFromString(@{@(YES) : NSStringFromClass([HSYCustomQrCodeCameraViewController class]),
                                                              @(NO) : NSStringFromClass([HSYQrCodeCameraViewController class])}[@(isCustom)]) alloc] init];
    [[vc.rac_qrCodeCamera deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYQrCodeCameraDidOutputMetadataBlock  _Nullable x) {
        [[x(RACTuplePack(@(YES), @(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable tuple) {
            if (metadataBlock) {
                metadataBlock(tuple.second, tuple.first);
            }
        }];
    }];
    [UIViewController.hsy_currentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Present

+ (void)hsy_presentQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
             discernQrCodeImage:(HSYQrCameraToolsDiscernQrCodeImageBlock)discern
                 forCameraTitle:(nullable NSString *)title
{
    [self.class hsy_presentQrCodeCamera:metadataBlock discernQrCodeImage:discern forCameraTitle:title isCustomCamera:NO];
}

+ (void)hsy_presentQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
                   discernQrCodeImage:(HSYQrCameraToolsDiscernQrCodeImageBlock)discern
                       forCameraTitle:(nullable NSString *)title
{
    [self.class hsy_presentQrCodeCamera:metadataBlock discernQrCodeImage:discern forCameraTitle:title isCustomCamera:YES];
}

+ (void)hsy_presentQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
             discernQrCodeImage:(HSYQrCameraToolsDiscernQrCodeImageBlock)discern
                 forCameraTitle:(nullable NSString *)title isCustomCamera:(BOOL)isCustom
{
    HSYQrCodeCameraViewController *vc = [[NSClassFromString(@{@(YES) : NSStringFromClass([HSYCustomQrCodeCameraViewController class]),
                                                              @(NO) : NSStringFromClass([HSYQrCodeCameraViewController class])}[@(isCustom)]) alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.navigationBar.topItem.title = (title.length ? title : HSYLOCALIZED(@"扫一扫"));
    @weakify(vc);
    vc.navigationItem.rightBarButtonItems = [UINavigationBar hsy_titleNavigationItems:@[@{@{@(1212) : [UIFont systemFontOfSize:15]} : @{HSYLOCALIZED(@"相册") : HSY_RGB(51,51,51)}}] leftEdgeInsets:0.0 subscribeNext:^(UIButton * _Nonnull button, NSInteger tag) {
        [[ZLPhotoActionSheet hsy_singleSelectedPhoto] subscribeNext:^(RACTuple * _Nullable x) {
            NSString *qrString = [CIDetector hsy_detectorQRImage:x.first];
            if (discern) {
                BOOL discerned = (![qrString isEqualToString:@"not features!"]);
                [[discern(qrString, discerned) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
                    @strongify(vc);
                    [vc hsy_disposeQrCamera:x];
                }];
            }
        }];
    }];
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
