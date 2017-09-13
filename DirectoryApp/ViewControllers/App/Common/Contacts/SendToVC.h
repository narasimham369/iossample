//
//  SendToVC.h
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SendToVC : BaseViewController
@property (nonatomic, assign) BOOL isFromProductDetail;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSURL *itemImageUrl;
@property (strong, nonatomic) NSString *bussinessId;
@property (strong, nonatomic) id bussinessDetails;
@property (nonatomic, strong) NSMutableArray *myOffersArray;
@end
