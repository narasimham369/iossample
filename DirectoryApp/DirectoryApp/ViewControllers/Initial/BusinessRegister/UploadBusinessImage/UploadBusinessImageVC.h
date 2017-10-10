//
//  UploadBusinessImageVC.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@protocol EditBusinessProfileVCDelegate;
@interface UploadBusinessImageVC : BaseViewController
@property (nonatomic, assign) BOOL isFromBusinessEdit;
@property (nonatomic, assign) id <EditBusinessProfileVCDelegate>editProfileDelegate;
@property (nonatomic, strong) NSMutableDictionary *businessRegistrationDetails;
@end
@protocol EditBusinessProfileVCDelegate <NSObject>
@optional
-(void)closeButtonActionDelegate;
-(void)UpdateButtonActionDelegate;

@end

