//
//  UserRegisterVC.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/15/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BaseViewController.h"

@interface UserRegisterVC : BaseViewController
@property (nonatomic, assign) BOOL isFromFacebookLogIn;
@property (nonatomic, assign) BOOL isFromEditProfile;
@property (nonatomic, strong) id fbUserDetails;
@end
