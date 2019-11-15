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

- (UIButton *)lightButton
{
    if (!_lightButton) {
        NSDictionary *dictionary = @{@(YES) : @{@"打开手电筒" : @"open_light_icon"}, @(NO) : @{@"关闭手电筒" : @"close_light_icon"}};
        _lightButton = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
        }];
        [_lightButton setImage:[NSBundle hsy_imageForBundle:[dictionary[@(NO)] allValues].firstObject] forState:UIControlStateNormal];
        [_lightButton setImage:[NSBundle hsy_imageForBundle:[dictionary[@(YES)] allValues].firstObject] forState:UIControlStateSelected];
        [_lightButton setTitle:[dictionary[@(NO)] allKeys].firstObject forState:UIControlStateNormal];
        [_lightButton setTitle:[dictionary[@(YES)] allKeys].firstObject forState:UIControlStateSelected];
        [self.view addSubview:_lightButton];
        [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(HSY_IS_iPhoneX ? 40.0 : 20.0));
            make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH, 65.0f));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _lightButton;
}


@end
