//
//  UIViewController+SystemSources.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "UIViewController+SystemSources.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIViewController (SystemSources)

+ (BOOL)hsy_haveAuthoritys
{
    return (self.class.hsy_haveCameraAuthoritys && self.class.hsy_haveOpenCameraAuthoritys);
}

+ (BOOL)hsy_haveCameraAuthoritys
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSArray *avStatus = @[@(AVAuthorizationStatusRestricted), @(AVAuthorizationStatusDenied)];
    return ([avStatus containsObject:@(status)] ? NO : YES);
}

+ (BOOL)hsy_haveOpenCameraAuthoritys
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
