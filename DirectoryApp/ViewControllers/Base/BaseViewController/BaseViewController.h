//
//  BaseViewController.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Utilities.h"
#import "UrlGenerator.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import <ImageIO/ImageIO.h>
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "NSString+NSstring_Category.h"
#import <CLToolKit/CLCoreDataAdditions.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIBarButtonItem *leftBarButton;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

- (void)showButtonOnLeftWithImageName:(NSString *)imageName;
- (void)showButtonOnRightWithImageName:(NSString *)imageName;
- (void)initView;
- (void)hidenavigationBar;
- (void)initNavigationBarAppearence;
- (void)backButtonAction:(UIButton *)backButton;
- (void)rightButtonAction:(UIButton *)rightButton;
- (void)settingTitleLabelWithText:(NSString *)titleString;

@end
