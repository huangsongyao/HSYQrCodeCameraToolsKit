//
//  UIImage+QrCamera.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QrCamera)

/**
 绘制一张固定区域的中空的二维码相机背景图片

 @param referenceRect 绘制的二维码图片添加到父视图的父视图的frame
 @param cropRect 绘制的二维码图片的中部扫描有效区域的frame
 @param color 绘制的二维码图片的背景色
 @return 二维码相机的背景图
 */
+ (UIImage *)hsy_imageWithQRCode:(CGRect)referenceRect
                        cropRect:(CGRect)cropRect
                 backgroundColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
