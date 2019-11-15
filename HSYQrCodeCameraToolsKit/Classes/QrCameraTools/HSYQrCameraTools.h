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

@interface HSYQrCameraTools : NSObject

/**
 push格式的快速方法

 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 */
+ (void)hsy_pushQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;
+ (void)hsy_pushQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;

/**
 present格式的快速方法

 @param metadataBlock 二维码相机扫描结果后续操作的block回调事件
 */
+ (void)hsy_presentQrCodeCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;
+ (void)hsy_presentQrCodeCustomCamera:(HSYQrCameraToolsDidOutputMetadataBlock)metadataBlock;

@end

NS_ASSUME_NONNULL_END
