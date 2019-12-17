//
//  HSYCustomQrCodeCameraViewController.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/15.
//

#import "HSYCustomQrCodeCameraViewController.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/NSBundle+PrivateFileResource.h>
#import <Masonry/Masonry.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/UIAlertController+RACSignal.h>

@interface HSYCustomQrCodeCameraViewController () {
    @private UIButton *_lightButton;
}

@end

@implementation HSYCustomQrCodeCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lightButton.selected = NO;
    // Do any additional setup after loading the view.
}

#pragma mark - Load

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.lightButton.selected) {
        [self hsy_cameraDeviceConfiguration:YES];
        self.lightButton.selected = !self.lightButton.selected;
    }
}

#pragma mark - Lazy

- (UIButton *)lightButton
{
    if (!_lightButton) {
        NSDictionary *dictionary = @{@(YES) : @{HSYLOCALIZED(@"打开手电筒") : @"open_light_icon"}, @(NO) : @{HSYLOCALIZED(@"关闭手电筒") : @"close_light_icon"}};
        @weakify(self);
        _lightButton = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
            @strongify(self);
            if ([self.hsy_captureDevice hasTorch]) {
                [self hsy_cameraDeviceConfiguration:button.selected];
            } else {
                NSString *title = HSYLOCALIZED(@"您的手机可能没有闪光灯设备或者您尚未授权本应用访问您的闪光灯设备");
                [[[UIAlertController hsy_showAlertController:self title:title message:[NSString stringWithFormat:@"%@，暂时无法提供手电筒功能，请检查后再试", title] alertActionTitles:@[HSYLOCALIZED(@"知道了")]] deliverOn:[RACScheduler mainThreadScheduler ]] subscribeNext:^(UIAlertAction * _Nullable x) {}];
            }
            if (self.haveAuthoritys) {
                button.selected = !button.selected;
            }
        }];
        [_lightButton setImage:[NSBundle hsy_imageForBundle:[dictionary[@(NO)] allValues].firstObject] forState:UIControlStateNormal];
        [_lightButton setImage:[NSBundle hsy_imageForBundle:[dictionary[@(YES)] allValues].firstObject] forState:UIControlStateSelected];
        [_lightButton setTitle:[dictionary[@(NO)] allKeys].firstObject forState:UIControlStateNormal];
        [_lightButton setTitle:[dictionary[@(YES)] allKeys].firstObject forState:UIControlStateSelected];
        [self.view addSubview:_lightButton];
        
        [_lightButton hsy_setImagePosition:kHSYMethodsToolsButtonImagePositionBottom forSpacing:7.0f];
        _lightButton.origin = CGPointMake((IPHONE_WIDTH - _lightButton.width)/2.0f, (IPHONE_HEIGHT - _lightButton.height - 40.0));
    }
    return _lightButton;
}

- (void)hsy_cameraDeviceConfiguration:(BOOL)closed
{
    NSError *error = nil;
    BOOL lock = [self.hsy_captureDevice lockForConfiguration:&error];
    if (lock) {
        AVCaptureTorchMode torchMode = (closed ? AVCaptureTorchModeOff : AVCaptureTorchModeOn);
        [self.hsy_captureDevice setTorchMode:torchMode];
        [self.hsy_captureDevice unlockForConfiguration];
    }
}

@end
