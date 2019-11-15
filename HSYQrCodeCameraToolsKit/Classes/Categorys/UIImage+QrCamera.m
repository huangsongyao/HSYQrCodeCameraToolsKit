//
//  UIImage+QrCamera.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "UIImage+QrCamera.h"
#import <HSYMethodsToolsKit/UIColor+Hex.h>

@implementation UIImage (QrCamera)

+ (UIImage *)hsy_imageWithQRCode:(CGRect)referenceRect
                        cropRect:(CGRect)cropRect
                 backgroundColor:(UIColor *)color
{
    CGSize referenceSize = CGSizeMake(CGRectGetWidth(referenceRect), CGRectGetHeight(referenceRect));
    //获取图片颜色的RGB
    UIGraphicsBeginImageContext(referenceSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, color.red, color.green, color.blue, color.alpha);
    //设置RGB和对应的透明度
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect drawRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    CGContextFillRect(context, drawRect);
    drawRect = CGRectMake((cropRect.origin.x - referenceRect.origin.x), (cropRect.origin.y - referenceRect.origin.y), cropRect.size.width, cropRect.size.height);
    CGContextClearRect(context, drawRect);
    
    UIImage *qrCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return qrCodeImage;
}


@end
