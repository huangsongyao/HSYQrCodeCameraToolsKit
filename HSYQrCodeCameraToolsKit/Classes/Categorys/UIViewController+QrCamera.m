//
//  UIViewController+QrCamera.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "UIViewController+QrCamera.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>

@implementation UIViewController (QrCamera)

- (CGRect)hsy_qrCodeScaning:(CGRect)rect
{
    CGFloat fullWidth = self.view.width;
    CGFloat fullHeight = self.view.height; 
    
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    if (x + width > fullWidth) {
        if (width > fullWidth) {
            width = fullWidth;
        } else {
            x = 0;
        }
    }
    
    if (y + height > fullHeight) {
        if (height > fullHeight) {
            height = fullHeight;
        } else {
            y = 0;
        }
    }
    
    CGFloat validZoneX = (fullWidth - width - x) / fullWidth;
    CGFloat validZoneY = y / fullHeight;
    CGFloat validZoneWidth = width / fullWidth;
    CGFloat validZoneHeight = height / fullHeight;
    
    return CGRectMake(validZoneY, validZoneX, validZoneHeight, validZoneWidth);
}


@end
