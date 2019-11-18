//
//  HSYQrCameraTools.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <Foundation/Foundation.h>
#import "HSYQrCodeCameraViewController+RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HSYQrCameraToolsDidOutputMetadataBlock)(HSYQrCodeCameraViewController *viewController, NSString *metadataValue);
typedef RACSignal<RACTuple *> *_Nonnull(^HSYQrCameraToolsDiscernQrCodeImageBlock)(NSString *qrString, BOOL isDiscernSuccess);

@interface HSYQrCameraTools : NSObject

/**
 push格式的快速方法【不带有手电筒，不带有“相册”按钮的原始二维码相机】

 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 */
+ (void)hsy_pushQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;

/**
 push格式的快速方法【自带有手电筒，自带有“相册”按钮的原始二维码相机】

 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 */
+ (void)hsy_pushQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;

/**
 present格式的快速方法【不带有手电筒，不带有“相册”按钮的原始二维码相机】

 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 @param discern 识别图片二维码后的结果回调的block事件
 @param title UINavigationController的title
 */
+ (void)hsy_presentQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
             discernQrCodeImage:(HSYQrCameraToolsDiscernQrCodeImageBlock)discern
                 forCameraTitle:(nullable NSString *)title;

/**
 present格式的快速方法【自带有手电筒，自带有“相册”按钮的原始二维码相机】
 
 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 @param discern 识别图片二维码后的结果回调的block事件
 @param title UINavigationController的title
 */
+ (void)hsy_presentQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock
                   discernQrCodeImage:(HSYQrCameraToolsDiscernQrCodeImageBlock)discern
                       forCameraTitle:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
