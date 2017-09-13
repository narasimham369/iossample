//
//  CouponDetailViewController.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol CouponDelegate ;
@interface CouponDetailViewController : BaseViewController
@property (assign, nonatomic) BOOL isFromSavedCoupon;
@property (assign, nonatomic) BOOL isFromSurpriseBox;
@property (assign, nonatomic) BOOL isFromBusinessOwner;
@property (nonatomic, strong) id offerDetails;
@property (nonatomic, strong) NSMutableArray *myOffersArray;
@property (nonatomic, strong) NSMutableArray *couponImagesArray;
@property (nonatomic,strong) id<CouponDelegate>couponDelegate;
@property (strong, nonatomic) id bussinessDetails;
@property (nonatomic) NSInteger indexPath;
@end


@protocol CouponDelegate <NSObject>
@optional
- (void)CouponBackPressed:(id)updatedValue :(NSInteger)index;
@end
