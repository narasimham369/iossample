//
//  SayThanksVC.h
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SayThanksVC : BaseViewController
@property (nonatomic, assign) BOOL isFromSpecialCoupon;
@property (nonatomic, assign) BOOL isBusinessFavourites;
@property (nonatomic, strong) id recommendDetails;

@end
