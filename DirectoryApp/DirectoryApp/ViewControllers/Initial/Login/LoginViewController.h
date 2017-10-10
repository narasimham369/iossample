//
//  LoginViewController.h
//  Garazone
//
//  Created by Hari R Krishna on 2/13/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *validfindemail;
@property(nonatomic,strong)NSString *requiredStringPhoneType;
@property(nonatomic,strong)NSString *requiredStringPasswordType;
@end
