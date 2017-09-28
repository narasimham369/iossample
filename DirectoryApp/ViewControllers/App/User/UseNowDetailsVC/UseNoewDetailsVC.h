//
//  UseNoewDetailsVC.h
//  DirectoryApp
//
//  Created by smacardev on 21/09/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponDetailViewController.h"
#import "SwipeImageCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import <CommonCrypto/CommonDigest.h>
@protocol CouponDelegate ;
@interface UseNoewDetailsVC : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UICollectionView *swipeImageCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *shadowCardView;
@property (nonatomic,assign) int previuosIndex;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gradientTapGesture;
@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (weak, nonatomic) CALayer *layers;

@property (weak, nonatomic) IBOutlet UILabel *dealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDecription;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;


@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (retain) UIDocumentInteractionController * documentInteractionController;
- (IBAction)NavigateToAddress:(id)sender;
- (IBAction)PhoneNumberTapAction:(id)sender;

- (IBAction)logoImageTapAction:(id)sender;
- (IBAction)gradientTapAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *availableDate;

@property (nonatomic, strong) NSMutableArray *myOffersArray;
@property (nonatomic, strong) NSMutableArray *couponImagesArray;
@property (strong, nonatomic) id bussinessDetails;
@property (nonatomic, strong) id offerDetails;
@property (assign, nonatomic) BOOL isFromBusinessOwner;
@end


